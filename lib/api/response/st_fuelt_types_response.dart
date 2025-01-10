import 'package:smarttolls/api/api.dart';

class StFuelTypesResponse {
  int idFuelType;
  String? fuelTypeFuel;
  int status;
  StAuditResponse audit;

  StFuelTypesResponse({
    required this.idFuelType,
    this.fuelTypeFuel,
    required this.status,
    required this.audit,
  });

  factory StFuelTypesResponse.createEmpty() => StFuelTypesResponse(
    idFuelType: 0,
    fuelTypeFuel: '',
    status: 0, 
    audit: StAuditResponse.createEmpty(),
  );

  factory StFuelTypesResponse.fromJson(Map<String, dynamic> json) => StFuelTypesResponse(
    idFuelType: json["idFuelType"],
    fuelTypeFuel: json["fuelTypeFuel"],
    status: json["status"],
    audit: StAuditResponse.fromJson(json["audit"]),
  );

  Map<String, dynamic> toJson() => {
    "idFuelType": idFuelType,
    "fuelTypeFuel": fuelTypeFuel,
    "status": status,
    "audit": audit.toJson(),
  };
}