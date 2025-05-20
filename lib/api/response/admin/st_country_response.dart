import 'dart:convert';
import 'package:smarttolls/api/api.dart';
import 'package:smarttolls/models/models.dart';

class StCountryResponse implements StResponseService {
  int idCountry;
  String? countryName;
  int? countryStatus;  // Cambiado a nullable
  StAuditResponse? audit;  // Cambiado a nullable

  StCountryResponse({
    required this.idCountry,
    this.countryName,
    this.countryStatus,
    this.audit,
  });

  factory StCountryResponse.createEmpty() => StCountryResponse(
    idCountry: 0,
    countryName: '',
    countryStatus: 0,
    audit: StAuditResponse.createEmpty(),
  );

  @override
  String toJson() => json.encode(toMap());

  factory StCountryResponse.fromJson(Map<String, dynamic> json) => StCountryResponse(
    idCountry: json["idCountry"] as int? ?? 0,  // Manejo de nulos
    countryName: json["countryName"] as String?,
    countryStatus: json["countryStatus"] as int? ?? 0,  // Valor por defecto
    audit: json["audit"] != null 
        ? StAuditResponse.fromJson(json["audit"]) 
        : StAuditResponse.createEmpty(),
  );

  @override
  Map<String, dynamic> toMap() => {
    "idCountry": idCountry,
    "countryName": countryName,
    "countryStatus": countryStatus,
    "audit": audit?.toJson(),  // Uso del operador ?.
  };

  @override
  StCountryResponse fromJson(String json) {
    return fromMap(jsonDecode(json));
  }

  @override
  StCountryResponse fromMap(Map<String, dynamic> json) => StCountryResponse(
    idCountry: json["idCountry"] as int? ?? 0,
    countryName: json["countryName"] as String?,
    countryStatus: json["countryStatus"] as int? ?? 0,
    audit: json["audit"] != null 
        ? StAuditResponse.fromJson(json["audit"]) 
        : StAuditResponse.createEmpty(),
  );
}