import 'package:flutter/material.dart';

class SignUpProvider extends ChangeNotifier{
  bool _isLoading = false;
  String? _errorMessage = '';

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

  }
}