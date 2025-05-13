import 'package:flutter/material.dart';
import 'package:smarttolls/api/api.dart';

class StaffProvider extends ChangeNotifier {
  List<StPersonResponse> _allStaff = []; // Complete list
  List<StPersonResponse> _filteredStaff = []; // Filtered list
  bool _isLoading = false;
  String? _errorMessage = '';
  String? _searchQuery = '';

  List<StPersonResponse> get filteredStaff => _filteredStaff;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String? get searchQuery => _searchQuery;

  // Filter staff by personTypeId (1 and 3)
  void _filterStaff() {
    _filteredStaff = _allStaff.where((person) => 
      person.personType.idPersonType == 1 || 
      person.personType.idPersonType == 3
    ).toList();
    
    if (_searchQuery != null && _searchQuery!.isNotEmpty) {
      _applySearchFilter(_searchQuery!);
    }
  }

  // Search staff by name or surname
  void searchStaff(String query) {
    _searchQuery = query;
    if (query.isEmpty) {
      _filterStaff();
    } else {
      _applySearchFilter(query);
    }
    notifyListeners();
  }

  void _applySearchFilter(String query) {
    _filteredStaff = _filteredStaff.where((person) =>
      (person.personName?.toLowerCase().contains(query.toLowerCase()) ?? false) ||
      (person.personSurname?.toLowerCase().contains(query.toLowerCase()) ?? false)
    ).toList();
  }

  // Load staff from API
  Future<void> loadStaff() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    
    try {
      final response = await SmartTollsApi().getAllPersons();
      if (response.isSuccess() && response.dataList != null) {
        _allStaff = response.dataList!;
        _filterStaff();
      } else {
        _errorMessage = response.message ?? 'Error al cargar el personal';
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
    notifyListeners();
    loadStaff();
  }
}