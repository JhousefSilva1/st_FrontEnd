import 'package:smarttolls/models/models.dart';
import 'package:smarttolls/api/api.dart';
import 'dart:convert';

class StGenderResponse implements StResponseService {

  int idGender;
  String? genderName;
  int genderStatus;
  StAuditResponse audit;

  StGenderResponse({
    required this.idGender,
    this.genderName,
    required this.genderStatus,
    required this.audit,
  });

  factory StGenderResponse.createEmpty() => StGenderResponse(
        idGender: 0,
        genderName: '',	
        genderStatus: 0,
        audit: StAuditResponse.createEmpty(),
      );

  @override
  String toJson() => json.encode(toMap());

  factory StGenderResponse.fromJson(Map<String, dynamic> json) => StGenderResponse(
        idGender: json["idGender"],
        genderName: json["genderName"],
        genderStatus: json["genderStatus"],
        audit: StAuditResponse.fromJson(json["audit"]),
      );
  
  @override
  Map<String, dynamic> toMap() =>{
        "idGender": idGender,
        "genderName": genderName,
        "genderStatus": genderStatus,
        "audit": audit.toJson(),
  };
  
  @override
  StGenderResponse fromJson(String json) {
    return fromMap(jsonDecode(json));
  }

  @override
  StGenderResponse fromMap(Map<String, dynamic> json) => StGenderResponse(
        idGender: json["idGender"],
        genderName: json["genderName"],
        genderStatus: json["genderStatus"],
        audit: StAuditResponse.fromJson(json["audit"]),
      );
}