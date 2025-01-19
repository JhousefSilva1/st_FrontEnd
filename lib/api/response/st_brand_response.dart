import 'dart:convert';

import 'package:smarttolls/api/api.dart';
import 'package:smarttolls/models/models.dart';

class StBrandResponse implements StResponseService {
  int idBrand;
  String? brandName;
  String? brandDescription;
  String? brandManufacturingCountry;
  int status;
  StAuditResponse audit;

  StBrandResponse({
    required this.idBrand,
    this.brandName,
    this.brandDescription,
    this.brandManufacturingCountry,
    required this.status,
    required this.audit,
  });

  factory StBrandResponse.createEmpty() => StBrandResponse(
    idBrand: 0,
    brandName: '',
    brandDescription: '',
    brandManufacturingCountry: '',
    status: 0, 
    audit: StAuditResponse.createEmpty(),
  );

  @override
  String toJson() => json.encode(toMap());

  factory StBrandResponse.fromJson(Map<String, dynamic> json) => StBrandResponse(
    idBrand: json["idBrand"],
    brandName: json["brandName"],
    brandDescription: json["brandDescription"],
    brandManufacturingCountry: json["brandManufacturingCountry"],
    status: json["status"],
    audit: StAuditResponse.fromJson(json["audit"]),
  );

  @override
  Map<String, dynamic> toMap() => {
    "idBrand": idBrand,
    "brandName": brandName,
    "brandDescription": brandDescription,
    "brandManufacturingCountry": brandManufacturingCountry,
    "status": status,
    "audit": audit.toJson(),
  };

  @override
  StBrandResponse fromJson(String json) {
    return fromMap(jsonDecode(json));
  }

  @override
  StBrandResponse fromMap(Map<String, dynamic> json) => StBrandResponse(
    idBrand: json["idBrand"],
    brandName: json["brandName"],
    brandDescription: json["brandDescription"],
    brandManufacturingCountry: json["brandManufacturingCountry"],
    status: json["status"],
    audit: StAuditResponse.fromJson(json["audit"]),
  );
}