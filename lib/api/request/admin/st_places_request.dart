class StPlacesRequest {
  final String placeName;
  final int idCity;


  StPlacesRequest({
    required this.placeName,
    required this.idCity,

  });

  Map<String, dynamic> toJson() {
    return {
      'placeName': placeName,
      'idCity': idCity,
    
    };
  }

  debugPrint() {
    print('Place Name: $placeName, City ID: $idCity');
  }
}