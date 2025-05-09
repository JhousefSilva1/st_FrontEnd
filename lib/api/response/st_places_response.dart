import 'dart:convert';
import 'package:smarttolls/api/api.dart';
import 'package:smarttolls/models/st_response.dart';

class StPlaceResponse implements StResponseService {
  int idPlaces;
  String? placeName;
  int placesStatus;
  StCityResponse city;
  StAuditResponse audit;

  StPlaceResponse({
    required this.idPlaces,
    this.placeName,
    required this.placesStatus,
    required this.city,
    required this.audit,
  });

  factory StPlaceResponse.createEmpty() => StPlaceResponse(
        idPlaces: 0,
        placeName: '',
        placesStatus: 0,
        city: StCityResponse.createEmpty(),
        audit: StAuditResponse.createEmpty(),
      );

  @override
  String toJson() => json.encode(toMap());

  factory StPlaceResponse.fromJson(Map<String, dynamic> json) => StPlaceResponse(
        idPlaces: json["idPlaces"],
        placeName: json["placeName"],
        placesStatus: json["placesStatus"],
        city: StCityResponse.fromJson(json["city"]),
        audit: StAuditResponse.fromJson(json["audit"]),
      );

  @override
  Map<String, dynamic> toMap() => {
        "idPlaces": idPlaces,
        "placeName": placeName,
        "placesStatus": placesStatus,
        "city": city.toJson(),
        "audit": audit.toJson(),
      };

  @override
  StPlaceResponse fromJson(String json) {
    return fromMap(jsonDecode(json));
  }

  @override
  StPlaceResponse fromMap(Map<String, dynamic> json) => StPlaceResponse(
        idPlaces: json["idPlaces"],
        placeName: json["placeName"],
        placesStatus: json["placesStatus"],
        city: StCityResponse.fromJson(json["city"]),
        audit: StAuditResponse.fromJson(json["audit"]),
      );
}