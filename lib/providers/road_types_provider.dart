import 'package:flutter/material.dart';
import 'package:smarttolls/api/api.dart';

class RoadTypesProvider extends ChangeNotifier {
  List<StRoadTypeResponse> _allRoadTypes = [];
  List<StRoadTypeResponse> _roadTypes = [];
  
  bool _isLoading = false;
  bool _isAdding = false;
  bool _isUpdating = false;
  bool _isDeleting = false;
  String? _errorMessage;

  // Getters
  List<StRoadTypeResponse> get roadTypes => _roadTypes;
  bool get isLoading => _isLoading;
  bool get isAdding => _isAdding;
  bool get isUpdating => _isUpdating;
  bool get isDeleting => _isDeleting;
  String? get errorMessage => _errorMessage;

  // Búsqueda de tipos de camino
  void searchRoadTypes(String query) {
    if (query.isEmpty) {
      _roadTypes = List.from(_allRoadTypes);
    } else {
      _roadTypes = _allRoadTypes.where((type) => 
        type.roadType?.toLowerCase().contains(query.toLowerCase()) ?? false
      ).toList();
    }
    notifyListeners();
  }

  // Cargar tipos de camino desde la API
  Future<void> loadRoadTypes() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await SmartTollsApi().getAllRoadTypes();
      if (response.isSuccess() && response.dataList != null) {
        _allRoadTypes = response.dataList!;
        _roadTypes = List.from(_allRoadTypes);
      } else {
        _errorMessage = response.message ?? 'Error al cargar los tipos de camino';
      }
    } catch (e) {
      _errorMessage = 'Error de conexión: ${e.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Agregar nuevo tipo de camino
  Future<void> addRoadType(String roadTypeName) async {
    _isAdding = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final request = StRoadTypeRequest(roadType: roadTypeName);
      final response = await SmartTollsApi().createRoadType(request);
      
      if (response.isSuccess()) {
        await loadRoadTypes();
      } else {
        _errorMessage = response.message ?? 'Error al agregar tipo de camino';
      }
    } catch (e) {
      _errorMessage = 'Error al agregar: ${e.toString()}';
    } finally {
      _isAdding = false;
      notifyListeners();
    }
  }

  // Actualizar tipo de camino
  Future<void> updateRoadType(int idRoadType, String roadTypeName) async {
    _isUpdating = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final request = StRoadTypeRequest(roadType: roadTypeName);
      final response = await SmartTollsApi().updateRoadType(idRoadType, request);
      
      if (response.isSuccess()) {
        await loadRoadTypes();
      } else {
        _errorMessage = response.message ?? 'Error al actualizar tipo de camino';
      }
    } catch (e) {
      _errorMessage = 'Error al actualizar: ${e.toString()}';
    } finally {
      _isUpdating = false;
      notifyListeners();
    }
  }

  // Eliminar tipo de camino
  Future<void> deleteRoadType(int idRoadType) async {
    _isDeleting = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await SmartTollsApi().deleteRoadType(idRoadType);
      
      if (response.isSuccess()) {
        await loadRoadTypes();
      } else {
        _errorMessage = response.message ?? 'Error al eliminar tipo de camino';
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
    loadRoadTypes();
  }
}