import 'package:flutter/material.dart';
import 'package:smarttolls/api/api.dart';
import 'package:smarttolls/models/models.dart';

class VehiclesCustomerProvider extends ChangeNotifier {
  List<StVehicleResponse> _vehicles = [];
  bool _isLoading = false;
  String? _errorMessage = '';

  List<StVehicleResponse> get vehicles => _vehicles;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> loadCustomerVehicles(int personId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await SmartTollsApi().getVehiclesByPersonId(personId);
      debugPrint('API Response: ${response.status} - ${response.message}');

      if (response.isSuccess()) {
        if (response.dataList != null && response.dataList!.isNotEmpty) {
          _vehicles = response.dataList!;
        } else {
          _errorMessage = 'No se encontraron vehículos registrados';
        }
      } else {
        _errorMessage = response.message ?? 'Error al cargar los vehículos';
      }
    } catch (e, stackTrace) {
      debugPrint('Error en loadCustomerVehicles: $e');
      debugPrint('Stack trace: $stackTrace');
      _errorMessage = 'Error de conexión: ${e.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void retryLoading(int personId) {
    _errorMessage = null;
    notifyListeners();
    loadCustomerVehicles(personId);
  }
}