import 'dart:convert';

import 'package:smarttolls/api/api.dart';
import 'package:smarttolls/models/st_response.dart';

class StCityResponse implements StResponseService {
  int idCity;
  String? cityName;
  int? cityStatus;  // Cambiado a nullable
  StCountryResponse? country;  // Cambiado a nullable
  StAuditResponse? audit;  // Cambiado a nullable

  StCityResponse({
    required this.idCity,
    this.cityName,
    this.cityStatus,
    this.country,
    this.audit,
  });

  factory StCityResponse.createEmpty() => StCityResponse(
        idCity: 0,
        cityName: '',
        cityStatus: 0,
        country: StCountryResponse.createEmpty(),
        audit: StAuditResponse.createEmpty(),
      );

  @override
  String toJson() => json.encode(toMap());

  factory StCityResponse.fromJson(Map<String, dynamic> json) => StCityResponse(
        idCity: json["idCity"] as int? ?? 0,  // Manejo de nulos
        cityName: json["cityName"] as String?,
        cityStatus: json["cityStatus"] as int? ?? 0,  // Valor por defecto
        country: json["country"] != null 
            ? StCountryResponse.fromJson(json["country"]) 
            : StCountryResponse.createEmpty(),
        audit: json["audit"] != null 
            ? StAuditResponse.fromJson(json["audit"]) 
            : StAuditResponse.createEmpty(),
      );

  @override
  Map<String, dynamic> toMap() => {
        "idCity": idCity,
        "cityName": cityName,
        "cityStatus": cityStatus,
        "country": country?.toMap(),  // Uso del operador ?.
        "audit": audit?.toJson(),  // Uso del operador ?.
      };

  @override
  StCityResponse fromJson(String json) {
    return fromMap(jsonDecode(json));
  }

  @override
  StCityResponse fromMap(Map<String, dynamic> json) => StCityResponse(
        idCity: json["idCity"] as int? ?? 0,
        cityName: json["cityName"] as String?,
        cityStatus: json["cityStatus"] as int? ?? 0,
        country: json["country"] != null 
            ? StCountryResponse.fromJson(json["country"]) 
            : StCountryResponse.createEmpty(),
        audit: json["audit"] != null 
            ? StAuditResponse.fromJson(json["audit"]) 
            : StAuditResponse.createEmpty(),
      );
}