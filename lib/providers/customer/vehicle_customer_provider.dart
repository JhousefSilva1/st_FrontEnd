import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smarttolls/api/api.dart';
import 'package:smarttolls/api/request/admin/st_vehicles_request.dart';
import 'package:smarttolls/providers/providers.dart';

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

  // agregar un nuevo vehiculo
 Future<void> addVehicle(
    String licensePlate,
    String chassisNumber,
    String engineNumber,
    String manufacturingYear,
    String weight,
    int idFuelTypes,
    int idVehiclesColors,
    int idVehiclesModels,
    int idVehiclesType,
    int idVehiclesBrand,
    int idCity,
    int idCountry,
    int personId, // Ahora recibimos el personId como parámetro
  ) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final request = StVehiclesRequest(
        licensePlate: licensePlate,
        chassisNumber: chassisNumber,
        engineNumber: engineNumber,
        manufacturingYear: manufacturingYear,
        weight: double.parse(weight),
        idFuelTypes: idFuelTypes,
        idVehiclesColors: idVehiclesColors,
        idVehiclesModels: idVehiclesModels,
        idVehiclesType: idVehiclesType,
        idVehiclesBrand: idVehiclesBrand,
        idCity: idCity,
        idCountry: idCountry,
        idPerson: personId, // Usamos el personId recibido
      );
      
      final response = await SmartTollsApi().addVehicle(request);
      debugPrint('API Response: ${response.status} - ${response.message}');

      if (response.isSuccess()) {
        // Recargar la lista de vehículos después de agregar uno nuevo
        await loadCustomerVehicles(personId);
      } else {
        _errorMessage = response.message ?? 'Error al agregar el vehículo';
      }
    } catch (e, stackTrace) {
      debugPrint('Error en addVehicle: $e');
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