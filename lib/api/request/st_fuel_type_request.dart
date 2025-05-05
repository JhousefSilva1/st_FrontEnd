class StFuelTypesRequest{
  final String fuelTypeFuel;

  StFuelTypesRequest({
    required this.fuelTypeFuel,
  });

  Map<String, dynamic> toJson() {
    return {
      'fuelTypeFuel': fuelTypeFuel,
    };
  }
}