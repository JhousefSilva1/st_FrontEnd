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

  // verificar si la matricula ya existe
  

Future<void> loadCustomerVehicles(int personId) async {
    if (personId <= 0) {
    _errorMessage = 'No se pudo identificar al usuario';
    _isLoading = false;
    notifyListeners();
    return;
  }
  _isLoading = true;
  _errorMessage = null;
  notifyListeners();

  try {
    final response = await SmartTollsApi().getVehiclesByPersonId(personId);
    debugPrint('API Response: ${response.status} - ${response.message}');

    if (response.isSuccess()) {
      // Caso exitoso
      _vehicles = response.dataList ?? []; // Asegurar lista vacía si es null
      
      // No es un error si la lista está vacía
      if (_vehicles.isEmpty) {
        _errorMessage = null; // Limpiar cualquier mensaje previo
      }
    } else {
      // Solo establecer mensaje de error si realmente hay un error
      _errorMessage = response.message ?? 'Error al cargar los vehículos';
    }
  } catch (e, stackTrace) {
    debugPrint('Error en loadCustomerVehicles: $e');
    debugPrint('Stack trace: $stackTrace');
    _errorMessage = 'Error de conexión: ${e.toString()}';
    _vehicles = []; // Limpiar la lista en caso de error
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
  int idVehiclesType,  // Este parámetro estaba después de idVehiclesBrand en tu código
  int idVehiclesBrand,
  int idCity,
  int idCountry,
  int personId,
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
    idVehiclesType: idVehiclesType,  // Asegúrate que el orden coincida
    idVehiclesBrand: idVehiclesBrand,
    idCity: idCity,
    idCountry: idCountry,
    idPerson: personId,
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

  // En VehiclesCustomerProvider
Future<void> updateVehicle(
  int vehicleId, // ID del vehículo a actualizar
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
  int personId, // Mantenemos el personId para recargar la lista después
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
      idPerson: personId,
    );
    
    final response = await SmartTollsApi().updateVehicle(vehicleId, request);
    debugPrint('API Response: ${response.status} - ${response.message}');

    if (response.isSuccess()) {
      // Recargar la lista de vehículos después de actualizar
      await loadCustomerVehicles(personId);
    } else {
      _errorMessage = response.message ?? 'Error al actualizar el vehículo';
    }
  } catch (e, stackTrace) {
    debugPrint('Error en updateVehicle: $e');
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