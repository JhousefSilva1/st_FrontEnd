class StCountryRequest{
  final String countryName;

  StCountryRequest({
    required this.countryName,
  });

  Map<String, dynamic> toJson() {
    return {
      'countryName': countryName,
    };
  }

  debugPrint() {
    print('Country Name: $countryName');
  }
}