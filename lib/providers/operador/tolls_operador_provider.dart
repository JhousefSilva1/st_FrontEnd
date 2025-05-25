import 'package:flutter/material.dart';
import 'package:smarttolls/api/api.dart';
import 'package:smarttolls/api/response/admin/st_vehicles_response.dart';
import 'package:smarttolls/api/response/customer/st_wallet_response.dart';
import 'package:smarttolls/models/st_response.dart';

class TollsOperadorProvider extends ChangeNotifier {
  List<StTollsResponse> _tolls = [];
  StTollsResponse? _selectedToll;
  List<StVehicleResponse> _foundVehicles = [];
  StVehicleResponse? _selectedVehicle;
  StWalletResponse? _vehicleWallet;
  bool _isLoading = false;
  String? _errorMessage;
  String _licensePlateQuery = '';
  final double _tollChargeAmount = 2.0; // Monto fijo del peaje

  List<StTollsResponse> get tolls => _tolls;
  StTollsResponse? get selectedToll => _selectedToll;
  List<StVehicleResponse> get foundVehicles => _foundVehicles;
  StVehicleResponse? get selectedVehicle => _selectedVehicle;
  StWalletResponse? get vehicleWallet => _vehicleWallet;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String get licensePlateQuery => _licensePlateQuery;
  double get tollChargeAmount => _tollChargeAmount;

  Future<void> loadAllTolls() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await SmartTollsApi().getAllTolls();
      
      if (response.isSuccess()) {
        _tolls = response.dataList ?? [];
        if (_tolls.isNotEmpty) {
          _selectedToll = _tolls.first;
        }
      } else {
        _errorMessage = response.message ?? 'Error al cargar los peajes';
      }
    } catch (e) {
      _errorMessage = 'Error: ${e.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void setLicensePlateQuery(String query) {
    _licensePlateQuery = query;
    notifyListeners();
  }

  void selectToll(StTollsResponse? toll) {
    _selectedToll = toll;
    notifyListeners();
  }

  Future<void> searchVehicleByLicensePlate() async {
    if (_licensePlateQuery.isEmpty) return;

    _isLoading = true;
    _errorMessage = null;
    _foundVehicles = [];
    _selectedVehicle = null;
    _vehicleWallet = null;
    notifyListeners();

    try {
      // Primero buscamos todos los vehículos (esto podría optimizarse con un endpoint específico)
      final allVehiclesResponse = await SmartTollsApi().getAllVehicles();
      
      if (allVehiclesResponse.isSuccess()) {
        // Filtramos por matrícula (case insensitive)
        _foundVehicles = (allVehiclesResponse.dataList ?? []).where((vehicle) {
          return vehicle.licensePlate?.toLowerCase().contains(_licensePlateQuery.toLowerCase()) ?? false;
        }).toList();

        if (_foundVehicles.isEmpty) {
          _errorMessage = 'No se encontró vehículo con esa matrícula';
        }
      } else {
        _errorMessage = allVehiclesResponse.message ?? 'Error al buscar vehículos';
      }
    } catch (e) {
      _errorMessage = 'Error: ${e.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> selectVehicle(StVehicleResponse vehicle) async {
    _selectedVehicle = vehicle;
    _errorMessage = null;
    notifyListeners();

    // Cargamos la wallet del vehículo seleccionado
    await _loadVehicleWallet();
  }

  Future<void> _loadVehicleWallet() async {
    if (_selectedVehicle?.idVehicle == null) return;

    _isLoading = true;
    notifyListeners();

    try {
      final walletResponse = await SmartTollsApi().getWalletByVehicleId(_selectedVehicle!.idVehicle!);
      
      if (walletResponse.isSuccess()) {
        _vehicleWallet = walletResponse.data;
      } else {
        _errorMessage = walletResponse.message ?? 'Error al cargar la billetera del vehículo';
      }
    } catch (e) {
      _errorMessage = 'Error: ${e.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> chargeTollFee(BuildContext context) async {
    if (_selectedToll == null || _selectedVehicle == null || _vehicleWallet == null) {
      _errorMessage = 'Seleccione un peaje y un vehículo válido';
      notifyListeners();
      return false;
    }

    if ((_vehicleWallet?.balance ?? 0) < _tollChargeAmount) {
      _errorMessage = 'El vehículo no tiene saldo suficiente';
      notifyListeners();
      return false;
    }

    _isLoading = true;
    notifyListeners();

    try {
      final response = await SmartTollsApi().updateWalletBalance(
        _vehicleWallet!.idWallet!,
        -_tollChargeAmount, // Enviamos negativo para restar
      );

      if (response.isSuccess()) {
        // Actualizamos el saldo localmente
        _vehicleWallet = response.data;
        
        // Mostrar mensaje de éxito
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Cobro exitoso: Bs. $_tollChargeAmount')),
        );

        // Limpiar selección para nuevo cobro
        _selectedVehicle = null;
        _vehicleWallet = null;
        _licensePlateQuery = '';
        
        return true;
      } else {
        _errorMessage = response.message ?? 'Error al realizar el cobro';
        return false;
      }
    } catch (e) {
      _errorMessage = 'Error: ${e.toString()}';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void retryLoading() {
    _errorMessage = null;
    notifyListeners();
    loadAllTolls();
  }
}