class StVehiclesRequest {
  final String licensePlate;
  final String chassisNumber;
  final String engineNumber;
  final String manufacturingYear;
  final double weight;
  final int idFuelTypes;
  final int idVehiclesColors;
  final int idVehiclesModels;
  final int idVehiclesType;
  final int idVehiclesBrand;
  final int idCity;
  final int idCountry;
  final int idPerson;


  StVehiclesRequest({
    required this.licensePlate,
    required this.chassisNumber,
    required this.engineNumber,
    required this.manufacturingYear,
    required this.weight,
    required this.idFuelTypes,
    required this.idVehiclesColors,
    required this.idVehiclesModels,
    required this.idVehiclesType,
    required this.idVehiclesBrand,
    required this.idCity,
    required this.idCountry,
    required this.idPerson,

  });

  Map<String, dynamic> toJson() {
    return {
      'licensePlate': licensePlate,
      'chassisNumber': chassisNumber,
      'engineNumber': engineNumber,
      'manufacturingYear': manufacturingYear,
      'weight': weight,
      'idFuelTypes': idFuelTypes,
      'idVehiclesColors': idVehiclesColors,
      'idVehiclesModels': idVehiclesModels,
      'idVehiclesType': idVehiclesType,
      'idVehiclesBrand': idVehiclesBrand,
      'idCity': idCity,
      'idCountry': idCountry,
      'idPerson': idPerson,

    };
  }

  void debugPrint() {
    print('''
Vehicle Request:
  License Plate: $licensePlate
  Chassis Number: $chassisNumber
  Engine Number: $engineNumber
  Manufacturing Year: $manufacturingYear
  Weight: $weight
  Fuel Type ID: $idFuelTypes
  Vehicle Color ID: $idVehiclesColors
  Vehicle Model ID: $idVehiclesModels
  Vehicle Type ID: $idVehiclesType
  Vehicle Brand ID: $idVehiclesBrand
  City ID: $idCity
  Country ID: $idCountry
  Person ID: $idPerson
''');
  }
}