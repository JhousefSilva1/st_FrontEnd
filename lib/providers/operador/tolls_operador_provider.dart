import 'package:flutter/material.dart';
import 'package:smarttolls/api/api.dart';
import 'package:smarttolls/api/request/operador/tolls/transaction_request.dart';
import 'package:smarttolls/api/response/admin/st_vehicles_response.dart';
import 'package:smarttolls/api/response/customer/st_wallet_response.dart';
import 'package:smarttolls/api/response/admin/st_country_response.dart';
import 'package:smarttolls/api/response/admin/st_city_response.dart';

class TollsOperadorProvider extends ChangeNotifier {
  bool _isCharging = false;
  List<StTollsResponse> _tolls = [];
  StTollsResponse? _selectedToll;
  List<StVehicleResponse> _foundVehicles = [];
  StVehicleResponse? _selectedVehicle;
  StWalletResponse? _vehicleWallet;
  bool _isLoading = false;
  String? _errorMessage;
  String _licensePlateQuery = '';
  final double _tollChargeAmount = 5.0;

  // Filtros de ubicación
  int? _selectedCountryId;
  int? _selectedCityId;
  int? _selectedPlaceId;
  List<StCountryResponse> _countries = [];
  List<StCityResponse> _cities = [];
  List<StPlaceResponse> _places = [];

  // Getters
  List<StTollsResponse> get tolls => _tolls;
  StTollsResponse? get selectedToll => _selectedToll;
  List<StVehicleResponse> get foundVehicles => _foundVehicles;
  StVehicleResponse? get selectedVehicle => _selectedVehicle;
  StWalletResponse? get vehicleWallet => _vehicleWallet;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String get licensePlateQuery => _licensePlateQuery;
  double get tollChargeAmount => _tollChargeAmount;
  int? get selectedCountryId => _selectedCountryId;
  int? get selectedCityId => _selectedCityId;
  int? get selectedPlaceId => _selectedPlaceId;
  List<StCountryResponse> get countries => _countries;
  List<StCityResponse> get cities => _cities;
  List<StPlaceResponse> get places => _places;

  void clearAllFields() {
    _selectedToll = null;
    _foundVehicles = [];
    _selectedVehicle = null;
    _vehicleWallet = null;
    _licensePlateQuery = '';
    _selectedCountryId = null;
    _selectedCityId = null;
    _selectedPlaceId = null;
    _cities = [];
    _places = [];
    _errorMessage = null;
    notifyListeners();
  }

  Future<void> loadAllTolls() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await SmartTollsApi().getAllTolls();
      if (response.isSuccess()) {
        _tolls = response.dataList ?? [];
        if (_selectedPlaceId != null) {
          _tolls = _tolls.where((toll) => toll.places.idPlaces == _selectedPlaceId).toList();
        }
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

  Future<void> loadCountries() async {
    _isLoading = true;
    notifyListeners();
    try {
      final response = await SmartTollsApi().getAllCountries();
      if (response.isSuccess()) {
        _countries = response.dataList ?? [];
      }
    } catch (e) {
      _errorMessage = 'Error al cargar países: ${e.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadCitiesByCountry(int countryId) async {
    _isLoading = true;
    notifyListeners();
    try {
      final response = await SmartTollsApi().getCitiesByCountry(countryId);
      if (response.isSuccess()) {
        _cities = response.dataList ?? [];
        _selectedCountryId = countryId;
        _selectedCityId = null;
        _selectedPlaceId = null;
        _places = [];
      }
    } catch (e) {
      _errorMessage = 'Error al cargar ciudades: ${e.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadPlacesByCity(int cityId) async {
    _isLoading = true;
    notifyListeners();
    try {
      final response = await SmartTollsApi().getPlacesByCity(cityId);
      if (response.isSuccess()) {
        _places = response.dataList ?? [];
        _selectedCityId = cityId;
        _selectedPlaceId = null;
      }
    } catch (e) {
      _errorMessage = 'Error al cargar lugares: ${e.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void selectPlace(int placeId) {
    _selectedPlaceId = placeId;
    notifyListeners();
    loadAllTolls();
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
      final allVehiclesResponse = await SmartTollsApi().getAllVehicles();
      if (allVehiclesResponse.isSuccess()) {
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
    if (_isCharging) return false;
    _isCharging = true;
    _isLoading = true;
    notifyListeners();

    try {
      // Validaciones iniciales
      if (_selectedToll == null || _selectedVehicle == null || _vehicleWallet == null) {
        throw Exception('Datos incompletos para el cobro');
      }

      final currentBalance = _vehicleWallet!.balance ?? 0;
      if (currentBalance < _tollChargeAmount) {
        throw Exception('Saldo insuficiente');
      }

      // 1. Primero actualizar el saldo
      final walletResponse = await SmartTollsApi().updateWalletBalance(
        _vehicleWallet!.idWallet!,
        -_tollChargeAmount,
      );

      if (!walletResponse.isSuccess()) {
        throw Exception(walletResponse.message ?? 'Error al actualizar saldo');
      }

      // 2. Registrar la transacción
      final transactionRequest = TransactionRequest(
        vehicleId: _selectedVehicle!.idVehicle!,
        tollId: _selectedToll!.idTolls!,
        walletId: _vehicleWallet!.idWallet!,
      );

      final transactionResponse = await SmartTollsApi().registerTollPass(transactionRequest);

      if (!transactionResponse.isSuccess()) {
        // Revertir el cargo si falla el registro
        await SmartTollsApi().updateWalletBalance(
          _vehicleWallet!.idWallet!,
          _tollChargeAmount,
        );
        throw Exception(transactionResponse.message ?? 'Error al registrar transacción');
      }

      // Actualizar estado local
      _vehicleWallet = walletResponse.data;
      _clearAfterPayment();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _isCharging = false;
      _isLoading = false;
      notifyListeners();
    }
  }

  void _clearAfterPayment() {
    _selectedVehicle = null;
    _vehicleWallet = null;
    _licensePlateQuery = '';
    _foundVehicles = [];
  }

  void retryLoading() {
    _errorMessage = null;
    notifyListeners();
    loadAllTolls();
  }
  
}
