class StCityRequest {
  final String cityName;
  final int idCountry;

  StCityRequest({
    required this.cityName,
    required this.idCountry,
  });

  Map<String, dynamic> toJson() {
    return {
      'cityName': cityName,
      'idCountry': idCountry,
    };
  }

  debugPrint() {
    print('City Name: $cityName, Country ID: $idCountry');
  }
}