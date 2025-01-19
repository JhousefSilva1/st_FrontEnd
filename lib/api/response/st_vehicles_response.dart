// To parse this JSON data, do
//
//     final vehicleResponse = vehicleResponseFromJson(jsonString);

import 'dart:convert';

import 'package:smarttolls/api/api.dart';
import 'package:smarttolls/models/models.dart';

List<StVehicleResponse> vehicleResponseFromJson(String str) => List<StVehicleResponse>.from(json.decode(str).map((x) => StVehicleResponse.fromJson(x)));

String vehicleResponseToJson(List<StVehicleResponse> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class StVehicleResponse implements StResponseService{
  int? idVehicle;
  String? licensePlate;
  String? chassisNumber;
  String? engineNumber;
  String? manufacturingYear;
  double? weight;
  StFuelTypesResponse fuelTypes;
  StVehiclesColorsResponse vehiclesColors;
  StVehiclesModelsResponse vehiclesModels;
  StVehiclesTypeResponse vehiclesType;
  int status;
  StAuditResponse audit;

  StVehicleResponse({
    this.idVehicle,
    this.licensePlate,
    this.chassisNumber,
    this.engineNumber,
    this.manufacturingYear,
    this.weight,
    required this.fuelTypes,
    required this.vehiclesColors,
    required this.vehiclesModels,
    required this.vehiclesType,
    required this.status,
    required this.audit,
  });

  factory StVehicleResponse.createEmpty() => StVehicleResponse(
    idVehicle: 0,
    licensePlate: "",
    chassisNumber: "",
    engineNumber: "",
    manufacturingYear: "",
    weight: 0,
    fuelTypes: StFuelTypesResponse.createEmpty(),
    vehiclesColors: StVehiclesColorsResponse.createEmpty(),
    vehiclesModels: StVehiclesModelsResponse.createEmpty(),
    vehiclesType: StVehiclesTypeResponse.createEmpty(),
    status: 0,
    audit: StAuditResponse.createEmpty(),
  );

  @override
  String toJson() => json.encode(toMap());

  factory StVehicleResponse.fromJson(Map<String, dynamic> json) => StVehicleResponse(
    idVehicle: json["idVehicle"],
    licensePlate: json["licensePlate"],
    chassisNumber: json["chassisNumber"],
    engineNumber: json["engineNumber"],
    manufacturingYear: json["manufacturingYear"],
    weight: json["weight"],
    fuelTypes: StFuelTypesResponse.fromJson(json["fuelTypes"]),
    vehiclesColors: StVehiclesColorsResponse.fromJson(json["vehiclesColors"]),
    vehiclesModels: StVehiclesModelsResponse.fromJson(json["vehiclesModels"]),
    vehiclesType: StVehiclesTypeResponse.fromJson(json["vehiclesType"]),
    status: json["status"],
    audit: StAuditResponse.fromJson(json["audit"]),
  );
  
  @override
  Map<String, dynamic> toMap() => {
    "idVehicle": idVehicle,
    "licensePlate": licensePlate,
    "chassisNumber": chassisNumber,
    "engineNumber": engineNumber,
    "manufacturingYear": manufacturingYear,
    "weight": weight,
    "fuelTypes": fuelTypes.toJson(),
    "vehiclesColors": vehiclesColors.toJson(),
    "vehiclesModels": vehiclesModels.toJson(),
    "vehiclesType": vehiclesType.toJson(),
    "status": status,
    "audit": audit.toJson(),
  };
  
  @override
  StVehicleResponse fromJson(String json) {
    return fromMap(jsonDecode(json));
  }
  
  @override
  StVehicleResponse fromMap(Map<String, dynamic> json) => StVehicleResponse(
    idVehicle: json["idVehicle"],
    licensePlate: json["licensePlate"],
    chassisNumber: json["chassisNumber"],
    engineNumber: json["engineNumber"],
    manufacturingYear: json["manufacturingYear"],
    weight: json["weight"],
    fuelTypes: StFuelTypesResponse.fromJson(json["fuelTypes"]),
    vehiclesColors: StVehiclesColorsResponse.fromJson(json["vehiclesColors"]),
    vehiclesModels: StVehiclesModelsResponse.fromJson(json["vehiclesModels"]),
    vehiclesType: StVehiclesTypeResponse.fromJson(json["vehiclesType"]),
    status: json["status"],
    audit: StAuditResponse.fromJson(json["audit"])
  );
}
