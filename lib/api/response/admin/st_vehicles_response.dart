import '../../../models/st_response.dart';
import 'dart:convert';
import 'package:smarttolls/api/api.dart';
class StVehicleResponse implements StResponseService {

  int idVehicle;
  String? licensePlate;
  String? chassisNumber;
  String? engineNumber;
  String? manufacturingYear;
  double? weight;
  double? wallet;
  int vehicleStatus;
  StFuelTypesResponse fuelTypes;
  StVehiclesColorsResponse vehiclesColors;
  StVehiclesModelsResponse vehiclesModels;
  StVehiclesTypeResponse vehiclesType;
  StCityResponse city;
  StCountryResponse country;
  StPersonResponse person;
  // StAuditResponse audit;

  StVehicleResponse({
    required this.idVehicle,
    this.licensePlate,
    this.chassisNumber,
    this.engineNumber,
    this.manufacturingYear,
    this.weight,
    this.wallet,
    required this.vehicleStatus,
    required this.fuelTypes,
    required this.vehiclesColors,
    required this.vehiclesModels,
    required this.vehiclesType,
    required this.city,
    required this.country,
    required this.person,
    // required this.audit,
  });
  factory StVehicleResponse.create() => StVehicleResponse(
        idVehicle: 0,
        licensePlate: '',
        chassisNumber: '',
        engineNumber: '',
        manufacturingYear: '',
        weight: 0.0,
        wallet: 0.0,
        vehicleStatus: 0,
        fuelTypes: StFuelTypesResponse.createEmpty(),
        vehiclesColors: StVehiclesColorsResponse.createEmpty(),
        vehiclesModels: StVehiclesModelsResponse.createEmpty(),
        vehiclesType: StVehiclesTypeResponse.createEmpty(),
        city: StCityResponse.createEmpty(),
        country: StCountryResponse.createEmpty(),
        person: StPersonResponse.createEmpty(),
        // audit: StAuditResponse.createEmpty(),
      );
  @override
  String toJson() => json.encode(toMap());

  factory StVehicleResponse.fromJson(Map<String, dynamic> json) => StVehicleResponse(
        idVehicle: json['idVehicle'] as int,
        licensePlate: json['licensePlate'] as String?,
        chassisNumber: json['chassisNumber'] as String?,
        engineNumber: json['engineNumber'] as String?,
        manufacturingYear: json['manufacturingYear'] as String?,
        weight: (json['weight'] as num?)?.toDouble(),
        wallet: (json['wallet'] as num?)?.toDouble(),
        vehicleStatus: json['vehicleStatus'] as int? ?? 0,
        fuelTypes: json["fuelTypes"]!=null
            ? StFuelTypesResponse.fromJson(json["fuelTypes"] as Map<String, dynamic>)
            : StFuelTypesResponse.createEmpty(),
        vehiclesColors: json["vehiclesColors"]!=null
            ? StVehiclesColorsResponse.fromJson(json["vehiclesColors"] as Map<String, dynamic>)
            : StVehiclesColorsResponse.createEmpty(),
        vehiclesModels: json["vehiclesModels"]!=null
            ? StVehiclesModelsResponse.fromJson(json["vehiclesModels"] as Map<String, dynamic>)
            : StVehiclesModelsResponse.createEmpty(),
        vehiclesType: json["vehiclesType"]!=null
            ? StVehiclesTypeResponse.fromJson(json["vehiclesType"] as Map<String, dynamic>)
            : StVehiclesTypeResponse.createEmpty(),
        city: json["city"]!=null
            ? StCityResponse.fromJson(json["city"] as Map<String, dynamic>)
            : StCityResponse.createEmpty(),
        country: json["country"]!=null
            ? StCountryResponse.fromJson(json["country"] as Map<String, dynamic>)
            : StCountryResponse.createEmpty(),
        person: json["person"]!=null
            ? StPersonResponse.fromJson(json["person"] as Map<String, dynamic>)
            : StPersonResponse.createEmpty(),
      );

    @override
    Map<String, dynamic> toMap() =>{
      "idVehicle": idVehicle,
      "licensePlate": licensePlate,
      "chassisNumber": chassisNumber,
      "engineNumber": engineNumber,
      "manufacturingYear": manufacturingYear,
      "weight": weight,
      "wallet": wallet,
      "vehicleStatus": vehicleStatus,
      "fuelTypes": fuelTypes.toJson(),
      "vehiclesColors": vehiclesColors.toJson(),
      "vehiclesModels": vehiclesModels.toJson(),
      "vehiclesType": vehiclesType.toJson(),
      "city": city.toMap(),
      "country": country.toMap(),
      "person": person.toMap(),
    };

    @override
    StVehicleResponse fromJson(String json) {
      return fromMap(jsonDecode(json));
    }

    @override
    @override
    StVehicleResponse fromMap(Map<String, dynamic> json)=> StVehicleResponse(
              idVehicle: json['idVehicle'] as int,
        licensePlate: json['licensePlate'] as String?,
        chassisNumber: json['chassisNumber'] as String?,
        engineNumber: json['engineNumber'] as String?,
        manufacturingYear: json['manufacturingYear'] as String?,
        weight: (json['weight'] as num?)?.toDouble(),
        wallet: (json['wallet'] as num?)?.toDouble(),
        vehicleStatus: json['vehicleStatus'] as int? ?? 0,
        fuelTypes: json["fuelTypes"]!=null
            ? StFuelTypesResponse.fromJson(json["fuelTypes"] as Map<String, dynamic>)
            : StFuelTypesResponse.createEmpty(),
        vehiclesColors: json["vehiclesColors"]!=null
            ? StVehiclesColorsResponse.fromJson(json["vehiclesColors"] as Map<String, dynamic>)
            : StVehiclesColorsResponse.createEmpty(),
        vehiclesModels: json["vehiclesModels"]!=null
            ? StVehiclesModelsResponse.fromJson(json["vehiclesModels"] as Map<String, dynamic>)
            : StVehiclesModelsResponse.createEmpty(),
        vehiclesType: json["vehiclesType"]!=null
            ? StVehiclesTypeResponse.fromJson(json["vehiclesType"] as Map<String, dynamic>)
            : StVehiclesTypeResponse.createEmpty(),
        city: json["city"]!=null
            ? StCityResponse.fromJson(json["city"] as Map<String, dynamic>)
            : StCityResponse.createEmpty(),
        country: json["country"]!=null
            ? StCountryResponse.fromJson(json["country"] as Map<String, dynamic>)
            : StCountryResponse.createEmpty(),
        person: json["person"]!=null
            ? StPersonResponse.fromJson(json["person"] as Map<String, dynamic>)
            : StPersonResponse.createEmpty(),
    );
}