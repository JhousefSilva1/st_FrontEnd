import 'package:flutter/foundation.dart';
import 'package:smarttolls/api/api.dart';

class GenderProvider extends ChangeNotifier{
  List<StGenderResponse> _allGenders = [];
  List<StGenderResponse> _gender = [];
  bool _isLoading = false;
  String? _errorMessage = '';
  String? _selectedGender = '';
  String? _newGenderName;
  // int? _currentGenderId; // Añade esta variable para trackear el género actual
  List<StGenderResponse> get gender => _gender;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String? get selectedGender => _selectedGender;
  String? get newGenderName => _newGenderName;
  // int? get currentGenderId => _currentGenderId; // Getter para el género actual
  // Método para buscar géneros
  void searchGenders(String query){
    if(query.isEmpty){
      _gender = List.from(_allGenders);
    }else{
      _gender = _allGenders.where((gender) =>
        gender.genderName?.toLowerCase().contains(query.toLowerCase()) ?? false
      ).toList();
    }
    notifyListeners();
  }

  // cargar géneros desde la API
  Future<void> loadGenders() async{
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try{
      final response = await SmartTollsApi().getAllGenders();
        
        if(response.isSuccess() && response.dataList != null){
          _allGenders = response.dataList!;
          _gender = List.from(_allGenders);
        }else{
          _errorMessage = response.message ?? 'Error al cargar los géneros';
        }
    }catch(e){
      _errorMessage = 'Error de conexión: ${e.toString()}';
    }finally{
      _isLoading = false;
      notifyListeners();
    }
  }
  // agregar nuevo géneroq
  Future<void> addGenders(String genderName) async{
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try{
      // crear el objeto request con todos los datos
      final request = StGenderRequest(
        genderName: genderName,
      );
      // llamar a la API
      final response = await SmartTollsApi().createGender(request);
        
        if(response.isSuccess()){
          await loadGenders(); // Recargar la lista de géneros
        }else{
          _errorMessage = response.message ?? 'Error al agregar el género';
        }
    }catch(e){
      _errorMessage = 'Error de conexión: ${e.toString()}';
    }finally{
      _isLoading = false;
      notifyListeners();
    }
  }
  // Método para recargar los dattos
  void retryLoading(){
    _errorMessage = null;
     loadGenders();
  }
  // metodo para limpiar
  void clearGenders(){
    _allGenders = [];
    _gender = [];
    notifyListeners();
  }
}