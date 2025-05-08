import 'package:flutter/foundation.dart';
import 'package:smarttolls/api/api.dart';

class ModelProvider extends ChangeNotifier{
  List<StVehiclesModelsResponse> _allModels = [];
  List<StVehiclesModelsResponse> _models = [];
  bool _isLoading = false;
  String? _errorMessage = '';
  String? _selectedModel = '';
  String? _newModelName;
  int? _currentBrandId;


  List<StVehiclesModelsResponse> get models => _models;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String? get selectedModel => _selectedModel;
  String? get newModelName => _newModelName;
  int? get currentBrandId => _currentBrandId;

  void searModels(String query){
    if(query.isEmpty){
      _models = List.from(_allModels);
    }else{
      _models = _allModels.where((model) =>
          model.modelName?.toLowerCase().contains(query.toLowerCase()) ?? false).toList();
    }
    notifyListeners();
  }

  Future<void> loadModelsByBrand(int brandId) async{
    _currentBrandId = brandId;
    _isLoading = true;
    _errorMessage = null;
    notifyListeners(); // Notificar ANTES de la carga para mostrar loader
    try{
      final response = await SmartTollsApi().getModelsByBrand(brandId);

      if(response.isSuccess() && response.dataList != null){
        _allModels = response.dataList!;
        _models = List.from(_allModels);
      }else{
        _errorMessage = response.message ?? 'Error al cargar los modelos';
        _allModels = [];
        _models = [];
      }
    }catch(e){
      _errorMessage = 'Error de conexión: ${e.toString()}';
    }finally{
      _isLoading = false;
      notifyListeners(); 
    }
  }

  Future<void> addModels(String modelName, int brandId) async{
  _isLoading = true;
  _errorMessage = null;
  notifyListeners();

  try{
    final request = StVehiclesModelsRequest(
      modelName: modelName,
      idBrand: brandId,
    );
    final response = await SmartTollsApi().createModels(request);
      if(response.isSuccess()){
        await loadModelsByBrand(brandId);
      }else{
        _errorMessage = response.message ?? 'Error al cargar los modelos';
      }
    }catch(e){
      _errorMessage = 'Error de conexión: ${e.toString()}';
    }finally{
      _isLoading = false;
      notifyListeners(); 
    }
  }
  void retryLoading(){
    _errorMessage = null;
    notifyListeners(); // Notificar antes de la carga para mostrar loader
    loadModelsByBrand(_currentBrandId!); // Recargar los modelos
  }

  void clearState(){
    _allModels = [];
    _models = [];
    _isLoading = false;
    _errorMessage = null;
    _selectedModel = null;
    _newModelName = null;
    _currentBrandId = null;
    notifyListeners(); // Notificar después de limpiar el estado
  }
}