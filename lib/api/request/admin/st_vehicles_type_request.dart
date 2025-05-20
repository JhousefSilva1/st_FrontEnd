class StVehiclesTypeRequest{
  final String vehiclesTypes;

  StVehiclesTypeRequest({
    required this.vehiclesTypes,
  });

  Map<String, dynamic> toJson() {
    return {
      'vehiclesTypes': vehiclesTypes,
    };
  }
}