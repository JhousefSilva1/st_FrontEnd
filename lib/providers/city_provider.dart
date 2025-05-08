// city_provider.dart
import 'package:flutter/material.dart';
import 'package:smarttolls/api/api.dart';

class CityProvider extends ChangeNotifier {
  List<StCityResponse> _allCities = [];
  List<StCityResponse> _cities = [];
  bool _isLoading = false;
  String? _errorMessage = '';
  String? _selectedCity = '';
  String? _newCityName;
  int? _currentCountryId;

  List<StCityResponse> get cities => _cities;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String? get selectedCity => _selectedCity;
  String? get newCityName => _newCityName;
  int? get currentCountryId => _currentCountryId;
  

  void searchCities(String query) {
    if (query.isEmpty) {
      _cities = List.from(_allCities);
    } else {
      _cities = _allCities.where((city) =>
          city.cityName?.toLowerCase().contains(query.toLowerCase()) ?? false).toList();
    }
    notifyListeners();
  }

  Future<void> loadCitiesByCountry(int countryId) async {
    _currentCountryId = countryId;
    _isLoading = true;
    _errorMessage = null;
    notifyListeners(); // Notificar ANTES de la carga para mostrar loader
    
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
        notifyListeners(); // Notificar DESPUÉS de la carga
      }
  }

  Future<void> addCity(String cityName, int countryId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    
    try {
      final request = StCityRequest(
        cityName: cityName,
        idCountry: countryId,
      );
      
      final response = await SmartTollsApi().createCity(request);

      if (response.isSuccess()) {
        await loadCitiesByCountry(countryId); // Recargar la lista de ciudades
      } else {
        _errorMessage = response.message ?? 'Error al agregar la ciudad';
      }
    } catch (e) {
      _errorMessage = 'Error de conexión: ${e.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void retryLoading() {
    if (_currentCountryId != null) {
      _errorMessage = null;
      loadCitiesByCountry(_currentCountryId!);
    }
  }

  void clearState() {
    _allCities = [];
    _cities = [];
    _selectedCity = '';
    _newCityName = null;
    _errorMessage = null;
    // NO limpiar _currentCountryId aquí
    notifyListeners();
  }


}