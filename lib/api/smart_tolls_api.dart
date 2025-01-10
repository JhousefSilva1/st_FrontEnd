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


  Future<StResponse/*<StVehicleResponse>*/> getAllVehicles() async{
    try {
      final response = await httpGet('$_baseUrl/vehicles', getHeaders());
      if (response.statusCode >= HttpStatus.badRequest) {
        if (response.statusCode == HttpStatus.networkConnectTimeoutError) {
          StResponse<StVehicleResponse> responseData = StResponse(status: HttpStatus.networkConnectTimeoutError);
          return responseData;
        }
        return StResponse.createEmpty();
      }
      StResponse/*<StVehicleResponse>*/ responseData = StResponse.fromJsonList(utf8.decode(response.bodyBytes), StVehicleResponse.createEmpty());
      // if(jsonDecode(utf8.decode(response.bodyBytes))['data'] != null){
      //   List<StVehicleResponse> vehicles = jsonDecode(utf8.decode(response.bodyBytes))['data'];
      //   List<StVehicleResponse> vehiclesList = vehicles.map((vehicle) => StVehicleResponse.fromJson(vehicle.toMap())).toList();
      //   responseData.data = vehiclesList;
      // }

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
}