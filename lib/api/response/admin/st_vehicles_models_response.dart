import 'dart:convert';

import 'package:smarttolls/api/api.dart';
import 'package:smarttolls/models/models.dart';

class StVehiclesModelsResponse implements StResponseService {
  int idModel;
  String? modelName;
  String? modelDescription;
  StBrandResponse brand;
  int status;
  StAuditResponse audit;

  StVehiclesModelsResponse({
    required this.idModel,
    this.modelName,
    this.modelDescription,
    required this.brand,
    required this.status,
    required this.audit,
  });

  factory StVehiclesModelsResponse.createEmpty() => StVehiclesModelsResponse(
    idModel: 0,
    modelName: '',
    modelDescription: '',
    brand: StBrandResponse.createEmpty(),
    status: 0, 
    audit: StAuditResponse.createEmpty(),
  );

  @override
  String toJson() => json.encode(toMap());

  factory StVehiclesModelsResponse.fromJson(Map<String, dynamic> json) => StVehiclesModelsResponse(
    idModel: json["idModel"],
    modelName: json["modelName"],
    modelDescription: json["modelDescription"],
    brand: StBrandResponse.fromJson(json["brand"]),
    status: json["status"],
    audit: StAuditResponse.fromJson(json["audit"]),
  );

  @override
  Map<String, dynamic> toMap() => {
    "idModel": idModel,
    "modelName": modelName,
    "modelDescription": modelDescription,
    "brand": brand.toJson(),
    "status": status,
    "audit": audit.toJson(),
  };

  @override
  StVehiclesModelsResponse fromJson(String json) {
    return fromMap(jsonDecode(json));
  }

  @override
  StVehiclesModelsResponse fromMap(Map<String, dynamic> json) => StVehiclesModelsResponse(
    idModel: json["idModel"],
    modelName: json["modelName"],
    modelDescription: json["modelDescription"],
    brand: StBrandResponse.fromJson(json["brand"]),
    status: json["status"],
    audit: StAuditResponse.fromJson(json["audit"]),
  );
}