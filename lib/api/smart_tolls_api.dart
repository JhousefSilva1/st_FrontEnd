import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';

import 'package:http/http.dart' as http;

import 'package:smarttolls/api/api.dart';
import 'package:smarttolls/api/request/admin/st_vehicles_request.dart';
import 'package:smarttolls/api/request/customer/signup_request.dart';
import 'package:smarttolls/api/request/operador/tolls/transaction_request.dart';
import 'package:smarttolls/config/enviroment.dart';
import 'package:smarttolls/config/preferences.dart';
import 'package:smarttolls/models/models.dart';

import 'response/customer/st_wallet_response.dart';
import 'response/operador/tolls/transaction_response.dart';

class SmartTollsApi {
  static const int authorizationForbidden = 403;
  static const int authorizationUnauthorized = 401;

  static final String _baseUrl = Enviroment.apiSmartTollsURL;
  static final String _baseAuthUrl = Enviroment.apiSmartTollsAuthURL;

Future<StResponse<StTokenRequest>> autenticateUser(StAuthRequest authRequest) async {
  try {
    final response = await httpPost('$_baseAuthUrl/login', getHeaders(), authRequest.toJson());
    
    if (response.statusCode >= HttpStatus.badRequest) {
      if (response.statusCode == HttpStatus.networkConnectTimeoutError) {
        return StResponse<StTokenRequest>(status: HttpStatus.networkConnectTimeoutError);
      }
      
      try {
        final errorJson = json.decode(response.body);
        return StResponse<StTokenRequest>(
          status: response.statusCode,
          message: errorJson['message'] ?? 'Error desconocido',
          error: errorJson['error'] ?? '',
        );
      } catch (e) {
        return StResponse<StTokenRequest>.createEmpty();
      }
    }

    final responseJson = json.decode(response.body);
    
    // Manejar el caso cuando la respuesta no tiene el formato esperado
    if (responseJson['data'] == null) {
      return StResponse<StTokenRequest>(
        status: response.statusCode,
        message: 'Respuesta del servidor no contiene datos',
        error: 'Formato de respuesta inválido',
      );
    }

    // Crear la respuesta con los tokens
    final tokenData = StTokenRequest.createEmpty().fromMap(responseJson['data']);
    
    return StResponse<StTokenRequest>(
      data: tokenData,
      status: responseJson['status'] ?? response.statusCode,
      message: responseJson['message'],
      error: responseJson['error'] ?? '',
    );
  } catch (e) {
    return StResponse<StTokenRequest>(
      status: HttpStatus.internalServerError,
      message: 'Error durante la autenticación',
      error: e.toString(),
    );
  }
}
// VEHICLES 
// -BRANDS
  // create brand
      Future<StResponse<StBrandResponse>> createBrands(StBrandRequest brandRequest) async {
      try {
        final response = await httpPost('$_baseUrl/brands/create',getHeaders(),jsonEncode(brandRequest.toJson()),
        );
        if (response.statusCode >= HttpStatus.badRequest) {
          if (response.statusCode == HttpStatus.networkConnectTimeoutError) {
            return StResponse<StBrandResponse>(status: HttpStatus.networkConnectTimeoutError);
          }
          try {
            final errorJson = json.decode(response.body);
            return StResponse<StBrandResponse>(
              status: response.statusCode,
              message: errorJson['message'] ?? 'Error al crear la marca',
              error: errorJson['error'] ?? '',
            );
          } catch (e) {
            return StResponse<StBrandResponse>.createEmpty();
          }
        }
        final responseJson = json.decode(response.body);
        final brandData = StBrandResponse.createEmpty().fromMap(responseJson['data']);
        return StResponse<StBrandResponse>(
          data: brandData,
          status: response.statusCode,
          message: responseJson['message'],
        );
      } catch (e) {
        return StResponse<StBrandResponse>(
          status: HttpStatus.internalServerError,
          message: 'Error durante la creación de la marca',
          error: e.toString(),
        );
      }
    }
    // getAllBrands
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
// - MODELS
      // create model by brandId
      Future<StResponse<StVehiclesModelsResponse>> createModelByBrand(StVehiclesModelsRequest modelsRequest) async {
        try {
          final response = await httpPost('$_baseUrl/models/create', getHeaders(), jsonEncode(modelsRequest.toJson()));
          if (response.statusCode >= HttpStatus.badRequest) {
            if (response.statusCode == HttpStatus.networkConnectTimeoutError) {
              return StResponse<StVehiclesModelsResponse>(status: HttpStatus.networkConnectTimeoutError);
            }
            try {
              final errorJson = json.decode(response.body);
              return StResponse<StVehiclesModelsResponse>(
                status: response.statusCode,
                message: errorJson['message'] ?? 'Error al crear el modelo',
                error: errorJson['error'] ?? '',
              );
            } catch (e) {
              return StResponse<StVehiclesModelsResponse>.createEmpty();
            }
          }
          final responseJson = json.decode(response.body);
          final modelData = StVehiclesModelsResponse.createEmpty().fromMap(responseJson['data']);
          return StResponse<StVehiclesModelsResponse>(
            data: modelData,
            status: response.statusCode,
            message: responseJson['message'],
          );
        } catch (e) {
          return StResponse<StVehiclesModelsResponse>(
            status: HttpStatus.internalServerError,
            message: 'Error durante la creación del modelo',
            error: e.toString(),
          );
        }
      }
      // get all models
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

