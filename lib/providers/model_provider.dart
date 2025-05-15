import 'package:flutter/material.dart';
import 'package:smarttolls/api/api.dart';
class ModelProvider  extends ChangeNotifier{
  List<StVehiclesModelsResponse> _allModels = [];
  List<StVehiclesModelsResponse> _models = []; // Lista filtrada
  bool _isLoading = false;
  String? _errorMessage = '';
  String? _selectedModel = '';
  String? _newModelName;
  int? _currentBrandId; // Añade esta variable para trackear la marca actual


  List<StVehiclesModelsResponse> get models => _models;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String? get selectedModel => _selectedModel;
  String? get newModelName => _newModelName;
  int? get currentBrandId => _currentBrandId; // Getter para la marca actual

  // Método para buscar modelos
  void searchModels(String query) {
    if (query.isEmpty) {
      _models = List.from(_allModels);
    } else {
      _models = _allModels.where((model) => 
        model.modelName?.toLowerCase().contains(query.toLowerCase()) ?? false
      ).toList();
    }
    notifyListeners();
  }

Future<void> loadModelsByBrand(int brandId) async {
   
    _currentBrandId = brandId; // Actualiza la marca actual
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      // final request = StBrandResponse.createEmpty().idBrand = brandId;
      final response = await SmartTollsApi().getModelsByBrand(brandId);

      if(response.isSuccess() && response.dataList != null) {
        _allModels = response.dataList!;
        _models = List.from(_allModels);
      } else {
        _errorMessage = response.message ?? 'Error al cargar los modelos por marca';
      }
    } catch (e) {
      _errorMessage = 'Error de conexión: ${e.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }


  }
  //   void clearModels() {
  //   _currentBrandId = null;
  //   _allModels = [];
  //   _models = [];
  //   notifyListeners();
  // }
// add models

  Future<void>addModels(String modelName, int brnadId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try{
        // logica para agregar un nuevo modelo
        final request = StVehiclesModelsRequest(
          modelName: modelName,
          idBrand: brnadId,
        );
        final response = await SmartTollsApi().createModelByBrand(request);
        if(response.isSuccess()){
          await loadModelsByBrand(brnadId); // Recargar la lista de modelos
        }else{
          _errorMessage = response.message ?? 'Error al agregar el modelo';
        }
    }catch (e){
      _errorMessage = 'Error de conexión: ${e.toString()}';
    }finally{
      _isLoading = false;
      notifyListeners();
    }
  }
// dialogo para agregar modelos


  void retryLoading(){
    if(_currentBrandId != null){
      _errorMessage = null;
      loadModelsByBrand(_currentBrandId!);
    }
  }
}