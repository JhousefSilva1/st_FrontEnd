import 'dart:convert';

import 'package:smarttolls/models/models.dart';

class StTokenRequest implements StResponseService {
  String? accessToken;
  String? refreshToken;

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
    accessToken: json["access_token"],
    refreshToken: json["refresh_token"],
  );

  @override
  Map<String, dynamic> toMap() => {
    "access_token": accessToken,
    "refresh_token": refreshToken,
  };

  @override
  StTokenRequest fromJson(String json) {
    return fromMap(jsonDecode(json));
  }

  @override
  StTokenRequest fromMap(Map<String, dynamic> json) => StTokenRequest(
    accessToken: json["access_token"],
    refreshToken: json["refresh_token"],
  );
}