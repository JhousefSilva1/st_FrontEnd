import 'package:smarttolls/api/api.dart';

class StVehiclesModelsResponse {
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

  factory StVehiclesModelsResponse.fromJson(Map<String, dynamic> json) => StVehiclesModelsResponse(
    idModel: json["idModel"],
    modelName: json["modelName"],
    modelDescription: json["modelDescription"],
    brand: StBrandResponse.fromJson(json["brand"]),
    status: json["status"],
    audit: StAuditResponse.fromJson(json["audit"]),
  );

  Map<String, dynamic> toJson() => {
    "idModel": idModel,
    "modelName": modelName,
    "modelDescription": modelDescription,
    "brand": brand.toJson(),
    "status": status,
    "audit": audit.toJson(),
  };
}