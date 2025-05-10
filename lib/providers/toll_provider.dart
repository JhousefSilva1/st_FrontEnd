import 'package:flutter/material.dart';
import 'package:smarttolls/api/api.dart';

class TollProvider extends ChangeNotifier {
  List<StTollsResponse> _allTolls = [];
  List<StTollsResponse> _tolls = [];
  bool _isLoading = false;
  String? _errorMessage = '';
  String? _selectedToll = '';
  String? _newTollName;
  int? _selectedPlaceId;
  int? _selectedCityId;
  int? _selectedCountryId;

  List<StTollsResponse> get tolls => _tolls;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String? get selectedToll => _selectedToll;
  String? get newTollName => _newTollName;
  int? get selectedPlaceId => _selectedPlaceId;
  int? get selectedCityId => _selectedCityId;
  int? get selectedCountryId => _selectedCountryId;

  void searchTolls(String query) {
    if (query.isEmpty) {
      _tolls = List.from(_allTolls);
    } else {
      _tolls = _allTolls.where((toll) =>
          toll.tollsName?.toLowerCase().contains(query.toLowerCase()) ?? false).toList();
    }
    notifyListeners();
  }

  Future<void> loadAllTolls() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await SmartTollsApi().getAllTolls();

      if (response.isSuccess() && response.dataList != null) {
        _allTolls = response.dataList!;
        _tolls = List.from(_allTolls);
      } else {
        _errorMessage = response.message ?? 'Error al cargar los peajes';
        _allTolls = [];
        _tolls = [];
      }
    } catch (e) {
      _errorMessage = 'Error de conexión: ${e.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addToll(String tollName, int placeId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final request = StTollsRequest(
        tollsName: tollName,
        idPlaces: placeId,
      );
      final response = await SmartTollsApi().createToll(request);

      if (response.isSuccess()) {
        await loadAllTolls(); // Recargar la lista de peajes
      } else {
        _errorMessage = response.message ?? 'Error al agregar el peaje';
      }
    } catch (e) {
      _errorMessage = 'Error de conexión: ${e.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void updateSelectedIds(int? countryId, int? cityId, int? placeId) {
    _selectedCountryId = countryId;
    _selectedCityId = cityId;
    _selectedPlaceId = placeId;
    notifyListeners();
  }

  void retryLoading() {
    _errorMessage = null;
    loadAllTolls();
  }

  void clearState() {
    _allTolls = [];
    _tolls = [];
    _isLoading = false;
    _errorMessage = null;
    _selectedToll = null;
    _newTollName = null;
    _selectedPlaceId = null;
    _selectedCityId = null;
    _selectedCountryId = null;
    notifyListeners();
  }
}