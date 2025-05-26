import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:smarttolls/api/api.dart';
import 'package:smarttolls/api/response/admin/st_vehicles_response.dart';
import 'package:smarttolls/api/response/customer/st_wallet_response.dart';
import 'package:smarttolls/api/response/operador/tolls/transaction_response.dart';
import 'package:smarttolls/config/preferences.dart';
import 'package:smarttolls/views/views.dart';

class WalletProvider extends ChangeNotifier {
  int _itemSelectOpt = 6;
  int get itemSelectOpt => _itemSelectOpt;
  
  List<StVehicleResponse> _vehicles = [];
  StVehicleResponse? _selectedVehicle;

  List<TransactionResponse> _transactions = [];
  List<TransactionResponse> get transactions => _transactions;
  StWalletResponse? _selectedVehicleWallet;
  bool _isLoading = false;
  String? _errorMessage;

  List<StVehicleResponse> get vehicles => _vehicles;
  StVehicleResponse? get selectedVehicle => _selectedVehicle;
  StWalletResponse? get selectedVehicleWallet => _selectedVehicleWallet;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> loadUserVehicles() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final personId = await Preferences().personId();
      if (personId == 0) {
        _errorMessage = 'No se pudo obtener el ID del usuario';
        return;
      }

      final response = await SmartTollsApi().getVehiclesByPersonId(personId);
      
      if (response.isSuccess()) {
        _vehicles = response.dataList ?? [];
        if (_vehicles.isNotEmpty) {
          _selectedVehicle = _vehicles.first;
          await _loadWalletForSelectedVehicle();
        }
      } else {
        _errorMessage = response.message ?? 'Error al cargar los vehículos';
      }
    } catch (e) {
      _errorMessage = 'Error: ${e.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // transactions
  Future<void> loadTransactionsForVehicle(int vehicleId) async {
    _isLoading = true;
    _errorMessage = null;
    // notifyListeners();

    try {
      final response = await SmartTollsApi().getTransactionsByVehicleId(vehicleId);
      
      if (response.isSuccess()) {
        _transactions = response.dataList ?? [];
      } else {
        _errorMessage = response.message ?? 'Error al cargar transacciones';
      }
    } catch (e) {
      _errorMessage = 'Error: ${e.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _loadWalletForSelectedVehicle() async {
    if (_selectedVehicle?.idVehicle == null) return;
    
    final walletResponse = await SmartTollsApi().getWalletByVehicleId(_selectedVehicle!.idVehicle!);
    if (walletResponse.isSuccess()) {
      _selectedVehicleWallet = walletResponse.data;
    }
    notifyListeners();
  }

  

  

  void selectVehicle(StVehicleResponse? vehicle) async {
    _selectedVehicle = vehicle;
    await _loadWalletForSelectedVehicle();
    notifyListeners();
  }
   double _selectedAmount = 0.0;
  double get selectedAmount => _selectedAmount;
  
  StVehicleResponse? _vehicleToRecharge;
  StVehicleResponse? get vehicleToRecharge => _vehicleToRecharge;

  // Método para preparar la recarga
  void prepareRecharge(StVehicleResponse vehicle, double amount) {
    _vehicleToRecharge = vehicle;
    _selectedAmount = amount;
    notifyListeners();
  }

  // Método para realizar la recarga
 Future<void> confirmRecharge(BuildContext context) async {
    if (_vehicleToRecharge == null || 
        _vehicleToRecharge?.idVehicle == null || 
        _selectedVehicleWallet?.idWallet == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No se ha seleccionado un vehículo válido')),
      );
      return;
    }
    
    try {
      final response = await SmartTollsApi().updateWalletBalance(
        _selectedVehicleWallet!.idWallet!, // Usamos el ID de la wallet
        _selectedAmount,
      );
      
      if (response.isSuccess()) {
        // Actualizar el saldo localmente
        _selectedVehicleWallet = response.data;
        await loadUserVehicles(); // Recargar los datos
        
        // Mostrar mensaje de éxito
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Recarga exitosa: Bs. $_selectedAmount')),
        );
        
        // Navegar de regreso
        if (Navigator.of(context).canPop()) {
          Navigator.of(context).pop(); // Cerrar QR view
        }
        if (Navigator.of(context).canPop()) {
          Navigator.of(context).pop(); // Cerrar recharge view
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response.message ?? 'Error en la recarga')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }
      final Map<int, String> _tollNamesCache = {};

  Future<String?> getTollName(int tollId) async {
    // Si ya tenemos el nombre en cache, lo retornamos
    if (_tollNamesCache.containsKey(tollId)) {
      return _tollNamesCache[tollId];
    }
    
    try {
      // Hacer la llamada al API para obtener información del peaje
      final response = await SmartTollsApi().getTollById(tollId);
      
      if (response.isSuccess() && response.data != null) {
        final tollName = response.data!.tollsName;
        _tollNamesCache[tollId] = tollName ?? 'Peaje desconocido';
        return _tollNamesCache[tollId];
      }
    } catch (e) {
      debugPrint('Error al obtener nombre del peaje: $e');
    }
    
    return 'Peaje #$tollId';
  }





  void retryLoading() {
    _errorMessage = null;
    notifyListeners();
    loadUserVehicles();
  }

  void goToQr(BuildContext context) {
    context.pushNamed(QrView.routerName);
  }

  void goToRechargeWallet(BuildContext context) {
    context.pushNamed(RechargeWalletView.routerName);
  }
  
  void goToTransactionHistory(BuildContext context) {
    context.pushNamed(TransactionHistoryView.routerName);
  }

  void goToWallet(BuildContext context) {
    context.pushNamed(WalletView.routerName);
  }

  setItemSelectOpt(int itemSelectOpt) {
    _itemSelectOpt = itemSelectOpt;
    notifyListeners();
  }
}