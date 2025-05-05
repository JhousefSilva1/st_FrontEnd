import 'package:flutter/material.dart';
import 'package:smarttolls/api/api.dart';
import 'package:smarttolls/style/app_style.dart';
import 'package:smarttolls/widgets/widgets.dart';

import '../generated/l10n.dart';
import '../utils/utils.dart';

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
    if (_currentBrandId == brandId && _allModels.isNotEmpty) return;
    
    _currentBrandId = brandId; // Actualiza la marca actual
    _isLoading = true;
    _errorMessage = null;
    _allModels = []; // Limpia los modelos anteriores
    _models = [];
    notifyListeners();
    try {
      final request = StBrandResponse.createEmpty()..idBrand = brandId;
      final response = await SmartTollsApi().getAllModelsByBrand(request);

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
    void clearModels() {
    _currentBrandId = null;
    _allModels = [];
    _models = [];
    notifyListeners();
  }
// add models

  Future<void>  addModels(String modelName) async {
    _isLoading = true;
    notifyListeners();

    try{
        // logica para agregar un nuevo modelo
    }catch (e){
      _errorMessage = 'Error de conexión: ${e.toString()}';
    }finally{
      _isLoading = false;
      notifyListeners();
    }
  }
// dialogo para agregar modelos
  void goToAddModels(BuildContext context){
    final modelNameController = TextEditingController();

    Utils.textFieldAlert(
      context: context,
      content: CustomField(
        controller:modelNameController,
        hintText: S.of(context).model,
        keyboardType: TextInputType.text,
        onChanged: (value) {},
        prefixIcon: const Icon(Icons.car_repair, color: AppStyle.primary),
      ),
      negativeText: S.of(context).cancel,
      positiveOnPressed: (){
        if (modelNameController.text.isNotEmpty) {
          addModels(modelNameController.text);
          Navigator.pop(context);
        }
      },
      positiveText: S.of(context).add,
      title: S.of(context).addModel,
    );
  }

  void retryLoading(){
    _errorMessage = null;
    notifyListeners();
    loadModelsByBrand(int.parse(_selectedModel!));
  }
}