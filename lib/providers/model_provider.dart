import 'package:flutter/material.dart';
import 'package:smarttolls/api/api.dart';
class ModelProvider  extends ChangeNotifier{
  List<StVehiclesModelsResponse> _allModels = [];
  List<StVehiclesModelsResponse> _models = []; // Lista filtrada
  bool _isLoading = false;
    bool _isAdding = false;
  bool _isUpdating = false;
  bool _isDeleting = false;
  String? _errorMessage = '';
  String? _selectedModel = '';
  String? _newModelName;
  int? _currentBrandId; // Añade esta variable para trackear la marca actual
  String? _currentBrandName; // Añade esta variable para el nombre de la marca actual


String? get currentBrandName => _currentBrandName;
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
  _currentBrandId = brandId;
  _isLoading = true;
  _errorMessage = null;
  notifyListeners();
  
  try {
    final modelsResponse = await SmartTollsApi().getModelsByBrand(brandId);
    final brandResponse = await SmartTollsApi().getBrandById(brandId);
    
    if(modelsResponse.isSuccess() && modelsResponse.dataList != null) {
      _allModels = modelsResponse.dataList!;
      _models = List.from(_allModels);
      _currentBrandName = brandResponse.isSuccess() 
          ? brandResponse.data?.brandName 
          : 'Marca desconocida';
    } else {
      _errorMessage = modelsResponse.message ?? 'Error al cargar los modelos';
    }
  } catch (e) {
    _errorMessage = 'Error de conexión: ${e.toString()}';
  } finally {
    _isLoading = false;
    notifyListeners();
  }
}
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

  
  Future<StBrandResponse?> _getBrandInfo(int brandId) async {
    try {
      final response = await SmartTollsApi().getBrandById(brandId);
      if (response.isSuccess()) {
        return response.data;
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}