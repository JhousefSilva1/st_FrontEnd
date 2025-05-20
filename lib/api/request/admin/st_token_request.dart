import 'dart:convert';

import 'package:smarttolls/models/models.dart';

class StTokenRequest implements StResponseService {
  String? accessToken;  // Cambiar para coincidir con el backend
  String? refreshToken; // Cambiar para coincidir con el backend

  StTokenRequest({
    this.accessToken,
    this.refreshToken,
  });

  factory StTokenRequest.createEmpty() => StTokenRequest(
    accessToken: '',
    refreshToken: '',
  );

  @override
  String toJson() => json.encode(toMap());

  factory StTokenRequest.fromJson(Map<String, dynamic> json) => StTokenRequest(
    accessToken: json["accessToken"] ?? json["access_token"], // Compatibilidad con ambos formatos
    refreshToken: json["refreshToken"] ?? json["refresh_token"], // Compatibilidad con ambos formatos
  );

  @override
  Map<String, dynamic> toMap() => {
    "accessToken": accessToken, // Usar el mismo nombre que el backend
    "refreshToken": refreshToken, // Usar el mismo nombre que el backend
  };

  @override
  StTokenRequest fromJson(String json) {
    return fromMap(jsonDecode(json));
  }

  @override
  StTokenRequest fromMap(Map<String, dynamic> json) => StTokenRequest(
    accessToken: json["accessToken"] ?? json["access_token"],
    refreshToken: json["refreshToken"] ?? json["refresh_token"],
  );
}