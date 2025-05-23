import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:smarttolls/api/api.dart';
import 'package:smarttolls/api/response/admin/st_vehicles_response.dart';
import 'package:smarttolls/api/response/customer/st_wallet_response.dart';
import 'package:smarttolls/config/preferences.dart';
import 'package:smarttolls/views/views.dart';

class WalletProvider extends ChangeNotifier {
  int _itemSelectOpt = 6;
  int get itemSelectOpt => _itemSelectOpt;
  
  List<StVehicleResponse> _vehicles = [];
  StVehicleResponse? _selectedVehicle;
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