import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

import 'package:smarttolls/api/api.dart';
import 'package:smarttolls/config/enviroment.dart';
import 'package:smarttolls/models/models.dart';

class SmartTollsApi {
  static const int authorizationForbidden = 403;
  static const int authorizationUnauthorized = 401;

  static final String _baseUrl = Enviroment.apiSmartTollsURL;
  static final String _baseAuthUrl = Enviroment.apiSmartTollsAuthURL;

  Future<StResponse> autenticateUser(StAuthRequest authRequest) async {
    try {
      final response = await httpPost('$_baseAuthUrl/login', getHeaders(), authRequest.toJson());
      if (response.statusCode >= HttpStatus.badRequest) {
        if (response.statusCode == HttpStatus.networkConnectTimeoutError) {
          StResponse<StVehicleResponse> responseData = StResponse(status: HttpStatus.networkConnectTimeoutError);
          return responseData;
        }
        return StResponse.createEmpty();
      }
      StResponse<StTokenRequest> responseData = StResponse.fromJsonT(response.body, StTokenRequest.createEmpty());
      return responseData;
    } catch (e) {
      return StResponse.createEmpty();
    }
  }

  Future<StResponse<StVehicleResponse>> createVehicle(StVehicleResponse authRequest) async {
    try {
      final response = await httpPost('$_baseAuthUrl/login', getHeaders(), authRequest.toJson());
      if (response.statusCode >= HttpStatus.badRequest) {
        if (response.statusCode == HttpStatus.networkConnectTimeoutError) {
          StResponse<StVehicleResponse> responseData = StResponse(status: HttpStatus.networkConnectTimeoutError);
          return responseData;
        }
        return StResponse.createEmpty();
      }
      StResponse<StVehicleResponse> responseData = StResponse.fromJsonT(response.body, StVehicleResponse.createEmpty());
      return responseData;
    } catch (e) {
      return StResponse.createEmpty();
    }
  }

  Future<StResponse<StBrandResponse>> getAllBrands() async{
    try {
      final response = await httpGet('$_baseUrl/brands', getHeaders());
      if (response.statusCode >= HttpStatus.badRequest) {
        if (response.statusCode == HttpStatus.networkConnectTimeoutError) {
          StResponse<StBrandResponse> responseData = StResponse(status: HttpStatus.networkConnectTimeoutError);
          return responseData;
        }
        return StResponse.createEmpty();
      }
      StResponse<StBrandResponse> responseData = StResponse.fromJsonList(utf8.decode(response.bodyBytes), StBrandResponse.createEmpty());
      return responseData;
    } catch (e) {
      return StResponse.createEmpty();
    }
  }

  Future<StResponse<StVehiclesColorsResponse>> getAllColors() async{
    try {
      final response = await httpGet('$_baseUrl/colors', getHeaders());
      if (response.statusCode >= HttpStatus.badRequest) {
        if (response.statusCode == HttpStatus.networkConnectTimeoutError) {
          StResponse<StVehiclesColorsResponse> responseData = StResponse(status: HttpStatus.networkConnectTimeoutError);
          return responseData;
        }
        return StResponse.createEmpty();
      }
      StResponse<StVehiclesColorsResponse> responseData = StResponse.fromJsonList(utf8.decode(response.bodyBytes), StVehiclesColorsResponse.createEmpty());
      return responseData;
    } catch (e) {
      return StResponse.createEmpty();
    }
  }

  Future<StResponse<StFuelTypesResponse>> getAllFuelTypes() async{
    try {
      final response = await httpGet('$_baseUrl/fuel/types', getHeaders());
      if (response.statusCode >= HttpStatus.badRequest) {
        if (response.statusCode == HttpStatus.networkConnectTimeoutError) {
          StResponse<StFuelTypesResponse> responseData = StResponse(status: HttpStatus.networkConnectTimeoutError);
          return responseData;
        }
        return StResponse.createEmpty();
      }
      StResponse<StFuelTypesResponse> responseData = StResponse.fromJsonList(utf8.decode(response.bodyBytes), StFuelTypesResponse.createEmpty());
      return responseData;
    } catch (e) {
      return StResponse.createEmpty();
    }
  }

  Future<StResponse<StVehiclesModelsResponse>> getAllModels() async{
    try {
      final response = await httpGet('$_baseUrl/models', getHeaders());
      if (response.statusCode >= HttpStatus.badRequest) {
        if (response.statusCode == HttpStatus.networkConnectTimeoutError) {
          StResponse<StVehiclesModelsResponse> responseData = StResponse(status: HttpStatus.networkConnectTimeoutError);
          return responseData;
        }
        return StResponse.createEmpty();
      }
      StResponse<StVehiclesModelsResponse> responseData = StResponse.fromJsonList(utf8.decode(response.bodyBytes), StVehiclesModelsResponse.createEmpty());
      return responseData;
    } catch (e) {
      return StResponse.createEmpty();
    }
  }

