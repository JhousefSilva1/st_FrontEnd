import 'dart:convert';
import 'package:smarttolls/api/api.dart';
import 'package:smarttolls/models/st_response.dart';

class StTollResponse implements StResponseService {

  int idTolls;
  String? tollsName;
  int tollStatus;
  StPlaceResponse places;
  StAuditResponse audit;

  StTollResponse({
    required this.idTolls,
    this.tollsName,
    required this.tollStatus,
    required this.places,
    required this.audit,
  });

  factory StTollResponse.createEmpty()=> StTollResponse(
    idTolls: 0,
    tollsName: '',
    tollStatus: 0,
    places: StPlaceResponse.createEmpty(),
    audit: StAuditResponse.createEmpty(),
  );

  @override
  String toJson() => json.encode(toMap());

    factory StTollResponse.fromJson(Map<String, dynamic> json) => StTollResponse(
      idTolls: json["idTolls"] ?? 0, // Agrega valores por defecto
      tollsName: json["tollsName"],
      tollStatus: json["tollStatus"] ?? json["tollsStatus"] ?? 0, // Verifica el nombre correcto
      places: StPlaceResponse.fromJson(json["places"] ?? {}), // Maneja null
      audit: StAuditResponse.fromJson(json["audit"] ?? {}), // Maneja null
    );

  @override
  Map<String, dynamic> toMap() => {
    "idTolls": idTolls,
    "tollsName": tollsName,
    "tollStatus": tollStatus,
    "places": places.toJson(),
    "audit": audit.toJson(),
  };

  @override
  StTollResponse fromJson(String json) {
    return fromMap(jsonDecode(json));
  }

  @override
  StTollResponse fromMap(Map<String, dynamic> json) => StTollResponse(
    idTolls: json["idTolls"],
    tollsName: json["tollsName"],
    tollStatus: json["tollStatus"],
    places: StPlaceResponse.fromJson(json["places"]),
    audit: StAuditResponse.fromJson(json["audit"]),
  );
}