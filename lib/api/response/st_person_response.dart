import 'package:smarttolls/models/models.dart';
import 'package:smarttolls/api/api.dart';
import 'dart:convert';

class StPersonResponse implements StResponseService {
  int idPerson;
  String? personName;
  String? personSurname;
  String? personWhatsappNumber;
  String? personPassword;
  String? personDni;
  String? personBirthdate;
  String? personEmail;
  String? personAddress;
  String? personAge;
  int personStatus;
  StGenderResponse gender;
  StPersonTypeResponse personType;
  StCityResponse city;
  StCountryResponse country;

  StPersonResponse({
    required this.idPerson,
    this.personName,
    this.personSurname,
    this.personWhatsappNumber,
    this.personPassword,
    this.personDni,
    this.personBirthdate,
    this.personEmail,
    this.personAddress,
    this.personAge,
    required this.personStatus,
    required this.gender,
    required this.personType,
    required this.city,
    required this.country,
  });

  factory StPersonResponse.createEmpty() => StPersonResponse(
        idPerson: 0,
        personName: '',
        personSurname: '',
        personWhatsappNumber: '',
        personPassword: '',
        personDni: '',
        personBirthdate: '',
        personEmail: '',
        personAddress: '',
        personAge: '',
        personStatus: 0,
        gender: StGenderResponse.createEmpty(),
        personType: StPersonTypeResponse.createEmpty(),
        city: StCityResponse.createEmpty(),
        country: StCountryResponse.createEmpty(),
      );

  @override
  String toJson() => json.encode(toMap());

factory StPersonResponse.fromJson(Map<String, dynamic> json) => StPersonResponse(
      idPerson: json["idPerson"] as int? ?? 0,
      personName: json["personName"] as String?,
      personSurname: json["personSurname"] as String?,
      personWhatsappNumber: json["personWhatsappNumber"] as String?,
      personPassword: json["personPassword"] as String?,
      personDni: json["personDni"] as String?,
      personBirthdate: json["personBirthdate"] as String?,
      personEmail: json["personEmail"] as String?,
      personAddress: json["personAddress"] as String?,
      personAge: json["personAge"] as String?,
      personStatus: json["personStatus"] as int? ?? 0,
      gender: json["gender"] != null 
          ? StGenderResponse.fromJson(json["gender"] as Map<String, dynamic>) 
          : StGenderResponse.createEmpty(),
      personType: json["personType"] != null
          ? StPersonTypeResponse.fromJson(json["personType"] as Map<String, dynamic>)
          : StPersonTypeResponse.createEmpty(),
      city: json["city"] != null
          ? StCityResponse.fromJson(json["city"] as Map<String, dynamic>)
          : StCityResponse.createEmpty(),
  country: json["country"] != null
      ? StCountryResponse.fromJson(json["country"] as Map<String, dynamic>)
      : StCountryResponse.createEmpty(),
    );

  @override
  Map<String, dynamic> toMap() => {
        "idPerson": idPerson,
        "personName": personName,
        "personSurname": personSurname,
        "personWhatsappNumber": personWhatsappNumber,
        "personPassword": personPassword,
        "personDni": personDni,
        "personBirthdate": personBirthdate,
        "personEmail": personEmail,
        "personAddress": personAddress,
        "personAge": personAge,
        "personStatus": personStatus,
        "gender": gender.toJson(),
        "personType": personType.toJson(),
        "city": city.toJson(),
        "country": country.toJson(),
      };

  @override
  StPersonResponse fromJson(String json) {
    return fromMap(jsonDecode(json));
  }

  @override
@override
StPersonResponse fromMap(Map<String, dynamic> json) => StPersonResponse(
      idPerson: json["idPerson"] as int? ?? 0,
      personName: json["personName"] as String?,
      personSurname: json["personSurname"] as String?,
      personWhatsappNumber: json["personWhatsappNumber"] as String?,
      personPassword: json["personPassword"] as String?,
      personDni: json["personDni"] as String?,
      personBirthdate: json["personBirthdate"] as String?,
      personEmail: json["personEmail"] as String?,
      personAddress: json["personAddress"] as String?,
      personAge: json["personAge"] as String?,
      personStatus: json["personStatus"] as int? ?? 0,
      gender: json["gender"] != null 
          ? StGenderResponse.fromJson(json["gender"] as Map<String, dynamic>) 
          : StGenderResponse.createEmpty(),
      personType: json["personType"] != null
          ? StPersonTypeResponse.fromJson(json["personType"] as Map<String, dynamic>)
          : StPersonTypeResponse.createEmpty(),
      city: json["city"] != null
          ? StCityResponse.fromJson(json["city"] as Map<String, dynamic>)
          : StCityResponse.createEmpty(),
      country: json["country"] != null
          ? StCountryResponse.fromJson(json["country"] as Map<String, dynamic>)
          : StCountryResponse.createEmpty(),
    );
}