  Future<StResponse<StVehiclesModelsResponse>> getAllModelsByBrand(StBrandResponse request) async{
    try {
      final response = await httpGet('$_baseUrl/models/byBrand/${request.idBrand}', getHeaders());
      if (response.statusCode >= HttpStatus.badRequest) {
        if (response.statusCode == HttpStatus.networkConnectTimeoutError) {
          StResponse<StVehiclesModelsResponse> responseData = StResponse(status: HttpStatus.networkConnectTimeoutError);
          return responseData;
        }
        return StResponse.createEmpty();
      }
      StResponse<StVehiclesModelsResponse> responseData = StResponse.fromJsonList(utf8.decode(response.bodyBytes), StVehiclesModelsResponse.createEmpty());
      return responseData;
    } catch (e) {
      return StResponse.createEmpty();
    }
  }
  
  Future<StResponse<StVehiclesTypeResponse>> getAllTypeVehicles() async{
    try {
      final response = await httpGet('$_baseUrl/vehicleType', getHeaders());
      if (response.statusCode >= HttpStatus.badRequest) {
        if (response.statusCode == HttpStatus.networkConnectTimeoutError) {
          StResponse<StVehiclesTypeResponse> responseData = StResponse(status: HttpStatus.networkConnectTimeoutError);
          return responseData;
        }
        return StResponse.createEmpty();
      }
      StResponse<StVehiclesTypeResponse> responseData = StResponse.fromJsonList(utf8.decode(response.bodyBytes), StVehiclesTypeResponse.createEmpty());
      return responseData;
    } catch (e) {
      return StResponse.createEmpty();
    }
  }

  Future<StResponse<StVehicleResponse>> getAllVehicles() async{
    try {
      final response = await httpGet('$_baseUrl/vehicles', getHeaders());
      if (response.statusCode >= HttpStatus.badRequest) {
        if (response.statusCode == HttpStatus.networkConnectTimeoutError) {
          StResponse<StVehicleResponse> responseData = StResponse(status: HttpStatus.networkConnectTimeoutError);
          return responseData;
        }
        return StResponse.createEmpty();
      }
      StResponse<StVehicleResponse> responseData = StResponse.fromJsonList(utf8.decode(response.bodyBytes), StVehicleResponse.createEmpty());
      return responseData;
    } catch (e) {
      return StResponse.createEmpty();
    }
  }

  Future<http.Response> httpGet(String baseUrl, dynamic header) async {
    try {
      var httpResponse = await http.get(Uri.parse(baseUrl), headers: header);
      if (httpResponse.statusCode != HttpStatus.ok) {
        final error = StResponse.fromJson(httpResponse.body);
        if (error.status == authorizationForbidden || error.status == authorizationUnauthorized) {
          // httpResponse = await reloginMethodGet(baseUrl, header, httpResponse);
        }
      }
      return httpResponse;
    } catch (e) {
      if (e.toString().contains('errno = 7') || e.toString().contains('Software caused connection abort')) {
        return http.Response("{}", HttpStatus.networkConnectTimeoutError);
      }
    }
    return http.Response("{}", HttpStatus.conflict);
  }

  Future<http.Response> httpPost(String baseUrl, dynamic header, String jsonRequest) async {
    try {
      var httpResponse = await http.post(
        Uri.parse(baseUrl),
        headers: header,
        body: jsonRequest,
        encoding: Encoding.getByName("utf-8")
      ).timeout(const Duration(seconds: 120));
      if (httpResponse.statusCode != HttpStatus.ok) {
        final error = StResponse.fromJson(httpResponse.body);

        if (error.status == authorizationForbidden || error.status == authorizationUnauthorized) {
          // httpResponse = await reloginMethodPost(baseUrl, header, httpResponse, jsonRequest);
        }
      }
      return httpResponse;
    } catch (e) {
      if (e.toString().contains('errno = 7') || e.toString().contains('Software caused connection abort'))
        return http.Response("{}", HttpStatus.networkConnectTimeoutError);
    }
    return http.Response("{}", HttpStatus.conflict);
  }


  getHeaders() {
    return {
      'Content-Type': 'application/json; charset=UTF-8',
    };
  }

  getHeadersByToken(String token) {
    return {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token'
    };
  }

  Map<String, dynamic> parseJwt(String token) {
    final parts = token.split('.');
    if (parts.length != 3) {
      throw Exception('invalid token');
    }

    final payload = _decodeBase64(parts[1]);
    final payloadMap = json.decode(payload);
    if (payloadMap is! Map<String, dynamic>) {
      throw Exception('invalid payload');
    }

    return payloadMap;
  }

  String _decodeBase64(String str) {
    String output = str.replaceAll('-', '+').replaceAll('_', '/');

    switch (output.length % 4) {
      case 0:
        break;
      case 2:
        output += '==';
        break;
      case 3:
        output += '=';
        break;
      default:
        throw Exception('Illegal base64url string!"');
    }

    return utf8.decode(base64Url.decode(output));
  }
}