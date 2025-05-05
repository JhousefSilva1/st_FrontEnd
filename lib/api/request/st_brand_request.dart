class StBrandRequest {
  final String brandName;
  final String brandDescription;
  final String brandManufacturingCountry;

  StBrandRequest({
    required this.brandName,
    required this.brandDescription,
    required this.brandManufacturingCountry,
  });

  Map<String, dynamic> toJson() {
    return {
      'brandName': brandName,
      'brandDescription': brandDescription,
      'brandManufacturingCountry': brandManufacturingCountry,
    };
  }
}