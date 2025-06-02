import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:smarttolls/api/api.dart';

class VehiclesColorsProvider extends ChangeNotifier {
  List<StVehiclesColorsResponse> _allColors = [];
  List<StVehiclesColorsResponse> _colors = [];
  
  bool _isLoading = false;
  bool _isAdding = false;
  bool _isUpdating = false;
  bool _isDeleting = false;
  String? _errorMessage;

  // Getters
  List<StVehiclesColorsResponse> get colors => _colors;
  bool get isLoading => _isLoading;
  bool get isAdding => _isAdding;
  bool get isUpdating => _isUpdating;
  bool get isDeleting => _isDeleting;
  String? get errorMessage => _errorMessage;

  // Búsqueda de colores
  void searchColors(String query) {
    if (query.isEmpty) {
      _colors = List.from(_allColors);
    } else {
      _colors = _allColors.where((color) => 
        color.colorName?.toLowerCase().contains(query.toLowerCase()) ?? false
      ).toList();
    }
    notifyListeners();
  }

  // Cargar colores desde API
  Future<void> loadVehiclesColors() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await SmartTollsApi().getAllColors();
      if (response.isSuccess() && response.dataList != null) {
        _allColors = response.dataList!;
        _colors = List.from(_allColors);
      } else {
        _errorMessage = response.message ?? 'Error al cargar los colores';
      }
    } catch (e) {
      _errorMessage = 'Error de conexión: ${e.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Agregar nuevo color
  Future<void> addColor(String colorName, String colorDescription) async {
    _isAdding = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final request = StColorRequest(
        colorName: colorName,
        colorDescription: colorDescription,
      );
      
      final response = await SmartTollsApi().createColor(request);
      
      if (response.isSuccess()) {
        await loadVehiclesColors();
      } else {
        _errorMessage = response.message ?? 'Error al agregar color';
      }
    } catch (e) {
      _errorMessage = 'Error al agregar: ${e.toString()}';
    } finally {
      _isAdding = false;
      notifyListeners();
    }
  }

  // Actualizar color
  Future<void> updateColor(int colorId, String colorName, String colorDescription) async {
    _isUpdating = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final request = StColorRequest(
        colorName: colorName,
        colorDescription: colorDescription,
      );
      
      final response = await SmartTollsApi().updateColor(colorId, request);
      
      if (response.isSuccess()) {
        await loadVehiclesColors();
      } else {
        _errorMessage = response.message ?? 'Error al actualizar el color';
      }
    } catch (e) {
      _errorMessage = 'Error al actualizar: ${e.toString()}';
    } finally {
      _isUpdating = false;
      notifyListeners();
    }
  }

  // Eliminar color
  Future<void> deleteColor(int colorId) async {
    _isDeleting = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await SmartTollsApi().deleteColor(colorId);
      
      if (response.isSuccess()) {
        await loadVehiclesColors();
      } else {
        _errorMessage = response.message ?? 'Error al eliminar el color';
      }
    } catch (e) {
      _errorMessage = 'Error al eliminar: ${e.toString()}';
    } finally {
      _isDeleting = false;
      notifyListeners();
    }
  }

  // Reintentar carga
  void retryLoading() {
    _errorMessage = null;
    loadVehiclesColors();
  }
}