import 'package:smarttolls/api/api.dart';

class StVehiclesColorsResponse {
  int idColor;
  String? colorDescription;
  String? colorName;
  int status;
  StAuditResponse audit;

  StVehiclesColorsResponse({
    required this.idColor,
    this.colorDescription,
    this.colorName,
    required this.status,
    required this.audit,
  });

  factory StVehiclesColorsResponse.createEmpty() => StVehiclesColorsResponse(
    idColor: 0,
    colorDescription: '',
    colorName: '',
    status: 0, 
    audit: StAuditResponse.createEmpty(),
  );

  factory StVehiclesColorsResponse.fromJson(Map<String, dynamic> json) => StVehiclesColorsResponse(
    idColor: json["idColor"],
    colorDescription: json["colorDescription"],
    colorName: json["colorName"],
    status: json["status"],
    audit: StAuditResponse.fromJson(json["audit"]),
  );

  Map<String, dynamic> toJson() => {
    "idColor": idColor,
    "colorDescription": colorDescription,
    "colorName": colorName,
    "status": status,
    "audit": audit.toJson(),
  };
}