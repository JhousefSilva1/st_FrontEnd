class StTollRequest{
  final String tollsName;
  final int idPlace;

  StTollRequest({
    required this.tollsName,
    required this.idPlace,
  });

  Map<String, dynamic> toJson() {
    return {
      'tollsName': tollsName,
      'idPlace': idPlace,
    };
  }

  debugPrint() {
    print('Tolls Name: $tollsName, Place ID: $idPlace');
  }
}