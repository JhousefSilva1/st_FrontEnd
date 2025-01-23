import 'dart:convert';

import 'package:smarttolls/models/models.dart';

class StAuthRequest implements StResponseService {
  String? personEmail;
  String? personPassword;

  StAuthRequest({
    this.personEmail,
    this.personPassword,
  });

  factory StAuthRequest.createEmpty() => StAuthRequest(
    personEmail: '',
    personPassword: '',
  );

  @override
  String toJson() => json.encode(toMap());

  factory StAuthRequest.fromJson(Map<String, dynamic> json) => StAuthRequest(
    personEmail: json["personEmail"],
    personPassword: json["personPassword"],
  );

  @override
  Map<String, dynamic> toMap() => {
    "personEmail": personEmail,
    "personPassword": personPassword,
  };

  @override
  StAuthRequest fromJson(String json) {
    return fromMap(jsonDecode(json));
  }

  @override
  StAuthRequest fromMap(Map<String, dynamic> json) => StAuthRequest(
    personEmail: json["personEmail"],
    personPassword: json["personPassword"],
  );
}