import 'package:flutter/material.dart';
import 'package:smarttolls/api/api.dart';

class StaffPreviewProvider extends ChangeNotifier{
  List<StPersonTypeResponse> _allStaffsTypes = []; // Lista completa
  List<StPersonTypeResponse> _staffsTypes = [];// Lista filtrada
  bool _isLoading = false;
  String? _errorMessage = '';// Mensaje de error
  String? _selectedStaffType = '';// Tipo de persona seleccionado


  List<StPersonTypeResponse> get staffsTypes => _staffsTypes;// Lista de tipos de persona
  bool get isLoading => _isLoading;// Estado de carga
  String? get errorMessage => _errorMessage;// Mensaje de error
  String? get selectedStaffType => _selectedStaffType;// Tipo de persona seleccionado

  // Método para buscar tipos de Staff
  void searchStaffsTypes(String query) {
    if (query.isEmpty) {
      _staffsTypes = List.from(_allStaffsTypes);
    } else {
      _staffsTypes = _allStaffsTypes.where((staffType) =>
          staffType.personType?.toLowerCase().contains(query.toLowerCase()) ?? false).toList();
    }
    notifyListeners();
  }

  // cargar tipos de Staff desde la API
  Future<void> loadStaffType() async{
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try{
      final response = await SmartTollsApi().getAllPersonTypes();
      if(response.isSuccess() && response.dataList != null){
        _allStaffsTypes = response.dataList!;
        _staffsTypes = List.from(_allStaffsTypes); 
      }else{
        _errorMessage = response.message ?? 'Error al cargar los tipos de Staff';
      }
    }catch(e){
      _errorMessage = 'Error de conexión: ${e.toString()}';
    }finally{
      _isLoading = false;
      notifyListeners();
    }
  }

  void retryLoading(){
    // _isLoading = false;
    _errorMessage = null;
    notifyListeners();
  }

  void clearStaffType(){
    _selectedStaffType = null;
    notifyListeners();
  }
}