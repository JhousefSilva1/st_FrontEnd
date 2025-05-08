import 'dart:convert';
import 'package:smarttolls/api/api.dart';
import 'package:smarttolls/models/st_response.dart';

class StCityResponse implements StResponseService {
  int idCity;
  String? cityName;
  int cityStatus;
  StCountryResponse country;
  StAuditResponse audit;

  StCityResponse({
    required this.idCity,
    this.cityName,
    required this.cityStatus,
    required this.country,
    required this.audit,
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
        idCity: json["idCity"],
        cityName: json["cityName"],
        cityStatus: json["cityStatus"],
        country: StCountryResponse.fromJson(json["country"]),
        audit: StAuditResponse.fromJson(json["audit"]),
      );

  @override
  Map<String, dynamic> toMap() => {
        "idCity": idCity,
        "cityName": cityName,
        "cityStatus": cityStatus,
        "country": country.toJson(),
        "audit": audit.toJson(),
      };

  @override
  StCityResponse fromJson(String json) {
    return fromMap(jsonDecode(json));
  }

  @override
  StCityResponse fromMap(Map<String, dynamic> json) => StCityResponse(
        idCity: json["idCity"],
        cityName: json["cityName"],
        cityStatus: json["cityStatus"],
        country: StCountryResponse.fromJson(json["country"]),
        audit: StAuditResponse.fromJson(json["audit"]),
      );
}