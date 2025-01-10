import 'package:smarttolls/api/api.dart';

class StVehiclesTypeResponse {
  int idVehiclesType;
  String? vehiclesTypes;
  int status;
  StAuditResponse audit;

  StVehiclesTypeResponse({
    required this.idVehiclesType,
    this.vehiclesTypes,
    required this.status,
    required this.audit,
  });

  factory StVehiclesTypeResponse.createEmpty() => StVehiclesTypeResponse(
    idVehiclesType: 0,
    vehiclesTypes: '',
    status: 0, 
    audit: StAuditResponse.createEmpty(),
  );

  factory StVehiclesTypeResponse.fromJson(Map<String, dynamic> json) => StVehiclesTypeResponse(
    idVehiclesType: json["idVehiclesType"],
    vehiclesTypes: json["vehiclesTypes"],
    status: json["status"],
    audit: StAuditResponse.fromJson(json["audit"]),
  );

  Map<String, dynamic> toJson() => {
    "idVehiclesType": idVehiclesType,
    "vehiclesTypes": vehiclesTypes,
    "status": status,
    "audit": audit.toJson(),
  };
}