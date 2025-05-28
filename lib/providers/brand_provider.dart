import 'package:flutter/material.dart';
import 'package:smarttolls/api/api.dart';
class BrandProvider extends ChangeNotifier {
  List<StBrandResponse> _allBrands = []; // Lista completa
  List<StBrandResponse> _brands = []; // Lista filtrada
  bool _isLoading = false;
  String? _errorMessage = '';
  String? _selectedBrand = '';
  String? _newModelName;
  List<StBrandResponse> get brands => _brands;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String? get selectedBrand => _selectedBrand;
  String? get newModelName => _newModelName;
  // Método para buscar marcas
  void searchBrands(String query) {
    if (query.isEmpty) {
      _brands = List.from(_allBrands);
    } else {
      _brands = _allBrands.where((brand) => 
        brand.brandName?.toLowerCase().contains(query.toLowerCase()) ?? false
      ).toList();
    }
    notifyListeners();
  }
  // cargar marcas desde la API
  Future<void> loadBrands() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      final response = await SmartTollsApi().getAllBrands();
      
      if (response.isSuccess() && response.dataList != null) {
        _allBrands = response.dataList!;
        _brands = List.from(_allBrands);
      } else {
        _errorMessage = response.message ?? 'Error al cargar las marcas';
      }
    } catch (e) {
      _errorMessage = 'Error de conexión: ${e.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  // Agregar nueva marca
  Future<void> addBrand(String brandName, String description, String country) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
  try {
    // Crear el objeto request con todos los datos
    final request = StBrandRequest(
      brandName: brandName,
      brandDescription: description,
      brandManufacturingCountry: country,
    );
    // Llamar a la API
    final response = await SmartTollsApi().createBrands(request);
    
    if (response.isSuccess()) {
      await loadBrands(); // Recargar la lista de marcas
    } else {
      _errorMessage = response.message ?? 'Error al agregar el color';
    }
  } catch (e) {
    _errorMessage = 'Error al agregar el Color ${e.toString()}';
  } finally {
    _isLoading = false;
    notifyListeners();
  }
  }

  // En BrandProvider class

// Método para actualizar una marca
Future<void> updateBrand(
  int brandId, 
  String brandName, 
  String brandDescription,
  String brandCountry
) async {
  _isLoading = true;
  _errorMessage = null;
  notifyListeners();

  try {
    final request = StBrandRequest(
      brandName: brandName,
      brandDescription: brandDescription,
      brandManufacturingCountry: brandCountry,
    );
    
    final response = await SmartTollsApi().updateBrand(brandId, request);
    
    if (response.isSuccess()) {
      await loadBrands(); // Recargar la lista de marcas
    } else {
      _errorMessage = response.message ?? 'Error al actualizar la marca';
    }
  } catch (e) {
    _errorMessage = 'Error al actualizar la marca: ${e.toString()}';
  } finally {
    _isLoading = false;
    notifyListeners();
  }
}

// Método para eliminar una marca
Future<void> deleteBrand(int brandId) async {
  _isLoading = true;
  _errorMessage = null;
  notifyListeners();

  try {
    final response = await SmartTollsApi().deleteBrand(brandId);
    
    if (response.isSuccess()) {
      await loadBrands(); // Recargar la lista de marcas
    } else {
      _errorMessage = response.message ?? 'Error al eliminar la marca';
    }
  } catch (e) {
    _errorMessage = 'Error al eliminar la marca: ${e.toString()}';
  } finally {
    _isLoading = false;
    notifyListeners();
  }
}
  // Método para recargar datos
  void retryLoading() {
    _errorMessage = null;
    
    loadBrands();
  }
}