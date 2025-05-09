import 'package:flutter/material.dart';
import 'package:smarttolls/api/api.dart';

class PlaceProvider extends ChangeNotifier{
  List<StPlaceResponse> _allPlaces = [];
  List<StPlaceResponse> _places = []; // 
  bool _isLoading = false;
  String? _errorMessage = '';
  String? _selectedPlace = '';
  String? _newPlaceName;
  int? _currentCityId; // Añade esta variable para trackear la ciudad actual

  List<StPlaceResponse> get places => _places;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String? get selectedPlace => _selectedPlace;
  String? get newPlaceName => _newPlaceName;
  int? get currentCityId => _currentCityId; // Getter para la ciudad actual

  void searchPlaces(String query){
    if(query.isEmpty){
      _places = List.from(_allPlaces);
    } else {
      _places = _allPlaces.where((place) =>
          place.placeName?.toLowerCase().contains(query.toLowerCase()) ?? false).toList();
    }
    notifyListeners();
  }


  Future<void> loadPlacesByCity(int cityId) async{
    _currentCityId = cityId; // Actualiza la ciudad actual
    _isLoading = true; // Cambia a true para mostrar el loader
    _errorMessage = null; // Limpia el mensaje de error
    notifyListeners(); // Notifica a los listeners para que actualicen la UI  
      try{
        final response = await SmartTollsApi().getPlacesByCity(cityId);

        if(response.isSuccess() && response.dataList != null){
          _allPlaces = response.dataList!;
          _places = List.from(_allPlaces); // Copia la lista completa
        } else {
          _errorMessage = response.message ?? 'Error al cargar los lugares';
          _allPlaces = []; // Limpia la lista si hay un error
          _places = []; // Limpia la lista si hay un error
        }
      }catch(e){
        _errorMessage = 'Error de conexión: ${e.toString()}';
      } finally {
        _isLoading = false; // Cambia a false para ocultar el loader
        notifyListeners(); // Notifica a los listeners después de la carga
      }
  }

  Future<void> addPlace(String placeName, int cityId) async{
    _isLoading = true; // Cambia a true para mostrar el loader
    _errorMessage = null; // Limpia el mensaje de error
    notifyListeners(); // Notifica a los listeners para que actualicen la UI

    try{
      final request = StPlacesRequest(
        placeName: placeName,
        idCity: cityId,
        idCountry: _currentCityId!, // Asegúrate de que currentCityId no sea nulo
      );
      final response = await SmartTollsApi().createPlace(request);

      if(response.isSuccess()){
        await loadPlacesByCity(cityId); // Recargar la lista de lugares
      } else {
        _errorMessage = response.message ?? 'Error al agregar el lugar';
      }
    }catch(e){
      _errorMessage = 'Error de conexión: ${e.toString()}';
    } finally {
      _isLoading = false; // Cambia a false para ocultar el loader
      notifyListeners(); // Notifica a los listeners después de la carga
    }
  }

  void retryLoading(){
    if(_currentCityId != null){
      _errorMessage = null; // Limpia el mensaje de error
      loadPlacesByCity(_currentCityId!); // Recarga los lugares de la ciudad actual
    }
  }

  void clearState(){
    _allPlaces = []; // Limpia la lista de lugares
    _places = []; // Limpia la lista de lugares
    _isLoading = false; // Cambia a false para ocultar el loader
    _errorMessage = null; // Limpia el mensaje de error
    _selectedPlace = null; // Limpia el lugar seleccionado
    _newPlaceName = null; // Limpia el nuevo nombre del lugar
    notifyListeners(); // Notifica a los listeners para que actualicen la UI
  }
}