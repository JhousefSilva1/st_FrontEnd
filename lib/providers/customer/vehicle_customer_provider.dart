import 'package:flutter/material.dart';
import 'package:smarttolls/api/api.dart';
import 'package:smarttolls/config/preferences.dart';

class VehicleCustomerProvider extends ChangeNotifier {
  // get all vehicles by personId

  List<StVehicleResponse> _allVehicles = [];
  List<StVehicleResponse> _vehicles = [];
  bool _isLoading = false;
  String? _errorMessage = '';
  String? _newVehicleLicensePlate;
  String? _newVehicleChassisNumber;
  String? _newVehicleEngineNumber;
  String? _newVehicleManufacturingYear;
  double? _newVehicleWeight;
  int? _selectedFuelTypes;
  int? _selectedVehiclesColors;
  int? _selectedVehiclesModels;
  int? _selectedVehiclesType;
  int? _selectedCityId;
  int? _selectedCountryId;
  // current user
    StPersonResponse? _currentUser;

  StPersonResponse? get currentUser => _currentUser;
  List<StVehicleResponse> get vehicles => _vehicles;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String? get newVehicleLicensePlate => _newVehicleLicensePlate;
  String? get newVehicleChassisNumber => _newVehicleChassisNumber;
  String? get newVehicleEngineNumber => _newVehicleEngineNumber;
  String? get newVehicleManufacturingYear => _newVehicleManufacturingYear;
  double? get newVehicleWeight => _newVehicleWeight;
  int? get selectedFuelTypes => _selectedFuelTypes;
  int? get selectedVehiclesColors => _selectedVehiclesColors;
  int? get selectedVehiclesModels => _selectedVehiclesModels;
  int? get selectedVehiclesType => _selectedVehiclesType;
  int? get selectedCityId => _selectedCityId;
  int? get selectedCountryId => _selectedCountryId;

  void searchVehicles(String query) {
    if (query.isEmpty) {
      _vehicles = List.from(_allVehicles);
    } else {
      _vehicles = _allVehicles.where((vehicle) =>
          vehicle.licensePlate?.toLowerCase().contains(query.toLowerCase()) ?? false).toList();
    }
    notifyListeners();
  }

  Future<void> loadCurrentData()async{
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try{
      final personId = await Preferences().personId();
      if(personId == 0){
        _errorMessage = 'No se pudo identificar al usuario';
        return;
      }
      final response = await SmartTollsApi().getVehiclesByPersonId(personId);
              if (response.isSuccess()) {
        if (response.data != null) {
          _currentUser = response.data as StPersonResponse?;
        } else {
          _errorMessage = 'Datos de usuario no disponibles';
        }
      } else {
        _errorMessage = response.message ?? 'Error al cargar los datos del usuario';
      }
    }catch (e) {
      _errorMessage = 'Error: ${e.toString()}';
      debugPrint('Error en loadCurrentUserData: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void retryLoading() {
    _errorMessage = null;
    notifyListeners();
    loadCurrentData();
  }


}