import 'package:flutter/material.dart';
import 'package:smarttolls/api/api.dart';

class CountryProvider extends ChangeNotifier {
  List<StCountryResponse> _allCountries = [];
  List<StCountryResponse> _countries = [];
  
  bool _isLoading = false;
  bool _isAdding = false;
  bool _isUpdating = false;
  bool _isDeleting = false;
  String? _errorMessage;

  // Getters
  List<StCountryResponse> get countries => _countries;
  bool get isLoading => _isLoading;
  bool get isAdding => _isAdding;
  bool get isUpdating => _isUpdating;
  bool get isDeleting => _isDeleting;
  String? get errorMessage => _errorMessage;

  // Búsqueda de países
  void searchCountries(String query) {
    if (query.isEmpty) {
      _countries = List.from(_allCountries);
    } else {
      _countries = _allCountries.where((country) => 
        country.countryName?.toLowerCase().contains(query.toLowerCase()) ?? false
      ).toList();
    }
    notifyListeners();
  }

  // Cargar países desde la API
  Future<void> loadCountries() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await SmartTollsApi().getAllCountries();
      if (response.isSuccess() && response.dataList != null) {
        _allCountries = response.dataList!;
        _countries = List.from(_allCountries);
      } else {
        _errorMessage = response.message ?? 'Error al cargar los países';
      }
    } catch (e) {
      _errorMessage = 'Error de conexión: ${e.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Agregar nuevo país
  Future<void> addCountry(String countryName) async {
    _isAdding = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final request = StCountryRequest(countryName: countryName);
      final response = await SmartTollsApi().createCountry(request);
      
      if (response.isSuccess()) {
        await loadCountries();
      } else {
        _errorMessage = response.message ?? 'Error al agregar país';
      }
    } catch (e) {
      _errorMessage = 'Error al agregar: ${e.toString()}';
    } finally {
      _isAdding = false;
      notifyListeners();
    }
  }

  // Actualizar país
  Future<void> updateCountry(int id, String countryName) async {
    _isUpdating = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final request = StCountryRequest(countryName: countryName);
      final response = await SmartTollsApi().updateCountry(id, request);
      
      if (response.isSuccess()) {
        await loadCountries();
      } else {
        _errorMessage = response.message ?? 'Error al actualizar país';
      }
    } catch (e) {
      _errorMessage = 'Error al actualizar: ${e.toString()}';
    } finally {
      _isUpdating = false;
      notifyListeners();
    }
  }

  // Eliminar país
  Future<void> deleteCountry(int id) async {
    _isDeleting = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await SmartTollsApi().deleteCountry(id);
      
      if (response.isSuccess()) {
        await loadCountries();
      } else {
        _errorMessage = response.message ?? 'Error al eliminar país';
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
    loadCountries();
  }

  // Limpiar datos
  void clearCountries() {
    _allCountries = [];
    _countries = [];
    notifyListeners();
  }
}