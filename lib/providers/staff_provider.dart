import 'package:flutter/material.dart';
import 'package:smarttolls/api/api.dart';

class StaffProvider extends ChangeNotifier {
  List<StPersonResponse> _allStaff = []; // Complete list
  List<StPersonResponse> _filteredStaff = []; // Filtered list
  bool _isLoading = false;
  String? _errorMessage = '';
  // String? _searchQuery = '';
  int? _currentPersonTypeId; // Current person type ID

  List<StPersonResponse> get filteredStaff => _filteredStaff;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  // String? get searchQuery => _searchQuery;
  int? get currentPersonTypeId => _currentPersonTypeId;
  
  // Search staff by name or surname
  void searchStaff(String query) {
    // _searchQuery = query;
    if (query.isEmpty) {
      // _filterStaff();
      _filteredStaff = List.from(_allStaff); // Reset to all staff
    } else {
      // _applySearchFilter(query);
      _filteredStaff = _allStaff.where((person) =>
        (person.personName?.toLowerCase().contains(query.toLowerCase()) ?? false) ||
        (person.personSurname?.toLowerCase().contains(query.toLowerCase()) ?? false)
      ).toList();
    }
    notifyListeners();
  }
  // Filter staff by personTypeId (1 and 3)
  // void _filterStaff() {
  //   _filteredStaff = _allStaff.where((person) => 
  //     person.personType.idPersonType == 1 || 
  //     person.personType.idPersonType == 3
  //   ).toList();
    
  //   if (_searchQuery != null && _searchQuery!.isNotEmpty) {
  //     _applySearchFilter(_searchQuery!);
  //   }
  // }


  // void _applySearchFilter(String query) {
  //   _filteredStaff = _filteredStaff.where((person) =>
  //     (person.personName?.toLowerCase().contains(query.toLowerCase()) ?? false) ||
  //     (person.personSurname?.toLowerCase().contains(query.toLowerCase()) ?? false)
  //   ).toList();
  // }

  // Load staff from API
Future<void> loadPersonsByPersonTypeId(int personTypeId) async {
  _currentPersonTypeId = personTypeId;
  _isLoading = true;
  _errorMessage = null;
  notifyListeners();
  
  try {
    final response = await SmartTollsApi().getAllPersonsByPersonType(personTypeId);
    print('API Response: ${response.dataList?.length} persons loaded');
    
    if (response.isSuccess()) {
      _allStaff = response.dataList ?? [];
      _filteredStaff = List.from(_allStaff);
      
      if (_allStaff.isEmpty) {
        _errorMessage = 'No se encontraron registros';
      } else {
        _errorMessage = null;
        // Debug: Imprime los primeros 3 registros para verificar
        for (var i = 0; i < (_allStaff.length > 3 ? 3 : _allStaff.length); i++) {
          print('Person ${i+1}: ${_allStaff[i].personName} ${_allStaff[i].personSurname}');
        }
      }
    } else {
      _errorMessage = response.message ?? 'Error al cargar los datos';
      _allStaff = [];
      _filteredStaff = [];
    }
  } catch (e, stackTrace) {
    _errorMessage = 'Error: ${e.toString()}';
    print('Error stack trace: $stackTrace');
    _allStaff = [];
    _filteredStaff = [];
  } finally {
    _isLoading = false;
    notifyListeners();
  }
}

  void retryLoading() {
    if(_currentPersonTypeId != null){
      _errorMessage = null;
      loadPersonsByPersonTypeId(_currentPersonTypeId!);
    }
  }
}