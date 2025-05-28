import 'package:flutter/material.dart';
import 'package:smarttolls/api/api.dart';
class VehicleTypeProvider extends ChangeNotifier {
  List<StVehiclesTypeResponse> _allVehiclesType = []; // Lista completa
  List<StVehiclesTypeResponse> _vehiclesType = []; // Lista filtrada  

  bool _isLoading = false;

  String? _errorMessage = '';
  String? _selectedVehicleType = '';
  String? _newVehicleTypeName;

  List<StVehiclesTypeResponse> get vehiclesType => _vehiclesType;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String? get selectedVehiclesType => _selectedVehicleType;
  String? get newVehicleTypeName => _newVehicleTypeName;

  // Método para buscar tipos de vehículos
  void searchVehiclesType(String query){
    if (query.isEmpty){
      _vehiclesType = List.from(_allVehiclesType);
    }else{
      _vehiclesType = _allVehiclesType.where((vehicleType) => 
        vehicleType.vehiclesTypesName?.toLowerCase().contains(query.toLowerCase()) ?? false
      ).toList();
    }
    notifyListeners();
  }

  // cargar tipos de vehículos desde la API
  Future<void> loadVehiclesType() async{
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try{
      final response = await SmartTollsApi().getAllTypeVehicles();
      if(response.isSuccess() && response.dataList != null){
        _allVehiclesType = response.dataList!;
        _vehiclesType = List.from(_allVehiclesType);
      }else{
        _errorMessage = response.message ?? 'Error al cargar los tipos de vehículos';
      }
    }catch(e){
      _errorMessage = 'Error de conexión: ${e.toString()}';
    }finally{
      _isLoading = false;
      notifyListeners();
    }
  }

  // agregar nuevo tipo de vehículo
  Future<void> addVehiclesType(String vehiclesTypeName) async{
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try{
      // Aca se implementa la logica para agregar un nuevo tipo de vehiculo
      final request = StVehiclesTypeRequest(
        vehiclesTypes: vehiclesTypeName,
      );
      // llamar a la API
      final response = await SmartTollsApi().createVehicleType(request);
          if (response.isSuccess()) {
      await loadVehiclesType(); // Recargar la lista de marcas
    } else {
      _errorMessage = response.message ?? 'Error al agregar el tipo de vehículo';
    }
    }catch(e){
      _errorMessage = 'Error de conexión: ${e.toString()}';
    }finally{
      _isLoading = false;
      notifyListeners();
    }
  }

  // metodo para actualizar un tipo de vehículo
  Future<void> updateVehiclesType(int idVehiclesType, String vehiclesTypeName) async{
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try{
      final request = StVehiclesTypeRequest(
        
        vehiclesTypes: vehiclesTypeName,
      );
      // llamar a la API
      final response = await SmartTollsApi().updateVehicleType(idVehiclesType, request);
      if (response.isSuccess()) {
      await loadVehiclesType(); // Recargar la lista de marcas
    } else {
      _errorMessage = response.message ?? 'Error al actualizar el tipo de vehículo';
    }
    }catch(e){
      _errorMessage = 'Error de conexión: ${e.toString()}';
    }finally{
      _isLoading = false;
      notifyListeners();
    }
  }

  // metodo para eliminar un tipo de vehículo
  Future<void> deleteVehiclesType(int idVehiclesType) async{
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try{
      // llamar a la API
      final response = await SmartTollsApi().deleteVehicleType(idVehiclesType);
      if (response.isSuccess()) {
        await loadVehiclesType(); // Recargar la lista de marcas
      } else {
        _errorMessage = response.message ?? 'Error al eliminar el tipo de vehículo';
      }
    }catch(e){
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
    loadVehiclesType();
  }
}