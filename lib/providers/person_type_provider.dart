import 'package:flutter/material.dart';
import 'package:smarttolls/api/api.dart';

class PersonTypeProvider extends ChangeNotifier {
  List<StPersonTypeResponse> _allPersonTypes = [];
  List<StPersonTypeResponse> _personTypes = [];
  
  bool _isLoading = false;
  bool _isAdding = false;
  bool _isUpdating = false;
  bool _isDeleting = false;
  String? _errorMessage;

  // Getters
  List<StPersonTypeResponse> get personTypes => _personTypes;
  bool get isLoading => _isLoading;
  bool get isAdding => _isAdding;
  bool get isUpdating => _isUpdating;
  bool get isDeleting => _isDeleting;
  String? get errorMessage => _errorMessage;

  // Búsqueda de tipos de persona
  void searchPersonTypes(String query) {
    if (query.isEmpty) {
      _personTypes = List.from(_allPersonTypes);
    } else {
      _personTypes = _allPersonTypes.where((type) => 
        type.personType?.toLowerCase().contains(query.toLowerCase()) ?? false
      ).toList();
    }
    notifyListeners();
  }

  // Cargar tipos de persona desde la API
  Future<void> loadPersonTypes() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await SmartTollsApi().getAllPersonTypes();
      if (response.isSuccess() && response.dataList != null) {
        _allPersonTypes = response.dataList!;
        _personTypes = List.from(_allPersonTypes);
      } else {
        _errorMessage = response.message ?? 'Error al cargar los tipos de persona';
      }
    } catch (e) {
      _errorMessage = 'Error de conexión: ${e.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Agregar nuevo tipo de persona
  Future<void> addPersonType(String personTypeName) async {
    _isAdding = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final request = StPersonTypeRequest(personType: personTypeName);
      final response = await SmartTollsApi().createPersonType(request);
      
      if (response.isSuccess()) {
        await loadPersonTypes();
      } else {
        _errorMessage = response.message ?? 'Error al agregar tipo de persona';
      }
    } catch (e) {
      _errorMessage = 'Error al agregar: ${e.toString()}';
    } finally {
      _isAdding = false;
      notifyListeners();
    }
  }

  // Actualizar tipo de persona
  Future<void> updatePersonType(int id, String personTypeName) async {
    _isUpdating = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final request = StPersonTypeRequest(personType: personTypeName);
      final response = await SmartTollsApi().updatePersonType(id, request);
      
      if (response.isSuccess()) {
        await loadPersonTypes();
      } else {
        _errorMessage = response.message ?? 'Error al actualizar tipo de persona';
      }
    } catch (e) {
      _errorMessage = 'Error al actualizar: ${e.toString()}';
    } finally {
      _isUpdating = false;
      notifyListeners();
    }
  }

  // Eliminar tipo de persona
  Future<void> deletePersonType(int id) async {
    _isDeleting = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await SmartTollsApi().deletePersonType(id);
      
      if (response.isSuccess()) {
        await loadPersonTypes();
      } else {
        _errorMessage = response.message ?? 'Error al eliminar tipo de persona';
      }
    } catch (e) {
      _errorMessage = 'Error al eliminar: ${e.toString()}';
    } finally {
      _isDeleting = false;
      notifyListeners();
    }
  }

  // Reintentar carga
  void retryLoading() {
    _errorMessage = null;
    loadPersonTypes();
  }

  // Limpiar datos
  void clearPersonTypes() {
    _allPersonTypes = [];
    _personTypes = [];
    notifyListeners();
  }
}