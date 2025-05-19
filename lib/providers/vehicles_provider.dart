import 'package:flutter/material.dart';
import 'package:smarttolls/api/api.dart';

class VehiclesProvider extends ChangeNotifier {
  List<StVehicleResponse> _allVehicles=[];
  List<StVehicleResponse> _vehicles=[];
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

  Future<void>loadAllVehicles() async{
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try{
      final response = await SmartTollsApi().getAllVehicles();
      debugPrint('API Response: ${response.status} - ${response.message}');

      if(response.isSuccess()){
        if(response.data != null){
          _allVehicles = [response.data!];
        }else if(response.dataList != null && response.dataList!.isNotEmpty){
          _allVehicles = response.dataList!;
        }else{
          _errorMessage = 'No se encontraron vehículos';
        }
        _vehicles = List.from(_allVehicles);
      }else{
        _errorMessage = response.message ?? 'Error al cargar los vehículos';
      }

    }catch (e, stackTrace) {
    debugPrint('Error en loadAllPersons: $e');
    debugPrint('Stack trace: $stackTrace');
    _errorMessage = 'Error: ${e.toString()}';
  } finally {
    _isLoading = false;
    notifyListeners();
  }
}
void updateSelectedIds(int? fuelTypes, int? vehiclesColors, int? vehiclesModels, int? vehiclesType, int? cityId, int? countryId) {
    _selectedFuelTypes = fuelTypes;
    _selectedVehiclesColors = vehiclesColors;
    _selectedVehiclesModels = vehiclesModels;
    _selectedVehiclesType = vehiclesType;
    _selectedCityId = cityId;
    _selectedCountryId = countryId;
    notifyListeners();
  }

    void retryLoading(){
    _errorMessage = null;
    notifyListeners();
    loadAllVehicles();
  }
}