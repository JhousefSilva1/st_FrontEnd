import 'dart:convert';
import 'package:smarttolls/api/api.dart';
import 'package:smarttolls/models/models.dart';

class StCountryResponse implements StResponseService{
  int idCountry;
  String ? countryName;
  int countryStatus;
  StAuditResponse audit;

  StCountryResponse({
    required this.idCountry,
    this.countryName,
    required this.countryStatus,
    required this.audit,
  });

  factory StCountryResponse.createEmpty() => StCountryResponse(
    idCountry: 0,
    countryName: '',
    countryStatus: 0, 
    audit: StAuditResponse.createEmpty(),
  );

  @override
  String toJson() => json.encode(toMap());

  factory StCountryResponse.fromJson(Map<String, dynamic> json) => StCountryResponse(
    idCountry: json["idCountry"],
    countryName: json["countryName"],
    countryStatus: json["countryStatus"],
    audit: StAuditResponse.fromJson(json["audit"]),
  );

  @override
  Map<String, dynamic> toMap() => {
    "idCountry": idCountry,
    "countryName": countryName,
    "countryStatus": countryStatus,
    "audit": audit.toJson(),
  };

  @override
  StCountryResponse fromJson(String json){
    return fromMap(jsonDecode(json));
  }

  @override
  StCountryResponse fromMap(Map<String, dynamic> json) => StCountryResponse(
    idCountry: json["idCountry"],
    countryName: json["countryName"],
    countryStatus: json["countryStatus"],
    audit: StAuditResponse.fromJson(json["audit"]),
  );
}