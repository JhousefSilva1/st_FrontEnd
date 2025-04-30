import 'package:flutter/material.dart';
import 'package:smarttolls/api/response/st_fuelt_types_response.dart';
import 'package:smarttolls/api/smart_tolls_api.dart';
import 'package:smarttolls/generated/l10n.dart';
import 'package:smarttolls/utils/utils.dart';
import 'package:smarttolls/widgets/custom_field.dart';


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
  Future<void> loadVehiclesType() async{
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
    notifyListeners();

    try{
      // final response = await SmartTollsApi().addFuelType(fuelTypeName);

    }catch(e){
      _errorMessage = 'Error de conexión: ${e.toString()}';
    }finally{
      _isLoading = false;
      notifyListeners();
    }
  }

  // mostrar el dialogo para agregar un nuevo tipo de combustible
  void goToAddFuelTypes(BuildContext context){
    final fuelTypeNameController = TextEditingController();

    Utils.textFieldAlert(
      context: context,
      content: CustomField(
        controller: fuelTypeNameController,
        hintText: S.of(context).fuel,
        keyboardType: TextInputType.text,
        onChanged: (value) {},
        prefixIcon: const Icon(Icons.oil_barrel)
      ),
      negativeText: S.of(context).cancel,
      positiveOnPressed: () {
        if(fuelTypeNameController.text.isNotEmpty){
          addFuelType(fuelTypeNameController.text);
          Navigator.pop(context);
        }
      },
      positiveText: S.of(context).add,
      title: S.of(context).addFuelTypes,
    );
  }
  // metodo para recargar datos
    void retryLoading(){
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    loadVehiclesType();
  }
}