import 'dart:convert';
import 'package:smarttolls/api/api.dart';
import 'package:smarttolls/models/st_response.dart';

class StTollsResponse implements StResponseService {
  int idTolls;
  String? tollsName;
  int tollsStatus;
  StPlaceResponse places;
  StAuditResponse audit;

  StTollsResponse({
    required this.idTolls,
    this.tollsName,
    required this.tollsStatus,
    required this.places,
    required this.audit,
  });

  factory StTollsResponse.createEmpty() => StTollsResponse(
        idTolls: 0,
        tollsName: '',
        tollsStatus: 0,
        places: StPlaceResponse.createEmpty(),
        audit: StAuditResponse.createEmpty(),
      );

  @override
  String toJson() => json.encode(toMap());

  factory StTollsResponse.fromJson(Map<String, dynamic> json) => StTollsResponse(
        idTolls: json["idTolls"],
        tollsName: json["tollsName"],
        tollsStatus: json["tollsStatus"],
        places: StPlaceResponse.fromJson(json["places"]),
        audit: StAuditResponse.fromJson(json["audit"]),
      );

  @override
  Map<String, dynamic> toMap() => {
        "idTolls": idTolls,
        "tollsName": tollsName,
        "tollsStatus": tollsStatus,
        "places": places.toJson(),
        "audit": audit.toJson(),
      };

  @override
  StTollsResponse fromJson(String json) {
    return fromMap(jsonDecode(json));
  }

  @override
  StTollsResponse fromMap(Map<String, dynamic> json) => StTollsResponse(
        idTolls: json["idTolls"],
        tollsName: json["tollsName"],
        tollsStatus: json["tollsStatus"],
        places: StPlaceResponse.fromJson(json["places"]),
        audit: StAuditResponse.fromJson(json["audit"]),
      );
}