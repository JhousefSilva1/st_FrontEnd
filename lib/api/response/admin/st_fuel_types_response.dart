import 'dart:convert';

import 'package:smarttolls/api/api.dart';
import 'package:smarttolls/models/models.dart';

class StFuelTypesResponse implements StResponseService {
  int idFuelType;
  String? fuelTypeName;
  int status;
  StAuditResponse audit;

  StFuelTypesResponse({
    required this.idFuelType,
    this.fuelTypeName,
    required this.status,
    required this.audit,
  });

  factory StFuelTypesResponse.createEmpty() => StFuelTypesResponse(
    idFuelType: 0,
    fuelTypeName: '',
    status: 0, 
    audit: StAuditResponse.createEmpty(),
  );

  @override
  String toJson() => json.encode(toMap());

  factory StFuelTypesResponse.fromJson(Map<String, dynamic> json) => StFuelTypesResponse(
    idFuelType: json["idFuelType"],
    fuelTypeName: json["fuelTypeFuel"],
    status: json["status"],
    audit: StAuditResponse.fromJson(json["audit"]),
  );

  @override
  Map<String, dynamic> toMap() => {
    "idFuelType": idFuelType,
    "fuelTypeFuel": fuelTypeName,
    "status": status,
    "audit": audit.toJson(),
  };

  @override
  StFuelTypesResponse fromJson(String json) {
    return fromMap(jsonDecode(json));
  }

  @override
  StFuelTypesResponse fromMap(Map<String, dynamic> json) => StFuelTypesResponse(
    idFuelType: json["idFuelType"],
    fuelTypeName: json["fuelTypeFuel"],
    status: json["status"],
    audit: StAuditResponse.fromJson(json["audit"]),
  );
}