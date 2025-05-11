import '../../models/st_response.dart';
import 'dart:convert';
import 'package:smarttolls/api/api.dart';
class StVehicleResponse implements StResponseService {

  int idVehicle;
  String? licensePlate;
  String? chassisNumber;
  String? engineNumber;
  String? manufacturingYear;
  double weight;
  // StPersonResponse person;
  StCityResponse city;
  StVehiclesColorsResponse vehiclesColors;
  StVehiclesTypeResponse vehiclesType;
  StVehiclesModelsResponse vehiclesModels;

  StVehicleResponse({
    required this.idVehicle,
    this.licensePlate,
    this.chassisNumber,
    this.engineNumber,
    this.manufacturingYear,
    required this.weight,
    // required this.person,
    required this.city,
    required this.vehiclesColors,
    required this.vehiclesType,
    required this.vehiclesModels,
  });

  factory StVehicleResponse.createEmpty() => StVehicleResponse(
        idVehicle: 0,
        licensePlate: '',
        chassisNumber: '',
        engineNumber: '',
        manufacturingYear: '',
        weight: 0.0,
        // person: StPersonResponse.createEmpty(),
        city: StCityResponse.createEmpty(),
        vehiclesColors: StVehiclesColorsResponse.createEmpty(),
        vehiclesType: StVehiclesTypeResponse.createEmpty(),
        vehiclesModels: StVehiclesModelsResponse.createEmpty(),
      );

      @override
      String toJson() => json.encode(toMap());

  factory StVehicleResponse.fromJson(Map<String, dynamic> json) => StVehicleResponse(
        idVehicle: json["idVehicle"],
        licensePlate: json["licensePlate"],
        chassisNumber: json["chassisNumber"],
        engineNumber: json["engineNumber"],
        manufacturingYear: json["manufacturingYear"],
        weight: json["weight"].toDouble(),
        // person: StPersonResponse.fromJson(json["person"]),
        city: StCityResponse.fromJson(json["city"]),
        vehiclesColors: StVehiclesColorsResponse.fromJson(json["vehiclesColors"]),
        vehiclesType: StVehiclesTypeResponse.fromJson(json["vehiclesType"]),
        vehiclesModels: StVehiclesModelsResponse.fromJson(json["vehiclesModels"]),
      );

      @override
      Map<String, dynamic> toMap() => {
        "idVehicle": idVehicle,
        "licensePlate": licensePlate,
        "chassisNumber": chassisNumber,
        "engineNumber": engineNumber,
        "manufacturingYear": manufacturingYear,
        "weight": weight,
        // "person": person.toJson(),
        "city": city.toJson(),
        "vehiclesColors": vehiclesColors.toJson(),
        "vehiclesType": vehiclesType.toJson(),
        "vehiclesModels": vehiclesModels.toJson(),
      };

      @override
      StVehicleResponse fromJson(String json) {
        return fromMap(jsonDecode(json));
      }

      @override
      StVehicleResponse fromMap(Map<String, dynamic> json) => StVehicleResponse(
        idVehicle: json["idVehicle"],
        licensePlate: json["licensePlate"],
        chassisNumber: json["chassisNumber"],
        engineNumber: json["engineNumber"],
        manufacturingYear: json["manufacturingYear"],
        weight: json["weight"].toDouble(),
        // person: StPersonResponse.fromJson(json["person"]),
        city: StCityResponse.fromJson(json["city"]),
        vehiclesColors: StVehiclesColorsResponse.fromJson(json["vehiclesColors"]),
        vehiclesType: StVehiclesTypeResponse.fromJson(json["vehiclesType"]),
        vehiclesModels: StVehiclesModelsResponse.fromJson(json["vehiclesModels"]),
      );
  
}