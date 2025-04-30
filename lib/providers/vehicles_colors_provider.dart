import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:smarttolls/api/response/st_vehicles_colors_response.dart';
import 'package:smarttolls/api/smart_tolls_api.dart';
import 'package:smarttolls/generated/l10n.dart';
import 'package:smarttolls/utils/utils.dart';
import 'package:smarttolls/widgets/custom_field.dart';

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
  Future<void> addColor(String colorName) async{
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try{
      // codigo para agregar color
    }catch(e){
      _errorMessage = 'Error de conexión: ${e.toString()}';
    }finally{
      _isLoading = false;
      notifyListeners();
    }
  }

  void goToAddColors(BuildContext context){
    final vehicleColorNameController = TextEditingController();

    Utils.textFieldAlert(
      context: context,
      content: CustomField(
        controller: vehicleColorNameController,
        hintText: S.of(context).vehicleColor,
        keyboardType: TextInputType.text,
        onChanged: (value) {},
        prefixIcon: const Icon(Icons.color_lens_outlined),
      ),
      negativeText: S.of(context).cancel,
      positiveOnPressed: (){
        if(vehicleColorNameController.text.isNotEmpty){
          addColor(vehicleColorNameController.text);
          Navigator.pop(context);
        }
      },
      positiveText: S.of(context).addColor,
      title: S.of(context).addColor,
    );
  }
    void retryLoading(){
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    loadVehiclesColors();
  }

}