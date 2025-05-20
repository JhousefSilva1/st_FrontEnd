class StVehiclesModelsRequest {
  final String modelName;
  final int idBrand;

  StVehiclesModelsRequest({
    required this.modelName,
    required this.idBrand,
  });

  Map<String, dynamic> toJson() {
    return {
      'modelName': modelName,
      'idBrand': idBrand,
    };
  }

  debugPrint() {
    print('Model Name: $modelName, Brand ID: $idBrand');
  }
}