import 'package:flutter/material.dart';
import 'package:smarttolls/api/api.dart';

class CityProvider extends ChangeNotifier {
  List<StCityResponse> _allCities = [];
  List<StCityResponse> _cities = [];
  
  bool _isLoading = false;
  bool _isAdding = false;
  bool _isUpdating = false;
  bool _isDeleting = false;
  String? _errorMessage;
  int? _currentCountryId;

  // Getters
  List<StCityResponse> get cities => _cities;
  bool get isLoading => _isLoading;
  bool get isAdding => _isAdding;
  bool get isUpdating => _isUpdating;
  bool get isDeleting => _isDeleting;
  String? get errorMessage => _errorMessage;
  int? get currentCountryId => _currentCountryId;

  // Búsqueda de ciudades
  void searchCities(String query) {
    if (query.isEmpty) {
      _cities = List.from(_allCities);
    } else {
      _cities = _allCities.where((city) => 
        city.cityName?.toLowerCase().contains(query.toLowerCase()) ?? false
      ).toList();
    }
    notifyListeners();
  }

  // Cargar ciudades por país desde la API
  Future<void> loadCitiesByCountry(int countryId) async {
    _currentCountryId = countryId;
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await SmartTollsApi().getCitiesByCountry(countryId);
      if (response.isSuccess() && response.dataList != null) {
        _allCities = response.dataList!;
        _cities = List.from(_allCities);
      } else {
        _errorMessage = response.message ?? 'Error al cargar las ciudades';
        _allCities = [];
        _cities = [];
      }
    } catch (e) {
      _errorMessage = 'Error de conexión: ${e.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Agregar nueva ciudad
  Future<void> addCity(String cityName, int countryId) async {
    _isAdding = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final request = StCityRequest(
        cityName: cityName,
        idCountry: countryId,
      );
      
      final response = await SmartTollsApi().createCity(request);
      
      if (response.isSuccess()) {
        await loadCitiesByCountry(countryId);
      } else {
        _errorMessage = response.message ?? 'Error al agregar ciudad';
      }
    } catch (e) {
      _errorMessage = 'Error al agregar: ${e.toString()}';
    } finally {
      _isAdding = false;
      notifyListeners();
    }
  }

  // Actualizar ciudad
  Future<void> updateCity(int id, String cityName, int countryId) async {
    _isUpdating = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final request = StCityRequest(
        cityName: cityName,
        idCountry: countryId,
      );
      
      final response = await SmartTollsApi().updateCity(id, request);
      
      if (response.isSuccess()) {
        await loadCitiesByCountry(countryId);
      } else {
        _errorMessage = response.message ?? 'Error al actualizar ciudad';
      }
    } catch (e) {
      _errorMessage = 'Error al actualizar: ${e.toString()}';
    } finally {
      _isUpdating = false;
      notifyListeners();
    }
  }

  // Eliminar ciudad
  Future<void> deleteCity(int id) async {
    _isDeleting = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await SmartTollsApi().deleteCity(id);
      
      if (response.isSuccess() && _currentCountryId != null) {
        await loadCitiesByCountry(_currentCountryId!);
      } else {
        _errorMessage = response.message ?? 'Error al eliminar ciudad';
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
    if (_currentCountryId != null) {
      _errorMessage = null;
      loadCitiesByCountry(_currentCountryId!);
    }
  }

  // Limpiar datos
  void clearCities() {
    _allCities = [];
    _cities = [];
    notifyListeners();
  }
}