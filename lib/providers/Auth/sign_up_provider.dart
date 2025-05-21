import 'package:flutter/material.dart';
import 'package:smarttolls/api/api.dart';
import 'package:smarttolls/api/request/customer/signup_request.dart';

class SignUpProvider extends ChangeNotifier{
  bool _isLoading = false;
  String? _errorMessage = '';
  bool get isLoading => _isLoading;
    String? get errorMessage => _errorMessage;

  Future<void>signup(
    String personName,
    String personSurname,
    String personBirthdate,
    String personWhatsappNumber,
    String personEmail,
    String personPassword,
    String personDni,
    String personAddress,
    String personAge,
    int idGender,
    int idPersonType,
    int idCountry,
    int idCity,
  )async{
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Aquí iría la lógica para realizar el registro de usuario
      // Por ejemplo, llamar a una API para registrar al usuario
      // y manejar la respuesta.
      // Si el registro es exitoso, puedes navegar a otra pantalla o mostrar un mensaje de éxito.
      final request = StSignUpRequest(
        personName: personName,
        personSurname: personSurname,
        personBirthdate: personBirthdate,
        personWhatsappNumber: personWhatsappNumber,
        personEmail: personEmail,
        personPassword: personPassword,
        personDni: personDni,
        personAddress: personAddress,
        personAge: personAge,
        idGender: idGender,
        idPersonType: idPersonType,
        idCountry: idCountry,
        idCity: idCity,
      );
      final response = await SmartTollsApi().signup(request);
      debugPrint('API Response: ${response.status} - ${response.message}');

      if(response.isSuccess()){
        // Aquí puedes manejar la respuesta exitosa, como navegar a otra pantalla o mostrar un mensaje de éxito.
        debugPrint('Registro exitoso: ${response.data}');
      }else{
        // Manejar el error de registro, por ejemplo, mostrar un mensaje al usuario.
        _errorMessage = response.message ?? 'Error al registrar el usuario';
      }
    
    }catch (e, stackTrace) {
      debugPrint('Error en addVehicle: $e');
      debugPrint('Stack trace: $stackTrace');
      _errorMessage = 'Error de conexión: ${e.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}