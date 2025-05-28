import 'package:flutter/material.dart';
import 'package:smarttolls/api/api.dart';



class FuelTypeProvider extends ChangeNotifier{
  List<StFuelTypesResponse> _allFuelType = []; // Lista completa
  List<StFuelTypesResponse> _fuelType = []; // Lista filtrada

  bool _isLoading = false;

  String? _errorMessage = '';
  String? _selectedFuelType = '';
  String? _newFuelTypeName;

  List<StFuelTypesResponse> get fuelType => _fuelType;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String? get selectedFuelType => _selectedFuelType;
  String? get newFuelTypeName => _newFuelTypeName;

  // Método para buscar tipos de combustible
  void searchFuelType(String query){
    if (query.isEmpty){
      _fuelType = List.from(_allFuelType);
    }else{
      _fuelType = _allFuelType.where((fuelType) => 
        fuelType.fuelTypeName?.toLowerCase().contains(query.toLowerCase()) ?? false
      ).toList();
    }
    notifyListeners();
  }

  // cargar tipos de combustible desde la API
  Future<void> loadFuelTypes() async{
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try{
      final response = await SmartTollsApi().getAllFuelTypes();
      if(response.isSuccess() && response.dataList != null){
        _allFuelType = response.dataList!;
        _fuelType = List.from(_allFuelType);
      }else{
        _errorMessage = response.message ?? 'Error al cargar los tipos de combustible';
      }
    }catch(e){
      _errorMessage = 'Error de conexión: ${e.toString()}';
    }finally{
      _isLoading = false;
      notifyListeners();
    }
  }

  // agregar nuevo tipo de combustible
  Future<void> addFuelType(String fuelTypeName) async{
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try{
      // final response = await SmartTollsApi().addFuelType(fuelTypeName);
      final request = StFuelTypesRequest(
        fuelTypeFuel: fuelTypeName,
      );

      // llamada a la API para agregar el tipo de combustible
      final response = await SmartTollsApi().createFuelType(request);
          if (response.isSuccess()) {
      await loadFuelTypes(); // Recargar la lista de marcas
    } else {
      _errorMessage = response.message ?? 'Error al agregar el tipo de combustible';
    }

    }catch(e){
      _errorMessage = 'Error de conexión: ${e.toString()}';
    }finally{
      _isLoading = false;
      notifyListeners();
    }
  }

  

// Método para actualizar un tipo de combustible
Future<void> updateFuelType(int fuelTypeId, String fuelTypeName) async {
  _isLoading = true;
  _errorMessage = null;
  notifyListeners();

  try {
    final request = StFuelTypesRequest(
      fuelTypeFuel: fuelTypeName,
    );
    
    final response = await SmartTollsApi().updateFuelType(fuelTypeId, request);
    
    if (response.isSuccess()) {
      await loadFuelTypes(); // Recargar la lista de tipos de combustible
    } else {
      _errorMessage = response.message ?? 'Error al actualizar el tipo de combustible';
    }
  } catch (e) {
    _errorMessage = 'Error al actualizar el tipo de combustible: ${e.toString()}';
  } finally {
    _isLoading = false;
    notifyListeners();
  }
}

// Método para eliminar un tipo de combustible
Future<void> deleteFuelType(int fuelTypeId) async {
  _isLoading = true;
  _errorMessage = null;
  notifyListeners();

  try {
    final response = await SmartTollsApi().deleteFuelType(fuelTypeId);
    
    if (response.isSuccess()) {
      await loadFuelTypes(); // Recargar la lista de tipos de combustible
    } else {
      _errorMessage = response.message ?? 'Error al eliminar el tipo de combustible';
    }
  } catch (e) {
    _errorMessage = 'Error al eliminar el tipo de combustible: ${e.toString()}';
  } finally {
    _isLoading = false;
    notifyListeners();
  }
}

  // metodo para recargar datos
    void retryLoading(){
    _errorMessage = null;
    loadFuelTypes();
  }
}