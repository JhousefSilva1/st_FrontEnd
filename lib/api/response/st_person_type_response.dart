import 'package:smarttolls/models/models.dart';
import 'package:smarttolls/api/api.dart';
import 'dart:convert';

class StPersonTypeResponse implements StResponseService {

  int idPersonType;
  String? personType;
  int personTypeStatus;
  StAuditResponse audit;

  StPersonTypeResponse({
    required this.idPersonType,
    this.personType,
    required this.personTypeStatus,
    required this.audit,
  });

  factory StPersonTypeResponse.createEmpty() => StPersonTypeResponse(
        idPersonType: 0,
        personType: '',	
        personTypeStatus: 0,
        audit: StAuditResponse.createEmpty(),
      );

  @override
  String toJson() => json.encode(toMap());

  factory StPersonTypeResponse.fromJson(Map<String, dynamic> json) => StPersonTypeResponse(
        idPersonType: json["idPersonType"],
        personType: json["personType"],
        personTypeStatus: json["personTypeStatus"],
        audit: StAuditResponse.fromJson(json["audit"]),
      );

  @override
  Map<String, dynamic> toMap() =>{
        "idPersonType": idPersonType,
        "personType": personType,
        "personTypeStatus": personTypeStatus,
        "audit": audit.toJson(),
  };

  @override
  StPersonTypeResponse fromJson(String json) {
    return fromMap(jsonDecode(json));
  }

  @override
  StPersonTypeResponse fromMap(Map<String, dynamic> json) => StPersonTypeResponse(
        idPersonType: json["idPersonType"],
        personType: json["personType"],
        personTypeStatus: json["personTypeStatus"],
        audit: StAuditResponse.fromJson(json["audit"]),
      );
  

}