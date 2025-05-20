class StTollsRequest {
  final String tollsName;
  final int idPlaces;

  StTollsRequest({
    required this.tollsName,
    required this.idPlaces,
  });

  Map<String, dynamic> toJson() {
    return {
      'tollsName': tollsName,
      'idPlaces': idPlaces,
    };
  }

  debugPrint() {
    print('Toll Name: $tollsName, Place ID: $idPlaces');
  }
}