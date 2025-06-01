import 'package:flutter/material.dart';
import 'package:smarttolls/api/api.dart';

class FuelTypeProvider extends ChangeNotifier {
  List<StFuelTypesResponse> _allFuelTypes = [];
  List<StFuelTypesResponse> _fuelTypes = [];
  bool _isLoading = false;
  bool _isAdding = false;
  bool _isUpdating = false;
  bool _isDeleting = false;
  String? _errorMessage;

  // Getters
  List<StFuelTypesResponse> get fuelTypes => _fuelTypes;
  bool get isLoading => _isLoading;
  bool get isAdding => _isAdding;
  bool get isUpdating => _isUpdating;
  bool get isDeleting => _isDeleting;
  String? get errorMessage => _errorMessage;

  // Búsqueda
  void searchFuelTypes(String query) {
    if (query.isEmpty) {
      _fuelTypes = List.from(_allFuelTypes);
    } else {
      _fuelTypes = _allFuelTypes.where((type) => 
        type.fuelTypeName?.toLowerCase().contains(query.toLowerCase()) ?? false
      ).toList();
    }
    notifyListeners();
  }

  // Carga de datos
  Future<void> loadFuelTypes() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await SmartTollsApi().getAllFuelTypes();
      if (response.isSuccess() && response.dataList != null) {
        _allFuelTypes = response.dataList!;
        _fuelTypes = List.from(_allFuelTypes);
      } else {
        _errorMessage = response.message ?? 'Error al cargar tipos de combustible';
      }
    } catch (e) {
      _errorMessage = 'Error de conexión: ${e.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Agregar nuevo tipo
  Future<void> addFuelType(String name) async {
    _isAdding = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final request = StFuelTypesRequest(fuelTypeFuel: name);
      final response = await SmartTollsApi().createFuelType(request);
      
      if (response.isSuccess()) {
        await loadFuelTypes();
      } else {
        _errorMessage = response.message ?? 'Error al agregar tipo de combustible';
      }
    } catch (e) {
      _errorMessage = 'Error al agregar: ${e.toString()}';
    } finally {
      _isAdding = false;
      notifyListeners();
    }
  }

  // Actualizar tipo
  Future<void> updateFuelType(int id, String name) async {
    _isUpdating = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final request = StFuelTypesRequest(fuelTypeFuel: name);
      final response = await SmartTollsApi().updateFuelType(id, request);
      
      if (response.isSuccess()) {
        await loadFuelTypes();
      } else {
        _errorMessage = response.message ?? 'Error al actualizar tipo de combustible';
      }
    } catch (e) {
      _errorMessage = 'Error al actualizar: ${e.toString()}';
    } finally {
      _isUpdating = false;
      notifyListeners();
    }
  }

  // Eliminar tipo
  Future<void> deleteFuelType(int id) async {
    _isDeleting = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await SmartTollsApi().deleteFuelType(id);
      
      if (response.isSuccess()) {
        await loadFuelTypes();
      } else {
        _errorMessage = response.message ?? 'Error al eliminar tipo de combustible';
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
    loadFuelTypes();
  }
}