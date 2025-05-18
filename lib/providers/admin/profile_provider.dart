// profile_provider.dart
import 'package:flutter/material.dart';
import 'package:smarttolls/api/api.dart';
import 'package:smarttolls/config/preferences.dart';
import 'package:smarttolls/models/models.dart';

class ProfileProvider extends ChangeNotifier {
  StPersonResponse? _currentUser;
  bool _isLoading = false;
  String? _errorMessage;

  StPersonResponse? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> loadCurrentUserData() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Verifica primero si tenemos un personId válido
      final personId = await Preferences().personId();
      if (personId == 0) {
        _errorMessage = 'No se pudo identificar al usuario';
        return;
      }

      final response = await SmartTollsApi().getCurrentUserData();
      
      if (response.isSuccess()) {
        if (response.data != null) {
          _currentUser = response.data;
        } else {
          _errorMessage = 'Datos de usuario no disponibles';
        }
      } else {
        _errorMessage = response.message ?? 'Error al cargar los datos del usuario';
      }
    } catch (e) {
      _errorMessage = 'Error: ${e.toString()}';
      debugPrint('Error en loadCurrentUserData: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void retryLoading() {
    _errorMessage = null;
    notifyListeners();
    loadCurrentUserData();
  }
}