import 'package:flutter/material.dart';
import 'package:smarttolls/api/api.dart';

class TollProvider extends ChangeNotifier {
  List<StTollResponse> _allTolls = [];
  List<StTollResponse> _tolls = [];
  bool _isLoading = false;
  String? _errorMessage = '';
  String? _selectedToll = '';
  String? _newTollName;

  List<StTollResponse> get tolls => _tolls;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String? get selectedToll => _selectedToll;
  String? get newTollName => _newTollName;

  void searchTolls(String query) {
    if (query.isEmpty) {
      _tolls = List.from(_allTolls);
    } else {
      _tolls = _allTolls
          .where((toll) =>
              toll.tollsName?.toLowerCase().contains(query.toLowerCase()) ??
              false)
          .toList();
    }
    notifyListeners();
  }
Future<void> loadAllTolls() async {
  _isLoading = true;
  _errorMessage = null;
  notifyListeners();

  try {
    final response = await SmartTollsApi().getAllTolls();
    
    // Agrega logs para debug
    debugPrint('API Response: ${response.status}');
    debugPrint('API Data: ${response.dataList?.length}');
    
    if (response.isSuccess()) {
      _allTolls = response.dataList ?? []; // Maneja el caso null
      _tolls = List.from(_allTolls);
    } else {
      _errorMessage = response.message ?? 'Error al cargar los peajes';
      _allTolls = [];
      _tolls = [];
    }
  } catch (e) {
    debugPrint('Error loading tolls: $e');
    _errorMessage = 'Error de conexión: ${e.toString()}';
    _allTolls = [];
    _tolls = [];
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
      final request = StTollRequest(
        tollsName: tollName,
        idPlace: placeId,
      );
      final response = await SmartTollsApi().createToll(request);

      if (response.isSuccess()) {
        await loadAllTolls(); // Recargar todos los peajes
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
    notifyListeners();
  }
}