      // get models by brandId
        Future<StResponse<StVehiclesModelsResponse>> getModelsByBrand(int idBrand) async{
          try{
            final response = await httpGet('$_baseUrl/models/byBrand/$idBrand', getHeaders());
            if (response.statusCode >= HttpStatus.badRequest) {
              if (response.statusCode == HttpStatus.networkConnectTimeoutError) {
                StResponse<StVehiclesModelsResponse> responseData = StResponse(status: HttpStatus.networkConnectTimeoutError);
                return responseData;
              }
              return StResponse.createEmpty();
            }
            StResponse<StVehiclesModelsResponse> responseData = StResponse.fromJsonList(utf8.decode(response.bodyBytes), StVehiclesModelsResponse.createEmpty());
            return responseData;
          }catch(e){
            return StResponse.createEmpty();
          }
        }   
// - COLORS
      // create color
        Future<StResponse<StVehiclesColorsResponse>>createColor(StColorRequest colorRequest) async {
          try{
            final response = await httpPost('$_baseUrl/colors/create', getHeaders(), jsonEncode(colorRequest.toJson()));
            if (response.statusCode >= HttpStatus.badRequest) {
              if (response.statusCode == HttpStatus.networkConnectTimeoutError) {
                return StResponse<StVehiclesColorsResponse>(status: HttpStatus.networkConnectTimeoutError);
              }
              try {
                final errorJson = json.decode(response.body);
                return StResponse<StVehiclesColorsResponse>(
                  status: response.statusCode,
                  message: errorJson['message'] ?? 'Error al crear el color',
                  error: errorJson['error'] ?? '',
                );
              } catch (e) {
                return StResponse<StVehiclesColorsResponse>.createEmpty();
              }
            }
            final responseJson = json.decode(response.body);
            final colorData = StVehiclesColorsResponse.createEmpty().fromMap(responseJson['data']);
            return StResponse<StVehiclesColorsResponse>(
              data: colorData,
              status: response.statusCode,
              message: responseJson['message'],
            );
          } catch (e) {
            return StResponse<StVehiclesColorsResponse>(
              status: HttpStatus.internalServerError,
              message: 'Error durante la creación del color',
              error: e.toString(),
            );
          }
        }
      // get all colors
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
// - VEHICLE TYPES
  
