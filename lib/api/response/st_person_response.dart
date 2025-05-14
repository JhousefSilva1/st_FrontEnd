import 'dart:convert';

import 'package:smarttolls/api/api.dart';
import 'package:smarttolls/models/models.dart';
import 'package:flutter/foundation.dart';

class StPersonResponse implements StResponseService {
  final int idPerson;
  final String? personName;
  final String? personSurname;
  final String? personWhatsappNumber;
  final String? personPassword;
  final String? personDni;
  final DateTime? personBirthdate;
  final String? personEmail;
  final String? personAddress;
  final String? personAge;
  final int personStatus;
  final StGenderResponse gender;
  final StPersonTypeResponse personType;
  final StCityResponse city;
  final StCountryResponse country;
  final StAuditResponse audit;

  StPersonResponse({
    required this.idPerson,
    this.personName,
    this.personSurname,
    this.personWhatsappNumber,
    this.personPassword,
    this.personDni,
    this.personBirthdate,
    this.personEmail,
    this.personAddress,
    this.personAge,
    required this.personStatus,
    required this.gender,
    required this.personType,
    required this.city,
    required this.country,
    required this.audit,
  });

  factory StPersonResponse.createEmpty() => StPersonResponse(
        idPerson: 0,
        personName: '',
        personSurname: '',
        personWhatsappNumber: '',
        personPassword: '',
        personDni: '',
        personBirthdate: DateTime.now(),
        personEmail: '',
        personAddress: '',
        personAge: '0',
        personStatus: 1,
        gender: StGenderResponse.createEmpty(),
        personType: StPersonTypeResponse.createEmpty(),
        city: StCityResponse.createEmpty(),
        country: StCountryResponse.createEmpty(),
        audit: StAuditResponse.createEmpty(),
      );

  @override
  String toJson() => json.encode(toMap());

  factory StPersonResponse.fromJson(Map<String, dynamic> json) {
    try {
      // Debug: Verificar estructura del JSON
      debugPrint('Parsing StPersonResponse from JSON: ${json.keys}');

      return StPersonResponse(
        idPerson: _parseInt(json["idPerson"], 0),
        personName: json["personName"]?.toString(),
        personSurname: json["personSurname"]?.toString(),
        personWhatsappNumber: json["personWhatsappNumber"]?.toString(),
        personPassword: json["personPassword"]?.toString(),
        personDni: json["personDni"]?.toString(),
        personBirthdate: _parseDateTime(json["personBirthdate"]),
        personEmail: json["personEmail"]?.toString(),
        personAddress: json["personAddress"]?.toString(),
        personAge: json["personAge"]?.toString(),
        personStatus: _parseInt(json["personStatus"], 1),
        gender: StGenderResponse.fromJson(
            json["gender"] as Map<String, dynamic>? ?? {}),
        personType: StPersonTypeResponse.fromJson(
            json["personType"] as Map<String, dynamic>? ?? {}),
        city: StCityResponse.fromJson(
            json["city"] as Map<String, dynamic>? ?? {}),
        country: StCountryResponse.fromJson(
            json["country"] as Map<String, dynamic>? ?? {}),
        audit: StAuditResponse.fromJson(
            json["audit"] as Map<String, dynamic>? ?? {}),
      );
    } catch (e, stackTrace) {
      debugPrint('Error parsing StPersonResponse: $e');
      debugPrint('Stack trace: $stackTrace');
      debugPrint('Problematic JSON: $json');
      return StPersonResponse.createEmpty();
    }
  }

  @override
  Map<String, dynamic> toMap() => {
        "idPerson": idPerson,
        "personName": personName,
        "personSurname": personSurname,
        "personBirthdate": personBirthdate?.toIso8601String(),
        "personWhatsappNumber": personWhatsappNumber,
        "personEmail": personEmail,
        "personPassword": personPassword,
        "personDni": personDni,
        "personAddress": personAddress,
        "personAge": personAge,
        "personStatus": personStatus,
        "gender": gender.toMap(),
        "personType": personType.toMap(),
        "city": city.toMap(),
        "country": country.toMap(),
        "audit": audit.toJson(),
      };

  @override
  StPersonResponse fromJson(String json) {
    try {
      return fromMap(jsonDecode(json));
    } catch (e) {
      debugPrint('Error decoding JSON string: $e');
      return StPersonResponse.createEmpty();
    }
  }

  @override
  StPersonResponse fromMap(Map<String, dynamic> json) => StPersonResponse.fromJson(json);

  // Helpers para parsing seguro
  static DateTime? _parseDateTime(dynamic value) {
    if (value == null) return null;
    try {
      return DateTime.tryParse(value.toString());
    } catch (e) {
      debugPrint('Error parsing DateTime: $e');
      return null;
    }
  }

  static int _parseInt(dynamic value, int defaultValue) {
    if (value == null) return defaultValue;
    try {
      return int.tryParse(value.toString()) ?? defaultValue;
    } catch (e) {
      debugPrint('Error parsing int: $e');
      return defaultValue;
    }
  }
}