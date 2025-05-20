class StPlacesRequest {
  final String placeName;
  final int idCity;
  final int idCountry;

  StPlacesRequest({
    required this.placeName,
    required this.idCity,
    required this.idCountry,
  });

  Map<String, dynamic> toJson() {
    return {
      'placeName': placeName,
      'idCity': idCity,
      'idCountry': idCountry,
    };
  }

  debugPrint() {
    print('Place Name: $placeName, City ID: $idCity, Country ID: $idCountry');
  }
}