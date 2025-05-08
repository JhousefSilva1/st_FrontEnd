import 'dart:convert';
import 'package:smarttolls/api/api.dart';
import 'package:smarttolls/models/models.dart';

class StRoadTypeResponse implements StResponseService {
  int idRoadType;
  String? roadType;
  int roadTypeStatus;
  StAuditResponse audit;

  StRoadTypeResponse({
    required this.idRoadType,
    this.roadType,
    required this.roadTypeStatus,
    required this.audit,
  });

  factory StRoadTypeResponse.createEmpty() => StRoadTypeResponse(
    idRoadType: 0,
    roadType: '',
    roadTypeStatus: 0, 
    audit: StAuditResponse.createEmpty(),
  );

  @override
  String toJson() => json.encode(toMap());

  factory StRoadTypeResponse.fromJson(Map<String, dynamic> json) => StRoadTypeResponse(
    idRoadType: json["idRoadType"],
    roadType: json["roadType"],
    roadTypeStatus: json["roadTypeStatus"],
    audit: StAuditResponse.fromJson(json["audit"]),
  );

  @override
  Map<String, dynamic> toMap() =>{
    "idRoadType": idRoadType,
    "roadType": roadType,
    "roadTypeStatus": roadTypeStatus,
    "audit": audit.toJson(),
  };

  @override
  StRoadTypeResponse fromJson(String json) {
    return fromMap(jsonDecode(json));
  }

  @override
  StRoadTypeResponse fromMap(Map<String, dynamic> json) => StRoadTypeResponse(
    idRoadType: json["idRoadType"],
    roadType: json["roadType"],
    roadTypeStatus: json["roadTypeStatus"],
    audit: StAuditResponse.fromJson(json["audit"]),
  );
}