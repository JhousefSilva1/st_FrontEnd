import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:smarttolls/api/api.dart';
import 'package:smarttolls/models/models.dart';
import 'package:smarttolls/views/views.dart';

class VehiclesProvider extends ChangeNotifier {
  int _currentForm = 0;
  int _editCurrentForm = 0;
  int get currentForm => _currentForm;
  int get editCurrentForm => _editCurrentForm;

  StBrandResponse _brand = StBrandResponse.createEmpty();
  StBrandResponse get brand => _brand;
  StFuelTypesResponse _fuelType = StFuelTypesResponse.createEmpty();
  StFuelTypesResponse get fuelType => _fuelType;
  StVehiclesModelsResponse _model = StVehiclesModelsResponse.createEmpty();
  StVehiclesModelsResponse get model => _model;
  StVehiclesTypeResponse _vehicleType = StVehiclesTypeResponse.createEmpty();
  StVehiclesTypeResponse get vehicleType => _vehicleType;

  List<StFuelTypesResponse> _fuelTypes = [];
  List<StVehiclesColorsResponse> _vehiclesColors = [];
  List<StVehiclesModelsResponse> _vehiclesModels = [];
  List<StBrandResponse> _brands = [];
  List<StVehiclesTypeResponse> _vehiclesType = [];

  List<StFuelTypesResponse> get fuelTypes => _fuelTypes;
  List<StVehiclesColorsResponse> get vehiclesColors => _vehiclesColors;
  List<StVehiclesModelsResponse> get vehiclesModels => _vehiclesModels;
  List<StBrandResponse> get brands => _brands;
  List<StVehiclesTypeResponse> get vehiclesType => _vehiclesType;

  set setBrand(StBrandResponse value) {
    _brand = value;
  }

  set setFuelType(StFuelTypesResponse value) {
    _fuelType = value;
  }

  set setModel(StVehiclesModelsResponse value) {
    _model = value;
  }
  
  set setVehicleType(StVehiclesTypeResponse value) {
    _vehicleType = value;
  }

  void setCurrentForm(int form) {
    _currentForm = form;
    notifyListeners();
  }

  void setEditCurrentForm(int form) {
    _editCurrentForm = form;
    notifyListeners();
  }

  void goToAddVehicle(BuildContext context) {
    context.pushNamed(AddVehiclesView.routerName);
  }

  void goToAddVehicleAdmin(BuildContext context) async {
    context.pushNamed(AddVehiclesAdminView.routerName);
  }

  void goToEditVehicleAdmin(BuildContext context) {
    context.pushNamed(EditVehicleAdminView.routerName);
  }

  void goToVehicleAdmin(BuildContext context) {
    context.pushNamed(VehicleAdminView.routerName);
  }

  Future<StResponse<StBrandResponse>> getAllBrands() async {
    return await SmartTollsApi().getAllBrands();
  }

  Future<StResponse<StVehiclesColorsResponse>> getAllColors() async {
    return await SmartTollsApi().getAllColors();
  }

  Future<StResponse<StVehiclesModelsResponse>> getAllModels() async {
    return await SmartTollsApi().getAllModels();
  }

  Future<StResponse<StVehiclesModelsResponse>> getAllModelsByBrand(StBrandResponse request) async {
    return await SmartTollsApi().getAllModelsByBrand(request);
  }

  Future<StResponse<StFuelTypesResponse>> getAllFuelTypes() async {
    return await SmartTollsApi().getAllFuelTypes();
  }
  
  Future<StResponse<StVehiclesTypeResponse>> getAllTypeVehicles() async {
    return await SmartTollsApi().getAllTypeVehicles();
  }

  Future<StResponse> getAllVehicles() async {
    return await SmartTollsApi().getAllVehicles();
  }

  Future fetchAllBrands() async {
    StResponse<StBrandResponse> response = await getAllBrands();
    if (response.isSuccess()) {
      _brands = response.dataList ?? [];
      notifyListeners();
    }else {
      print('Error: ${response.message}');
    }
  }

  Future fetchAllColors() async {
    StResponse<StVehiclesColorsResponse> response = await getAllColors();
    if (response.isSuccess()) {
      _vehiclesColors = response.dataList ?? [];
      notifyListeners();
    }else {
      print('Error: ${response.message}');
    }
  }

  Future fetchAllModels() async {
    StResponse<StVehiclesModelsResponse> response = await getAllModels();
    if (response.isSuccess()) {
      _vehiclesModels = response.dataList ?? [];
      notifyListeners();
    }else {
      print('Error: ${response.message}');
    }
  }

  Future fetchAllFuelTypes() async {
    StResponse<StFuelTypesResponse> response = await getAllFuelTypes();
    if (response.isSuccess()) {
      _fuelTypes = response.dataList ?? [];
      notifyListeners();
    }else {
      print('Error: ${response.message}');
    }
  }

  Future fetchAllVehiclesType() async {
    StResponse<StVehiclesTypeResponse> response = await getAllTypeVehicles();
    if (response.isSuccess()) {
      _vehiclesType = response.dataList ?? [];
      notifyListeners();
    }else {
      print('Error: ${response.message}');
    }
  }

  Future fetchAllModelsByBrand(StBrandResponse request) async {
    StResponse<StVehiclesModelsResponse> response = await getAllModelsByBrand(request);
    if (response.isSuccess()) {
      _vehiclesModels = response.dataList ?? [];
      notifyListeners();
    }else {
      print('Error: ${response.message}');
    }
  }
}