import 'package:flutter/material.dart';
import 'package:smarttolls/api/api.dart';

class PlaceProvider extends ChangeNotifier {
  List<StPlaceResponse> _allPlaces = [];
  List<StPlaceResponse> _places = [];
  
  bool _isLoading = false;
  bool _isAdding = false;
  bool _isUpdating = false;
  bool _isDeleting = false;
  String? _errorMessage;
  int? _currentCityId;

  // Getters
  List<StPlaceResponse> get places => _places;
  bool get isLoading => _isLoading;
  bool get isAdding => _isAdding;
  bool get isUpdating => _isUpdating;
  bool get isDeleting => _isDeleting;
  String? get errorMessage => _errorMessage;
  int? get currentCityId => _currentCityId;

  // Búsqueda de lugares
  void searchPlaces(String query) {
    if (query.isEmpty) {
      _places = List.from(_allPlaces);
    } else {
      _places = _allPlaces.where((place) => 
        place.placeName?.toLowerCase().contains(query.toLowerCase()) ?? false
      ).toList();
    }
    notifyListeners();
  }

  // Cargar lugares por ciudad desde la API
  Future<void> loadPlacesByCity(int cityId) async {
    _currentCityId = cityId;
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await SmartTollsApi().getPlacesByCity(cityId);
      if (response.isSuccess() && response.dataList != null) {
        _allPlaces = response.dataList!;
        _places = List.from(_allPlaces);
      } else {
        _errorMessage = response.message ?? 'Error al cargar los lugares';
        _allPlaces = [];
        _places = [];
      }
    } catch (e) {
      _errorMessage = 'Error de conexión: ${e.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Agregar nuevo lugar
  Future<void> addPlace(String placeName, int cityId) async {
    _isAdding = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final request = StPlacesRequest(
        placeName: placeName,
        idCity: cityId,
      );
      
      final response = await SmartTollsApi().createPlace(request);
      
      if (response.isSuccess()) {
        await loadPlacesByCity(cityId);
      } else {
        _errorMessage = response.message ?? 'Error al agregar lugar';
      }
    } catch (e) {
      _errorMessage = 'Error al agregar: ${e.toString()}';
    } finally {
      _isAdding = false;
      notifyListeners();
    }
  }

  // Actualizar lugar
  Future<void> updatePlace(int id, String placeName, int cityId) async {
    _isUpdating = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final request = StPlacesRequest(
        placeName: placeName,
        idCity: cityId,
      );
      
      final response = await SmartTollsApi().updatePlace(id, request);
      
      if (response.isSuccess()) {
        await loadPlacesByCity(cityId);
      } else {
        _errorMessage = response.message ?? 'Error al actualizar lugar';
      }
    } catch (e) {
      _errorMessage = 'Error al actualizar: ${e.toString()}';
    } finally {
      _isUpdating = false;
      notifyListeners();
    }
  }

  // Eliminar lugar
  Future<void> deletePlace(int id) async {
    _isDeleting = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await SmartTollsApi().deletePlace(id);
      
      if (response.isSuccess() && _currentCityId != null) {
        await loadPlacesByCity(_currentCityId!);
      } else {
        _errorMessage = response.message ?? 'Error al eliminar lugar';
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
    if (_currentCityId != null) {
      _errorMessage = null;
      loadPlacesByCity(_currentCityId!);
    }
  }

  // Limpiar datos
  void clearPlaces() {
    _allPlaces = [];
    _places = [];
    notifyListeners();
  }
}