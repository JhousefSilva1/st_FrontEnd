import 'dart:convert';

import 'package:smarttolls/api/api.dart';
import 'package:smarttolls/models/models.dart';

class StVehiclesColorsResponse implements StResponseService {
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

  @override
  String toJson() => json.encode(toMap());

  factory StVehiclesColorsResponse.fromJson(Map<String, dynamic> json) => StVehiclesColorsResponse(
    idColor: json["idColor"],
    colorDescription: json["colorDescription"],
    colorName: json["colorName"],
    status: json["status"],
    audit: StAuditResponse.fromJson(json["audit"]),
  );

  @override
  Map<String, dynamic> toMap() => {
    "idColor": idColor,
    "colorDescription": colorDescription,
    "colorName": colorName,
    "status": status,
    "audit": audit.toJson(),
  };

  @override
  StVehiclesColorsResponse fromJson(String json) {
    return fromMap(jsonDecode(json));
  }

  @override
  StVehiclesColorsResponse fromMap(Map<String, dynamic> json) => StVehiclesColorsResponse(
    idColor: json["idColor"],
    colorDescription: json["colorDescription"],
    colorName: json["colorName"],
    status: json["status"],
    audit: StAuditResponse.fromJson(json["audit"]),
  );
}