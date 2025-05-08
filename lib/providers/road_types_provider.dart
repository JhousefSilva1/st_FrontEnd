import 'package:flutter/material.dart';
import 'package:smarttolls/api/api.dart';
class RoadTypesProvider extends ChangeNotifier {
  List<StRoadTypeResponse> _allRoadTypes = []; // Lista completa
  List<StRoadTypeResponse> _roadTypes = []; // Lista filtrada
  
  bool _isLoading = false;
  String? _errorMessage = '';
  String? _selectedRoadType = '';
  String? _newRoadTypeName;
  int _idRoadType = 0;	

  List<StRoadTypeResponse> get roadTypes => _roadTypes;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String? get selectedRoadType => _selectedRoadType;
  String? get newRoadTypeName => _newRoadTypeName;
  int get idRoadType => _idRoadType;

  // Método para buscar tipos de caminos
  void searchRoadTypes(String query){
    if (query.isEmpty){
      _roadTypes = List.from(_allRoadTypes);
    }else{
      _roadTypes = _allRoadTypes.where((roadType) => 
        roadType.roadType?.toLowerCase().contains(query.toLowerCase()) ?? false
      ).toList();
    }
    notifyListeners();
  }

  // Cargar tipos de caminos desde la API
  Future<void> loadRoadTypes() async{
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try{
      final response = await SmartTollsApi().getAllRoadTypes();
      if(response.isSuccess() && response.dataList != null){
        _allRoadTypes = response.dataList!;
        _roadTypes = List.from(_allRoadTypes);
      }else{
        _errorMessage = response.message ?? 'Error al cargar los tipos de caminos';
      }
    }catch(e){
      _errorMessage = 'Error de conexión: ${e.toString()}';
    }finally{
      _isLoading = false;
      notifyListeners();
    }
  }

  // agregar nuevo tipo de camino
  Future<void> addRoadType(String roadTypeName) async{
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try{
      // aca se implementa la logica para agregar un nuevo tipo de camino
      final request = StRoadTypeRequest(
        roadType: roadTypeName,
      );
      // llamar a la API
      final response = await SmartTollsApi().createRoadType(request);
        if(response.isSuccess()){
          await loadRoadTypes(); 
        }else{
          _errorMessage = response.message ?? 'Error al agregar el tipo de camino';
        }
    }catch (e){
      _errorMessage = 'Error de conexión: ${e.toString()}';
    }finally{
      _isLoading = false;
      notifyListeners();
    }
  }

  void retryLoading(){
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
  }
}