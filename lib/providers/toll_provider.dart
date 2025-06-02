import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:smarttolls/api/api.dart';

class TollProvider extends ChangeNotifier {
  List<StTollsResponse> _allTolls = [];
  List<StTollsResponse> _tolls = [];
  
  bool _isLoading = false;
  bool _isAdding = false;
  bool _isUpdating = false;
  bool _isDeleting = false;
  String? _errorMessage;
  int? _selectedPlaceId;
  int? _selectedCityId;
  int? _selectedCountryId;

  // Getters
  List<StTollsResponse> get tolls => _tolls;
  bool get isLoading => _isLoading;
  bool get isAdding => _isAdding;
  bool get isUpdating => _isUpdating;
  bool get isDeleting => _isDeleting;
  String? get errorMessage => _errorMessage;
  int? get selectedPlaceId => _selectedPlaceId;
  int? get selectedCityId => _selectedCityId;
  int? get selectedCountryId => _selectedCountryId;

  // Búsqueda de peajes
  void searchTolls(String query) {
    if (query.isEmpty) {
      _tolls = List.from(_allTolls);
    } else {
      _tolls = _allTolls.where((toll) => 
        toll.tollsName?.toLowerCase().contains(query.toLowerCase()) ?? false
      ).toList();
    }
    notifyListeners();
  }

  // Cargar todos los peajes desde la API
  Future<void> loadAllTolls() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await SmartTollsApi().getAllTolls();
      if (response.isSuccess() && response.dataList != null) {
        _allTolls = response.dataList!;
        _tolls = List.from(_allTolls);
      } else {
        _errorMessage = response.message ?? 'Error al cargar los peajes';
        _allTolls = [];
        _tolls = [];
      }
    } catch (e) {
      _errorMessage = 'Error de conexión: ${e.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Agregar nuevo peaje
  Future<void> addToll(String tollName, int placeId) async {
    _isAdding = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final request = StTollsRequest(
        tollsName: tollName,
        idPlaces: placeId,
      );
      
      final response = await SmartTollsApi().createToll(request);
      
      if (response.isSuccess()) {
        await loadAllTolls();
      } else {
        _errorMessage = response.message ?? 'Error al agregar peaje';
      }
    } catch (e) {
      _errorMessage = 'Error al agregar: ${e.toString()}';
    } finally {
      _isAdding = false;
      notifyListeners();
    }
  }

  // Actualizar peaje
  Future<void> updateToll(int id, String tollName, int placeId) async {
    _isUpdating = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final request = StTollsRequest(
        tollsName: tollName,
        idPlaces: placeId,
      );
      
      final response = await SmartTollsApi().updateToll(id, request);
      
      if (response.isSuccess()) {
        await loadAllTolls();
      } else {
        _errorMessage = response.message ?? 'Error al actualizar peaje';
      }
    } catch (e) {
      _errorMessage = 'Error al actualizar: ${e.toString()}';
    } finally {
      _isUpdating = false;
      notifyListeners();
    }
  }

  // Eliminar peaje
  Future<void> deleteToll(int id) async {
    _isDeleting = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await SmartTollsApi().deleteToll(id);
      
      if (response.isSuccess()) {
        await loadAllTolls();
      } else {
        _errorMessage = response.message ?? 'Error al eliminar peaje';
      }
    } catch (e) {
      _errorMessage = 'Error al eliminar: ${e.toString()}';
    } finally {
      _isDeleting = false;
      notifyListeners();
    }
  }

  // Actualizar IDs seleccionados
  void updateSelectedIds(int? countryId, int? cityId, int? placeId) {
    _selectedCountryId = countryId;
    _selectedCityId = cityId;
    _selectedPlaceId = placeId;
    notifyListeners();
  }

  // Reintentar carga
  void retryLoading() {
    _errorMessage = null;
    loadAllTolls();
  }

  // Limpiar datos
  void clearTolls() {
    _allTolls = [];
    _tolls = [];
    notifyListeners();
  }
}