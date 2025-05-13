import 'dart:convert';

import 'package:smarttolls/api/api.dart';
import 'package:smarttolls/models/models.dart';

class StPersonResponse implements StResponseService{
  int IdPerson;
  String? personName;
  String? personSurname;
  DateTime? personBirthdate;
  String? personWhatsappNumber;
  String? personEmail;
  String? personPassword;
  String? personDni; 
  String? personAddress;
  int? personAge;
  StGenderResponse gender;
  StPersonTypeResponse personType;
  StCityResponse city;
  StAuditResponse audit;

  StPersonResponse({
    required this.IdPerson,
    this.personName,
    this.personSurname,
    this.personBirthdate,
    this.personWhatsappNumber,
    this.personEmail,
    this.personPassword,
    this.personDni, 
    this.personAddress,
    this.personAge,
    required this.gender,
    required this.personType,
    required this.city,
    required this.audit,
  });

  factory StPersonResponse.createEmpty() => StPersonResponse(
        IdPerson: 0,
        personName: '',
        personSurname: '',
        personBirthdate: DateTime.now(),
        personWhatsappNumber: '',
        personEmail: '',
        personPassword: '',
        personDni: '', 
        personAddress: '',
        personAge: 0,
        gender: StGenderResponse.createEmpty(),
        personType: StPersonTypeResponse.createEmpty(),
        city: StCityResponse.createEmpty(),
        audit: StAuditResponse.createEmpty(),
      );
  @override
  String toJson() => json.encode(toMap());

  factory StPersonResponse.fromJson(Map<String, dynamic> json) => StPersonResponse(
        IdPerson: json["idPerson"],
        personName: json["personName"],
        personSurname: json["personSurname"],
        personBirthdate: DateTime.parse(json["personBirthdate"]),
        personWhatsappNumber: json["personWhatsappNumber"],
        personEmail: json["personEmail"],
        personPassword: json["personPassword"],
        personDni: json["personDni"], 
        personAddress: json["personAddress"],
        personAge: json["personAge"],
        gender: StGenderResponse.fromJson(json["gener"]),
        personType: StPersonTypeResponse.fromJson(json["personType"]),
        city: StCityResponse.fromJson(json["city"]),
        audit: StAuditResponse.fromJson(json["audit"]),
      );
      
      @override
  Map<String, dynamic> toMap() => {
        "idPerson": IdPerson,
        "personName": personName,
        "personSurname": personSurname,
        "personBirthdate": personBirthdate?.toIso8601String(),
        "personWhatsappNumber": personWhatsappNumber,
        "personEmail": personEmail,
        "personPassword": personPassword,
        "personDni": personDni, 
        "personAddress": personAddress,
        "personAge": personAge,
        "gender": gender.toJson(),
        "personType": personType.toJson(),
        "city": city.toJson(),
        "audit": audit.toJson(),
  };
  
  @override
  StPersonResponse fromJson(String json) {
    return fromMap(jsonDecode(json));
  }

  @override
  StPersonResponse fromMap(Map<String, dynamic> json) => StPersonResponse(
        IdPerson: json["idPerson"],
        personName: json["personName"],
        personSurname: json["personSurname"],
        personBirthdate: DateTime.parse(json["personBirthdate"]),
        personWhatsappNumber: json["personWhatsappNumber"],
        personEmail: json["personEmail"],
        personPassword: json["personPassword"],
        personDni: json["personDni"], 
        personAddress: json["personAddress"],
        personAge: json["personAge"],
        gender: StGenderResponse.fromJson(json["gender"]),
        personType: StPersonTypeResponse.fromJson(json["personType"]),
        city: StCityResponse.fromJson(json["city"]),
        audit: StAuditResponse.fromJson(json["audit"]),
      );

}