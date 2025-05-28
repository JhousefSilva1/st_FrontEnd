import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:smarttolls/api/api.dart';


class VehiclesColorsProvider extends ChangeNotifier{
  List<StVehiclesColorsResponse> _allColors=[];
  List<StVehiclesColorsResponse> _colors=[];

  bool _isLoading = false;

  String? _errorMessage = '';
  String? _selectedColor = '';
  String? _newColorName;

  List<StVehiclesColorsResponse> get colors => _colors;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String? get selectedColor => _selectedColor;
  String? get newColorName => _newColorName;

  // Método para buscar colores de vehículos
  void searchColors(String query){
    if (query.isEmpty){
      _colors = List.from(_allColors);
    }else{
      _colors = _allColors.where((color) => 
        color.colorName?.toLowerCase().contains(query.toLowerCase()) ?? false
      ).toList();
    }
    notifyListeners();
  }

  // cargar colores de vehículos desde la API
  Future<void> loadVehiclesColors() async{
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try{
      final response = await SmartTollsApi().getAllColors();
      if(response.isSuccess() && response.dataList != null){
        _allColors = response.dataList!;
        _colors = List.from(_allColors);
      }else{
        _errorMessage = response.message ?? 'Error al cargar los colores de vehículos';
      }
    }catch(e){
      _errorMessage = 'Error de conexión: ${e.toString()}';
    }finally{
      _isLoading = false;
      notifyListeners();
    }
  }

  // agregar nuevo color de vehículo
  Future<void> addColor(String colorName, String colorDescription) async{
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try{
      // crear el objeto de color con los datos ingresados
      final request = StColorRequest(
        colorName: colorName,
        colorDescription: colorDescription,
      );
      // llmaar a la API
      final response = await SmartTollsApi().createColor(request);
            if (response.isSuccess()) {
      await loadVehiclesColors(); // Recargar la lista de marcas
    } else {
      _errorMessage = response.message ?? 'Error al agregar marca';
    }
    }catch (e) {
    _errorMessage = 'Error al agregar marca: ${e.toString()}';
  } finally {
    _isLoading = false;
    notifyListeners();
  }

  }
  // Editar Colors

      Future<void> updateColor(int colorId, String colorName, String colorDescription) async {
        _isLoading = true;
        _errorMessage = null;
        notifyListeners();

        try {
          final request = StColorRequest(
            colorName: colorName,
            colorDescription: colorDescription,
          );
          
          final response = await SmartTollsApi().updateColor(colorId, request);
          
          if (response.isSuccess()) {
            await loadVehiclesColors(); // Recargar la lista de colores
          } else {
            _errorMessage = response.message ?? 'Error al actualizar el color';
          }
        } catch (e) {
          _errorMessage = 'Error al actualizar el color: ${e.toString()}';
        } finally {
          _isLoading = false;
          notifyListeners();
        }
      }
      // En VehiclesColorsProvider class
    Future<void> deleteColor(int colorId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await SmartTollsApi().deleteColor(colorId);
    
        if (response.isSuccess()) {
          await loadVehiclesColors(); // Recargar la lista de colores
        } else {
        _errorMessage = response.message ?? 'Error al eliminar el color';
      }
    } catch (e) {
      _errorMessage = 'Error al eliminar el color: ${e.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    } 
  }

    // metodo para recargar colores de vehiculos
    void retryLoading(){
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    loadVehiclesColors();
  }

}