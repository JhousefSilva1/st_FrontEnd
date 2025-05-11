import 'package:flutter/material.dart';
import 'package:smarttolls/api/api.dart';

class PersonTypeProvider  extends ChangeNotifier {
  List<StPersonTypeResponse> _allPersonTypes = []; // Lista completa
  List<StPersonTypeResponse> _personTypes = [];
  bool _isLoading = false;
  String? _errorMessage = '';
  String? _selectedPersonType = '';
  String? _newPersonTypeName;

  List<StPersonTypeResponse> get personTypes => _personTypes;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String? get selectedPersonType => _selectedPersonType;
  String? get newPersonTypeName => _newPersonTypeName;

  // Método para buscar tipos de personas
  void searchPersonTypes(String query) {
    if (query.isEmpty) {
      _personTypes = List.from(_allPersonTypes);
    } else {
      _personTypes = _allPersonTypes.where((personType) =>
          personType.personType?.toLowerCase().contains(query.toLowerCase()) ?? false).toList();
    }
    notifyListeners();
  }

  // cargar tipos de personas desde la API
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
        _errorMessage = response.message ?? 'Error al cargar los tipos de personas';
      }
    } catch (e) {
      _errorMessage = 'Error de conexión: ${e.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // agregar nuevo tipo de persona
  Future<void> addPersonType(String personTypeName) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      // Crear el objeto request con todos los datos
      final request = StPersonTypeRequest(
        personType: personTypeName,
      );
      // llamar a la API
      final response = await SmartTollsApi().createPersonType(request);

      if (response.isSuccess()) {
        // Actualizar la lista local después de agregar un nuevo tipo de persona
        await loadPersonTypes();
      } else {
        _errorMessage = response.message ?? 'Error al agregar el tipo de persona';
      }
    } catch (e) {   
      _errorMessage = 'Error de conexión: ${e.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  void retryLoading(){
    _errorMessage = null;
    loadPersonTypes();
  }

  void clearPersonType(){
    _selectedPersonType = null;
    _newPersonTypeName = null;
    notifyListeners();
  }
}