import 'dart:convert';

import 'package:smarttolls/api/api.dart';
import 'package:smarttolls/models/models.dart';

class StVehiclesTypeResponse implements StResponseService {
  int idVehiclesType;
  String? vehiclesTypesName;
  int status;
  StAuditResponse audit;

  StVehiclesTypeResponse({
    required this.idVehiclesType,
    this.vehiclesTypesName,
    required this.status,
    required this.audit,
  });

  factory StVehiclesTypeResponse.createEmpty() => StVehiclesTypeResponse(
    idVehiclesType: 0,
    vehiclesTypesName: '',
    status: 0, 
    audit: StAuditResponse.createEmpty(),
  );

  @override
  String toJson() => json.encode(toMap());

  factory StVehiclesTypeResponse.fromJson(Map<String, dynamic> json) => StVehiclesTypeResponse(
    idVehiclesType: json["idVehiclesType"],
    vehiclesTypesName: json["vehiclesTypes"],
    status: json["status"],
    audit: StAuditResponse.fromJson(json["audit"]),
  );

  @override
  Map<String, dynamic> toMap() => {
    "idVehiclesType": idVehiclesType,
    "vehiclesTypes": vehiclesTypesName,
    "status": status,
    "audit": audit.toJson(),
  };

  @override
  StVehiclesTypeResponse fromJson(String json) {
    return fromMap(jsonDecode(json));
  }

  @override
  StVehiclesTypeResponse fromMap(Map<String, dynamic> json) => StVehiclesTypeResponse(
    idVehiclesType: json["idVehiclesType"],
    vehiclesTypesName: json["vehiclesTypes"],
    status: json["status"],
    audit: StAuditResponse.fromJson(json["audit"]),
  );
}