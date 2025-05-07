import 'package:flutter/material.dart';
import 'package:smarttolls/api/api.dart';
class CountryProvider extends ChangeNotifier{
  List<StCountryResponse> _allCountries = []; // Lista completa
  List<StCountryResponse> _country= [];
  bool _isLoading = false;
  String? _errorMessage = '';
  String? _selectedCountry = '';
  String? _newCountryName;
  // int? _currentCountryId; // Añade esta variable para trackear el país actual
  List<StCountryResponse> get countries => _country;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String? get selectedCountry => _selectedCountry;
  String? get newCountryName => _newCountryName;
  // int? get currentCountryId => _currentCountryId; // Getter para el país actual
  // Método para buscar paises
  void searchCountries(String query){
    if(query.isEmpty){
      _country = List.from(_allCountries);
    }else{
      _country = _allCountries.where((country) =>
        country.countryName?.toLowerCase().contains(query.toLowerCase()) ?? false
      ).toList();
    }
    notifyListeners();
  }

  // cargar paises desde la API
  Future<void> loadCountries() async{
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try{
      final response = await SmartTollsApi().getAllCountries();

      if(response.isSuccess() && response.dataList != null){
        _allCountries = response.dataList!;
        _country = List.from(_allCountries);
      }else{
        _errorMessage = response.message ?? 'Error al cargar los paises';
      }
    }catch(e){
      _errorMessage = 'Error de conexión: ${e.toString()}';
    }finally{
      _isLoading = false;
      notifyListeners();
    }
  }
  // agregar nuevo pais
  Future<void> addCountries(String countryName) async{
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try{
      // Crear el objeto request con todos los datos
      final request = StCountryRequest(
        countryName: countryName,
      );
      // llamar a la API
      final response = await SmartTollsApi().createCountry(request);

      if(response.isSuccess()){
        await loadCountries(); // Recargar la lista de paises
      }else{
        _errorMessage = response.message ?? 'Error al agregar el pais';
      }
    }catch(e){
      _errorMessage = 'Error de conexión: ${e.toString()}';
    }finally{
      _isLoading = false;
      notifyListeners();
    }
  }
  // metodo para recargar datos
  void retryLoading(){
    _errorMessage = null;
    loadCountries();
  }

      void clearCountries() {
    // _currentCountryId = null;
    _allCountries = [];
    _country = [];
    notifyListeners();
  }
}