        // create vehicle type
          Future<StResponse<StVehiclesTypeResponse>> createVehicleType(StVehiclesTypeRequest vehicleTypeRequest) async {
            try {
              final response = await httpPost('$_baseUrl/vehicleType/create', getHeaders(), jsonEncode(vehicleTypeRequest.toJson()));
              if (response.statusCode >= HttpStatus.badRequest) {
                if (response.statusCode == HttpStatus.networkConnectTimeoutError) {
                  return StResponse<StVehiclesTypeResponse>(status: HttpStatus.networkConnectTimeoutError);
                }
                try {
                  final errorJson = json.decode(response.body);
                  return StResponse<StVehiclesTypeResponse>(
                    status: response.statusCode,
                    message: errorJson['message'] ?? 'Error al crear el tipo de vehículo',
                    error: errorJson['error'] ?? '',
                  );
                } catch (e) {
                  return StResponse<StVehiclesTypeResponse>.createEmpty();
                }
              }
              final responseJson = json.decode(response.body);
              final vehicleTypeData = StVehiclesTypeResponse.createEmpty().fromMap(responseJson['data']);
              return StResponse<StVehiclesTypeResponse>(
                data: vehicleTypeData,
                status: response.statusCode,
                message: responseJson['message'],
              );
            } catch (e) {
              return StResponse<StVehiclesTypeResponse>(
                status: HttpStatus.internalServerError,
                message: 'Error durante la creación del tipo de vehículo',
                error: e.toString(),
              );
            }
          }
        // get all vehicle types
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
// - FUEL TYPES
    // create fuel type
            Future<StResponse<StFuelTypesResponse>> createFuelType(StFuelTypesRequest fuelTypeRequest) async {
              try {
                final response = await httpPost('$_baseUrl/fuelTypes/create', getHeaders(), jsonEncode(fuelTypeRequest.toJson()));
                if (response.statusCode >= HttpStatus.badRequest) {
                  if (response.statusCode == HttpStatus.networkConnectTimeoutError) {
                    return StResponse<StFuelTypesResponse>(status: HttpStatus.networkConnectTimeoutError);
                  }
                  try {
                    final errorJson = json.decode(response.body);
                    return StResponse<StFuelTypesResponse>(
                      status: response.statusCode,
                      message: errorJson['message'] ?? 'Error al crear el tipo de combustible',
                      error: errorJson['error'] ?? '',
                    );
                  } catch (e) {
                    return StResponse<StFuelTypesResponse>.createEmpty();
                  }
                }
                final responseJson = json.decode(response.body);
                final fuelTypeData = StFuelTypesResponse.createEmpty().fromMap(responseJson['data']);
                return StResponse<StFuelTypesResponse>(
                  data: fuelTypeData,
                  status: response.statusCode,
                  message: responseJson['message'],
                );
              } catch (e) {
                return StResponse<StFuelTypesResponse>(
                  status: HttpStatus.internalServerError,
                  message: 'Error durante la creación del tipo de combustible',
                  error: e.toString(),
                );
              }
            }
            // get fuel types
              Future<StResponse<StFuelTypesResponse>> getAllFuelTypes() async{
                try {
                  final response = await httpGet('$_baseUrl/fuelTypes', getHeaders());
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
// - VEHICLE 
    // GET ALL VEHICLES
Future<StResponse<StVehicleResponse>> getAllVehicles() async {
  try {
    final response = await httpGet('$_baseUrl/vehicles', getHeaders());
    
    if (response.statusCode >= HttpStatus.badRequest) {
      return StResponse(
        status: response.statusCode,
        message: 'Error del servidor: ${response.statusCode}',
      );
    }
    
    final responseData = jsonDecode(utf8.decode(response.bodyBytes));
    
    // Verificar si hay datos
    if (responseData['data'] == null) {
      return StResponse(
        status: responseData['status'] ?? 200,
        message: responseData['message'] ?? 'No data available',
      );
    }
    
    // Manejar tanto respuesta individual como lista
    if (responseData['data'] is Map) {
      final vehicles = StVehicleResponse.fromJson(responseData['data']);
      return StResponse(
        status: responseData['status'] ?? 200,
        message: responseData['message'] ?? 'OK',
        data: vehicles,
        dataList: [vehicles],
      );
    } else if (responseData['data'] is List) {
      final persons = (responseData['data'] as List)
          .map((item) => StVehicleResponse.fromJson(item))
          .toList();
      return StResponse(
        status: responseData['status'] ?? 200,
        message: responseData['message'] ?? 'OK',
        dataList: persons,
      );
    }
    
    return StResponse.createEmpty();
  } catch (e, stackTrace) {
    debugPrint('Error en getAllPersons: $e');
    debugPrint('Stack trace: $stackTrace');
    return StResponse(
      status: 500,
      message: 'Error de conexión: ${e.toString()}',
    );
  }
}


/// Get vehicle by personId
// En tu archivo api.dart
Future<StResponse<StVehicleResponse>> getVehiclesByPersonId(int personId) async {
  try {
    final response = await httpGet('$_baseUrl/vehicles/person/$personId', getHeaders());
    
    if (response.statusCode >= HttpStatus.badRequest) {
      return StResponse(
        status: response.statusCode,
        message: 'Error del servidor: ${response.statusCode}',
      );
    }
    
    final responseData = jsonDecode(utf8.decode(response.bodyBytes));
    
    if (responseData['data'] == null) {
      return StResponse(
        status: responseData['status'] ?? 200,
        message: responseData['message'] ?? 'No data available',
      );
    }
    
    // Manejar lista de vehículos
    if (responseData['data'] is List) {
      final vehicles = (responseData['data'] as List)
          .map((item) => StVehicleResponse.fromJson(item))
          .toList();
      return StResponse(
        status: responseData['status'] ?? 200,
        message: responseData['message'] ?? 'OK',
        dataList: vehicles,
      );
    }
    
    return StResponse.createEmpty();
  } catch (e, stackTrace) {
    debugPrint('Error en getVehiclesByPersonId: $e');
    debugPrint('Stack trace: $stackTrace');
    return StResponse(
      status: 500,
      message: 'Error de conexión: ${e.toString()}',
    );
  }
}

// create vehicle by personId
Future<StResponse<StVehicleResponse>> addVehicle(StVehiclesRequest vehicleRequest) async {
  try {
    final response = await httpPost('$_baseUrl/vehicles/create', getHeaders(), jsonEncode(vehicleRequest.toJson()));
    if (response.statusCode >= HttpStatus.badRequest) {
      if (response.statusCode == HttpStatus.networkConnectTimeoutError) {
        return StResponse<StVehicleResponse>(status: HttpStatus.networkConnectTimeoutError);
      }
      try {
        final errorJson = json.decode(response.body);
        return StResponse<StVehicleResponse>(
          status: response.statusCode,
          message: errorJson['message'] ?? 'Error al crear el vehículo',
          error: errorJson['error'] ?? '',
        );
      } catch (e) {
        return StResponse<StVehicleResponse>.createEmpty();
      }
    }
    final responseJson = json.decode(response.body);
    final vehicleData = StVehicleResponse.create().fromMap(responseJson['data']);
    return StResponse<StVehicleResponse>(
      data: vehicleData,
      status: response.statusCode,
      message: responseJson['message'],
    );
  } catch (e) {
    return StResponse<StVehicleResponse>(
      status: HttpStatus.internalServerError,
      message: 'Error durante la creación del vehículo',
      error: e.toString(),
    );
  }
}

// edit vehicle
// En SmartTollsApi
Future<StResponse<StVehicleResponse>> updateVehicle(int vehicleId, StVehiclesRequest vehicleRequest) async {
  try {
    final response = await httpPut('$_baseUrl/vehicles/update/$vehicleId', getHeaders(), jsonEncode(vehicleRequest.toJson()));
    
    if (response.statusCode >= HttpStatus.badRequest) {
      if (response.statusCode == HttpStatus.networkConnectTimeoutError) {
        return StResponse<StVehicleResponse>(status: HttpStatus.networkConnectTimeoutError);
      }
      try {
        final errorJson = json.decode(response.body);
        return StResponse<StVehicleResponse>(
          status: response.statusCode,
          message: errorJson['message'] ?? 'Error al actualizar el vehículo',
          error: errorJson['error'] ?? '',
        );
      } catch (e) {
        return StResponse<StVehicleResponse>.createEmpty();
      }
    }
    
    final responseJson = json.decode(response.body);
    final vehicleData = StVehicleResponse.create().fromMap(responseJson['data']);
    return StResponse<StVehicleResponse>(
      data: vehicleData,
      status: response.statusCode,
      message: responseJson['message'],
    );
  } catch (e) {
    return StResponse<StVehicleResponse>(
      status: HttpStatus.internalServerError,
      message: 'Error durante la actualización del vehículo',
      error: e.toString(),
    );
  }
}
// wallet

Future<StResponse<StWalletResponse>> getWalletByVehicleId(int vehicleId) async {
  try {
    final response = await httpGet('$_baseUrl/vehicles/$vehicleId/wallet', getHeaders());
    
    if (response.statusCode >= HttpStatus.badRequest) {
      return StResponse(
        status: response.statusCode,
        message: 'Error del servidor: ${response.statusCode}',
      );
    }
    
    final responseData = jsonDecode(utf8.decode(response.bodyBytes));
    
    if (responseData['data'] == null) {
      return StResponse(
        status: responseData['status'] ?? 200,
        message: responseData['message'] ?? 'No wallet data available',
      );
    }
    
    final wallet = StWalletResponse.fromJson(responseData['data']);
    return StResponse(
      data: wallet,
      status: responseData['status'] ?? 200,
      message: responseData['message'] ?? 'OK',
    );
  } catch (e, stackTrace) {
    debugPrint('Error in getWalletByVehicleId: $e');
    debugPrint('Stack trace: $stackTrace');
    return StResponse(
      status: 500,
      message: 'Error de conexión: ${e.toString()}',
    );
  }
}

/// Update wallet balance
Future<StResponse<StWalletResponse>> updateWalletBalance(
  int walletId, 
  double amount
) async {
  try {
    final response = await httpPut(
      '$_baseUrl/wallets/$walletId/balance',
      getHeaders(),
      jsonEncode({'amount': amount}), // Cambiado a 'amount' en lugar de 'balance'
    );
    
    if (response.statusCode >= HttpStatus.badRequest) {
      return StResponse(
        status: response.statusCode,
        message: 'Error del servidor: ${response.statusCode}',
      );
    }
    
    final responseData = jsonDecode(utf8.decode(response.bodyBytes));
    
    if (responseData['data'] == null) {
      return StResponse(
        status: responseData['status'] ?? 200,
        message: responseData['message'] ?? 'No wallet data available',
      );
    }
    
    final wallet = StWalletResponse.fromJson(responseData['data']);
    return StResponse(
      data: wallet,
      status: responseData['status'] ?? 200,
      message: responseData['message'] ?? 'Balance actualizado exitosamente',
    );
  } catch (e, stackTrace) {
    debugPrint('Error in updateWalletBalance: $e');
    debugPrint('Stack trace: $stackTrace');
    return StResponse(
      status: 500,
      message: 'Error de conexión: ${e.toString()}',
    );
  }
}
// COUNTRY AND CITY MS

// create Country
  Future<StResponse<StCountryResponse>> createCountry(StCountryRequest countryRequest) async {
    try {
      final response = await httpPost('$_baseUrl/country/create', getHeaders(), jsonEncode(countryRequest.toJson()));
      if (response.statusCode >= HttpStatus.badRequest) {
        if (response.statusCode == HttpStatus.networkConnectTimeoutError) {
          return StResponse<StCountryResponse>(status: HttpStatus.networkConnectTimeoutError);
        }
        try {
          final errorJson = json.decode(response.body);
          return StResponse<StCountryResponse>(
            status: response.statusCode,
            message: errorJson['message'] ?? 'Error al crear el país',
            error: errorJson['error'] ?? '',
          );
        } catch (e) {
          return StResponse<StCountryResponse>.createEmpty();
        }
      }
      final responseJson = json.decode(response.body);
      final countryData = StCountryResponse.createEmpty().fromMap(responseJson['data']);
      return StResponse<StCountryResponse>(
        data: countryData,
        status: response.statusCode,
        message: responseJson['message'],
      );
    } catch (e) {
      return StResponse<StCountryResponse>(
        status: HttpStatus.internalServerError,
        message: 'Error durante la creación del país',
        error: e.toString(),
      );
    }
  }
// getAllCountries
  Future<StResponse<StCountryResponse>> getAllCountries() async {
    try {
      final response = await httpGet('$_baseUrl/country', getHeaders());
      if (response.statusCode >= HttpStatus.badRequest) {
        if (response.statusCode == HttpStatus.networkConnectTimeoutError) {
          StResponse<StCountryResponse> responseData = StResponse(status: HttpStatus.networkConnectTimeoutError);
          return responseData;
        }
        return StResponse.createEmpty();
      }
      StResponse<StCountryResponse> responseData = StResponse.fromJsonList(utf8.decode(response.bodyBytes), StCountryResponse.createEmpty());
      return responseData;
    } catch (e) {
      return StResponse.createEmpty();
    }
  } 


// create city
Future<StResponse<StCityResponse>> createCity(StCityRequest cityRequest) async {
  try {
    final response = await httpPost('$_baseUrl/city/create', getHeaders(), jsonEncode(cityRequest.toJson()));
    if (response.statusCode >= HttpStatus.badRequest) {
      if (response.statusCode == HttpStatus.networkConnectTimeoutError) {
        return StResponse<StCityResponse>(status: HttpStatus.networkConnectTimeoutError);
      }
      try {
        final errorJson = json.decode(response.body);
        return StResponse<StCityResponse>(
          status: response.statusCode,
          message: errorJson['message'] ?? 'Error al crear la ciudad',
          error: errorJson['error'] ?? '',
        );
      } catch (e) {
        return StResponse<StCityResponse>.createEmpty();
      }
    }
    final responseJson = json.decode(response.body);
    final cityData = StCityResponse.createEmpty().fromMap(responseJson['data']);
    return StResponse<StCityResponse>(
      data: cityData,
      status: response.statusCode,
      message: responseJson['message'],
    );
  } catch (e) {
    return StResponse<StCityResponse>(
      status: HttpStatus.internalServerError,
      message: 'Error durante la creación de la ciudad',
      error: e.toString(),
    );
  }
}
// get city by countryId
Future<StResponse<StCityResponse>> getCitiesByCountry(int idCountry) async {
  try {
    final response = await httpGet('$_baseUrl/city/country/$idCountry', getHeaders());
    if (response.statusCode >= HttpStatus.badRequest) {
      if (response.statusCode == HttpStatus.networkConnectTimeoutError) {
        StResponse<StCityResponse> responseData = StResponse(status: HttpStatus.networkConnectTimeoutError);
        return responseData;
      }
      return StResponse.createEmpty();
    }
    StResponse<StCityResponse> responseData = StResponse.fromJsonList(utf8.decode(response.bodyBytes), StCityResponse.createEmpty());
    return responseData;
  } catch (e) {
    return StResponse.createEmpty();
  }
}
// create a toll
Future<StResponse<StTollsResponse>> createToll(StTollsRequest tollsRequest) async {
  try {
    final response = await httpPost('$_baseUrl/toll/create', getHeaders(), jsonEncode(tollsRequest.toJson()));
    if (response.statusCode >= HttpStatus.badRequest) {
      if (response.statusCode == HttpStatus.networkConnectTimeoutError) {
        return StResponse<StTollsResponse>(status: HttpStatus.networkConnectTimeoutError);
      }
      try {
        final errorJson = json.decode(response.body);
        return StResponse<StTollsResponse>(
          status: response.statusCode,
          message: errorJson['message'] ?? 'Error al crear el peaje',
          error: errorJson['error'] ?? '',
        );
      } catch (e) {
        return StResponse<StTollsResponse>.createEmpty();
      }
    }
    final responseJson = json.decode(response.body);
    final tollData = StTollsResponse.createEmpty().fromMap(responseJson['data']);
    return StResponse<StTollsResponse>(
      data: tollData,
      status: response.statusCode,
      message: responseJson['message'],
    );
  } catch (e) {
    return StResponse<StTollsResponse>(
      status: HttpStatus.internalServerError,
      message: 'Error durante la creación del peaje',
      error: e.toString(),
    );
  }
}
// getAllTolls
Future<StResponse<StTollsResponse>> getAllTolls() async {
  try {
    final response = await httpGet('$_baseUrl/toll', getHeaders());
    if (response.statusCode >= HttpStatus.badRequest) {
      if (response.statusCode == HttpStatus.networkConnectTimeoutError) {
        StResponse<StTollsResponse> responseData = StResponse(status: HttpStatus.networkConnectTimeoutError);
        return responseData;
      }
      return StResponse.createEmpty();
    }
    StResponse<StTollsResponse> responseData = StResponse.fromJsonList(utf8.decode(response.bodyBytes), StTollsResponse.createEmpty());
    return responseData;
  } catch (e) {
    return StResponse.createEmpty();
  }
}


// Create place
Future<StResponse<StPlaceResponse>> createPlace(StPlacesRequest placeRequest) async {
  try {
    final response = await httpPost('$_baseUrl/places/create', getHeaders(), jsonEncode(placeRequest.toJson()));
    if (response.statusCode >= HttpStatus.badRequest) {
      if (response.statusCode == HttpStatus.networkConnectTimeoutError) {
        return StResponse<StPlaceResponse>(status: HttpStatus.networkConnectTimeoutError);
      }
      try {
        final errorJson = json.decode(response.body);
        return StResponse<StPlaceResponse>(
          status: response.statusCode,
          message: errorJson['message'] ?? 'Error al crear el lugar',
          error: errorJson['error'] ?? '',
        );
      } catch (e) {
        return StResponse<StPlaceResponse>.createEmpty();
      }
    }
    final responseJson = json.decode(response.body);
    final placeData = StPlaceResponse.createEmpty().fromMap(responseJson['data']);
    return StResponse<StPlaceResponse>(
      data: placeData,
      status: response.statusCode,
      message: responseJson['message'],
    );
  } catch (e) {
    return StResponse<StPlaceResponse>(
      status: HttpStatus.internalServerError,
      message: 'Error durante la creación del lugar',
      error: e.toString(),
    );
  }
}
// get places by cityId
Future<StResponse<StPlaceResponse>> getPlacesByCity(int idCity) async {
  try {
    final response = await httpGet('$_baseUrl/places/city/$idCity', getHeaders());
    if (response.statusCode >= HttpStatus.badRequest) {
      if (response.statusCode == HttpStatus.networkConnectTimeoutError) {
        StResponse<StPlaceResponse> responseData = StResponse(status: HttpStatus.networkConnectTimeoutError);
        return responseData;
      }
      return StResponse.createEmpty();
    }
    StResponse<StPlaceResponse> responseData = StResponse.fromJsonList(utf8.decode(response.bodyBytes), StPlaceResponse.createEmpty());
    return responseData;
  } catch (e) {
    return StResponse.createEmpty();
  }
}

// create road type
  Future<StResponse<StRoadTypeResponse>> createRoadType(StRoadTypeRequest roadTypeRequest) async {
    try {
      final response = await httpPost('$_baseUrl/roadType/create', getHeaders(), jsonEncode(roadTypeRequest.toJson()));
      if (response.statusCode >= HttpStatus.badRequest) {
        if (response.statusCode == HttpStatus.networkConnectTimeoutError) {
          return StResponse<StRoadTypeResponse>(status: HttpStatus.networkConnectTimeoutError);
        }
        try {
          final errorJson = json.decode(response.body);
          return StResponse<StRoadTypeResponse>(
            status: response.statusCode,
            message: errorJson['message'] ?? 'Error al crear el tipo de carretera',
            error: errorJson['error'] ?? '',
          );
        } catch (e) {
          return StResponse<StRoadTypeResponse>.createEmpty();
        }
      }
      final responseJson = json.decode(response.body);
      final roadTypeData = StRoadTypeResponse.createEmpty().fromMap(responseJson['data']);
      return StResponse<StRoadTypeResponse>(
        data: roadTypeData,
        status: response.statusCode,
        message: responseJson['message'],
      );
    } catch (e) {
      return StResponse<StRoadTypeResponse>(
        status: HttpStatus.internalServerError,
        message: 'Error durante la creación del tipo de carretera',
        error: e.toString(),
      );
    }
  }

// get roadType
  Future<StResponse<StRoadTypeResponse>> getAllRoadTypes() async {
    try {
      final response = await httpGet('$_baseUrl/roadType', getHeaders());
      if (response.statusCode >= HttpStatus.badRequest) {
        if (response.statusCode == HttpStatus.networkConnectTimeoutError) {
          StResponse<StRoadTypeResponse> responseData = StResponse(status: HttpStatus.networkConnectTimeoutError);
          return responseData;
        }
        return StResponse.createEmpty();
      }
      StResponse<StRoadTypeResponse> responseData = StResponse.fromJsonList(utf8.decode(response.bodyBytes), StRoadTypeResponse.createEmpty());
      return responseData;
    } catch (e) {
      return StResponse.createEmpty();
    }
  }


// PERSONS MS 


// create a gender
  Future<StResponse<StGenderResponse>> createGender(StGenderRequest genderRequest) async{
    try{
      final response = await httpPost('$_baseUrl/gender/create', getHeaders(), jsonEncode(genderRequest.toJson()));
      if(response.statusCode >= HttpStatus.badRequest){
        if(response.statusCode == HttpStatus.networkConnectTimeoutError){
          return StResponse<StGenderResponse>(status: HttpStatus.networkConnectTimeoutError);
        }
        try{
          final errorJson = json.decode(response.body);
          return StResponse<StGenderResponse>(
            status: response.statusCode,
            message: errorJson['message'] ?? 'Error al crear el género',
            error: errorJson['error'] ?? '',
          );
        }catch(e){
          return StResponse<StGenderResponse>.createEmpty();
        }
      }
      final responseJson = json.decode(response.body);
      final genderData = StGenderResponse.createEmpty().fromMap(responseJson['data']);
      return StResponse<StGenderResponse>(
        data: genderData,
        status: response.statusCode,
        message: responseJson['message'],
      );
    }catch(e){
      return StResponse<StGenderResponse>(
        status: HttpStatus.internalServerError,
        message: 'Error durante la creación del género',
        error: e.toString(),
      );
    }
  }

//  get all genders
  Future<StResponse<StGenderResponse>> getAllGenders() async{
    try{
      final response = await httpGet('$_baseUrl/gender', getHeaders());
      if(response.statusCode >= HttpStatus.badRequest){
        if(response.statusCode == HttpStatus.networkConnectTimeoutError){
          StResponse<StGenderResponse> responseData = StResponse(status: HttpStatus.networkConnectTimeoutError);
          return responseData;
        }
        return StResponse.createEmpty();
      }
      StResponse<StGenderResponse> responseData = StResponse.fromJsonList(utf8.decode(response.bodyBytes), StGenderResponse.createEmpty());
      return responseData;
    }catch(e){
      return StResponse.createEmpty();
    }
  }
// create PersonType
  Future<StResponse<StPersonTypeResponse>> createPersonType(StPersonTypeRequest personTypeRequest) async{
    try{
      final response = await httpPost('$_baseUrl/personsType/create', getHeaders(), jsonEncode(personTypeRequest.toJson()));
      if(response.statusCode >= HttpStatus.badRequest){
        if(response.statusCode == HttpStatus.networkConnectTimeoutError){
          return StResponse<StPersonTypeResponse>(status: HttpStatus.networkConnectTimeoutError);
        }
        try{
          final errorJson = json.decode(response.body);
          return StResponse<StPersonTypeResponse>(
            status: response.statusCode,
            message: errorJson['message'] ?? 'Error al crear el tipo de persona',
            error: errorJson['error'] ?? '',
          );
        }catch(e){
          return StResponse<StPersonTypeResponse>.createEmpty();
        }
      }
      final responseJson = json.decode(response.body);
      final personTypeData = StPersonTypeResponse.createEmpty().fromMap(responseJson['data']);
      return StResponse<StPersonTypeResponse>(
        data: personTypeData,
        status: response.statusCode,
        message: responseJson['message'],
      );
    }catch(e){
      return StResponse<StPersonTypeResponse>(
        status: HttpStatus.internalServerError,
        message: 'Error durante la creación del tipo de persona',
        error: e.toString(),
      );
    }
  }
// get all person types
  Future<StResponse<StPersonTypeResponse>> getAllPersonTypes() async{
    try{
      final response = await httpGet('$_baseUrl/personsType', getHeaders());
      if(response.statusCode >= HttpStatus.badRequest){
        if(response.statusCode == HttpStatus.networkConnectTimeoutError){
          StResponse<StPersonTypeResponse> responseData = StResponse(status: HttpStatus.networkConnectTimeoutError);
          return responseData;
        }
        return StResponse.createEmpty();
      }
      StResponse<StPersonTypeResponse> responseData = StResponse.fromJsonList(utf8.decode(response.bodyBytes), StPersonTypeResponse.createEmpty());
      return responseData;
    }catch(e){
      return StResponse.createEmpty();
    }
  }


// GET ALL PERSONS
  // Future<StResponse<StPersonResponse>>getAllPersons() async{
  //   try{
  //     final response = await httpGet('$_baseUrl/persons', getHeaders());
  //     if(response.statusCode >= HttpStatus.badRequest){
  //       if(response.statusCode == HttpStatus.networkConnectTimeoutError){
  //         StResponse<StPersonResponse> responseData = StResponse(status: HttpStatus.networkConnectTimeoutError);
  //         return responseData;
  //       }
  //       return StResponse.createEmpty();
  //     }
  //     StResponse<StPersonResponse> responseData = StResponse.fromJsonList(utf8.decode(response.bodyBytes), StPersonResponse.createEmpty());
  //     return responseData;
  //   }catch(e){
  //     return StResponse.createEmpty();
  //   }
  // }
  // Get All Persons
Future<StResponse<StPersonResponse>> getAllPersons() async {
  try {
    final response = await httpGet('$_baseUrl/persons', getHeaders());
    
    if (response.statusCode >= HttpStatus.badRequest) {
      return StResponse(
        status: response.statusCode,
        message: 'Error del servidor: ${response.statusCode}',
      );
    }
    
    final responseData = jsonDecode(utf8.decode(response.bodyBytes));
    
    // Verificar si hay datos
    if (responseData['data'] == null) {
      return StResponse(
        status: responseData['status'] ?? 200,
        message: responseData['message'] ?? 'No data available',
      );
    }
    
    // Manejar tanto respuesta individual como lista
    if (responseData['data'] is Map) {
      final person = StPersonResponse.fromJson(responseData['data']);
      return StResponse(
        status: responseData['status'] ?? 200,
        message: responseData['message'] ?? 'OK',
        data: person,
        dataList: [person],
      );
    } else if (responseData['data'] is List) {
      final persons = (responseData['data'] as List)
          .map((item) => StPersonResponse.fromJson(item))
          .toList();
      return StResponse(
        status: responseData['status'] ?? 200,
        message: responseData['message'] ?? 'OK',
        dataList: persons,
      );
    }
    
    return StResponse.createEmpty();
  } catch (e, stackTrace) {
    debugPrint('Error en getAllPersons: $e');
    debugPrint('Stack trace: $stackTrace');
    return StResponse(
      status: 500,
      message: 'Error de conexión: ${e.toString()}',
    );
  }
}

// get person by id (profile)
Future<StResponse<StPersonResponse>> getPersonById(int personId) async {
  try {
    final response = await httpGet('$_baseUrl/persons/$personId', getHeaders());
    
    if (response.statusCode >= HttpStatus.badRequest) {
      return StResponse(
        status: response.statusCode,
        message: 'Error del servidor: ${response.statusCode}',
      );
    }
    
    final responseData = jsonDecode(utf8.decode(response.bodyBytes));
    
    // Verifica si hay datos y si tienen la estructura esperada
    if (responseData['data'] == null || responseData['data'] is! Map) {
      return StResponse(
        status: responseData['status'] ?? 404,
        message: responseData['message'] ?? 'Datos de persona no encontrados',
      );
    }
    
    try {
      final person = StPersonResponse.fromJson(responseData['data']);
      return StResponse(
        status: responseData['status'] ?? 200,
        message: responseData['message'] ?? 'OK',
        data: person,
        dataList: [person],
      );
    } catch (e, stackTrace) {
      debugPrint('Error parsing person data: $e');
      debugPrint('Stack trace: $stackTrace');
      return StResponse(
        status: 500,
        message: 'Error al procesar los datos de la persona',
      );
    }
    
  } catch (e, stackTrace) {
    debugPrint('Error en getPersonById: $e');
    debugPrint('Stack trace: $stackTrace');
    return StResponse(
      status: 500,
      message: 'Error de conexión: ${e.toString()}',
    );
  }
}
// get tolls by id
Future<StResponse<StTollsResponse>> getTollById(int tollId) async {
  try {
    final response = await httpGet('$_baseUrl/toll/$tollId', getHeaders());
    
    if (response.statusCode >= HttpStatus.badRequest) {
      return StResponse(
        status: response.statusCode,
        message: 'Error del servidor: ${response.statusCode}',
      );
    }
    
    final responseData = jsonDecode(utf8.decode(response.bodyBytes));
    
    if (responseData['data'] == null) {
      return StResponse(
        status: responseData['status'] ?? 200,
        message: responseData['message'] ?? 'No toll data available',
      );
    }
    
    final toll = StTollsResponse.fromJson(responseData['data']);
    return StResponse(
      data: toll,
      status: responseData['status'] ?? 200,
      message: responseData['message'] ?? 'OK',
    );
  } catch (e, stackTrace) {
    debugPrint('Error in getTollById: $e');
    debugPrint('Stack trace: $stackTrace');
    return StResponse(
      status: 500,
      message: 'Error de conexión: ${e.toString()}',
    );
  }
}
// tools by operador
// get transacations by vehicleId
Future<StResponse<TransactionResponse>> getTransactionsByVehicleId(int vehicleId) async {
    try {
      final response = await httpGet('$_baseUrl/transactions/vehicle/$vehicleId', getHeaders());
      
      if (response.statusCode >= HttpStatus.badRequest) {
        return StResponse(
          status: response.statusCode,
          message: 'Error del servidor: ${response.statusCode}',
        );
      }
      
      final responseData = jsonDecode(utf8.decode(response.bodyBytes));
      
      if (responseData['data'] == null) {
        return StResponse(
          status: responseData['status'] ?? 200,
          message: responseData['message'] ?? 'No transaction data available',
        );
      }
      
      final transactions = (responseData['data'] as List)
          .map((item) => TransactionResponse.fromJson(item))
          .toList();
          
      return StResponse(
        dataList: transactions,
        status: responseData['status'] ?? 200,
        message: responseData['message'] ?? 'OK',
      );
    } catch (e, stackTrace) {
      debugPrint('Error in getTransactionsByVehicleId: $e');
      debugPrint('Stack trace: $stackTrace');
      return StResponse(
        status: 500,
        message: 'Error de conexión: ${e.toString()}',
      );
    }
  }

// registerTollPass
Future<StResponse<TransactionResponse>> registerTollPass(TransactionRequest request) async {
  try {
    final response = await httpPost(
      '$_baseUrl/transactions/process',
      getHeaders(),
      jsonEncode(request.toJson()),
    );
    
    if (response.statusCode >= HttpStatus.badRequest) {
      return StResponse(
        status: response.statusCode,
        message: 'Error del servidor: ${response.statusCode}',
      );
    }
    
    final responseData = jsonDecode(utf8.decode(response.bodyBytes));
    
    return StResponse(
      status: responseData['status'] ?? 200,
      message: responseData['message'] ?? 'Transacción exitosa',
      data: TransactionResponse.fromJson(responseData['data']),
    );
  } catch (e, stackTrace) {
    debugPrint('Error en registerTollPass: $e');
    debugPrint('Stack trace: $stackTrace');
    return StResponse(
      status: 500,
      message: 'Error de conexión: ${e.toString()}',
    );
  }
}

// signup
Future<StResponse<StPersonResponse>> signup(StSignUpRequest personRequest) async {
  try {
    final response = await httpPost('$_baseUrl/persons/create', getHeaders(), jsonEncode(personRequest.toJson()));
    if (response.statusCode >= HttpStatus.badRequest) {
      if (response.statusCode == HttpStatus.networkConnectTimeoutError) {
        return StResponse<StPersonResponse>(status: HttpStatus.networkConnectTimeoutError);
      }
      try {
        final errorJson = json.decode(response.body);
        return StResponse<StPersonResponse>(
          status: response.statusCode,
          message: errorJson['message'] ?? 'Error al crear la persona',
          error: errorJson['error'] ?? '',
        );
      } catch (e) {
        return StResponse<StPersonResponse>.createEmpty();
      }
    }
    final responseJson = json.decode(response.body);
    final personData = StPersonResponse.createEmpty().fromMap(responseJson['data']);
    return StResponse<StPersonResponse>(
      data: personData,
      status: response.statusCode,
      message: responseJson['message'],
    );
  } catch (e) {
    return StResponse<StPersonResponse>(
      status: HttpStatus.internalServerError,
      message: 'Error durante la creación de la persona',
      error: e.toString(),
    );
  }
}



// En tu archivo api.dart
Future<StResponse<StPersonResponse>> getCurrentUserData() async {
  try {
    // Obtener el personId del almacenamiento seguro
    final personId = await Preferences().personId();
    
    if (personId == 0) {
      return StResponse(
        status: 401,
        message: 'No se pudo obtener el ID del usuario',
      );
    }
    
    // Usar el método existente getPersonById con el personId del token
    return await getPersonById(personId);
  } catch (e, stackTrace) {
    debugPrint('Error en getCurrentUserData: $e');
    debugPrint('Stack trace: $stackTrace');
    return StResponse(
      status: 500,
      message: 'Error al obtener datos del usuario: ${e.toString()}',
    );
  }
}
// DEFAULT METHODS
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
  // put
  Future<http.Response> httpPut(String baseUrl, dynamic header, String jsonRequest) async {
    try {
      var httpResponse = await http.put(
        Uri.parse(baseUrl),
        headers: header,
        body: jsonRequest,
        encoding: Encoding.getByName("utf-8")
      ).timeout(const Duration(seconds: 120));
      if (httpResponse.statusCode != HttpStatus.ok) {
        final error = StResponse.fromJson(httpResponse.body);
        if (error.status == authorizationForbidden || error.status == authorizationUnauthorized) {
          // httpResponse = await reloginMethodPut(baseUrl, header, httpResponse, jsonRequest);
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
      'Authorization': 'Bearer $token',
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