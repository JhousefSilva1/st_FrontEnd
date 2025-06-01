import 'package:flutter/material.dart';
import 'package:smarttolls/api/api.dart';

class VehicleTypeProvider extends ChangeNotifier {
  List<StVehiclesTypeResponse> _allVehicleTypes = [];
  List<StVehiclesTypeResponse> _vehicleTypes = [];
  bool _isLoading = false;
  bool _isAdding = false;
  bool _isUpdating = false;
  bool _isDeleting = false;
  String? _errorMessage;

  // Getters
  List<StVehiclesTypeResponse> get vehicleTypes => _vehicleTypes;
  bool get isLoading => _isLoading;
  bool get isAdding => _isAdding;
  bool get isUpdating => _isUpdating;
  bool get isDeleting => _isDeleting;
  String? get errorMessage => _errorMessage;

  // Búsqueda
  void searchVehicleTypes(String query) {
    if (query.isEmpty) {
      _vehicleTypes = List.from(_allVehicleTypes);
    } else {
      _vehicleTypes = _allVehicleTypes.where((type) => 
        type.vehiclesTypesName?.toLowerCase().contains(query.toLowerCase()) ?? false
      ).toList();
    }
    notifyListeners();
  }

  // Carga de datos
  Future<void> loadVehicleTypes() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await SmartTollsApi().getAllTypeVehicles();
      if (response.isSuccess() && response.dataList != null) {
        _allVehicleTypes = response.dataList!;
        _vehicleTypes = List.from(_allVehicleTypes);
      } else {
        _errorMessage = response.message ?? 'Error al cargar tipos de vehículos';
      }
    } catch (e) {
      _errorMessage = 'Error de conexión: ${e.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Agregar nuevo tipo
  Future<void> addVehicleType(String name) async {
    _isAdding = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final request = StVehiclesTypeRequest(vehiclesTypes: name);
      final response = await SmartTollsApi().createVehicleType(request);
      
      if (response.isSuccess()) {
        await loadVehicleTypes();
      } else {
        _errorMessage = response.message ?? 'Error al agregar tipo de vehículo';
      }
    } catch (e) {
      _errorMessage = 'Error al agregar: ${e.toString()}';
    } finally {
      _isAdding = false;
      notifyListeners();
    }
  }

  // Actualizar tipo
  Future<void> updateVehicleType(int id, String name) async {
    _isUpdating = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final request = StVehiclesTypeRequest(vehiclesTypes: name);
      final response = await SmartTollsApi().updateVehicleType(id, request);
      
      if (response.isSuccess()) {
        await loadVehicleTypes();
      } else {
        _errorMessage = response.message ?? 'Error al actualizar tipo de vehículo';
      }
    } catch (e) {
      _errorMessage = 'Error al actualizar: ${e.toString()}';
    } finally {
      _isUpdating = false;
      notifyListeners();
    }
  }

  // Eliminar tipo
  Future<void> deleteVehicleType(int id) async {
    _isDeleting = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await SmartTollsApi().deleteVehicleType(id);
      
      if (response.isSuccess()) {
        await loadVehicleTypes();
      } else {
        _errorMessage = response.message ?? 'Error al eliminar tipo de vehículo';
      }
    } catch (e) {
      _errorMessage = 'Error al eliminar: ${e.toString()}';
    } finally {
      _isDeleting = false;
      notifyListeners();
    }
  }

  void retryLoading() {
    _errorMessage = null;
    loadVehicleTypes();
  }
}