import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:smarttolls/api/api.dart';
import 'package:smarttolls/generated/l10n.dart';
import 'package:smarttolls/utils/utils.dart';
import 'package:smarttolls/views/views.dart';
import 'package:smarttolls/widgets/custom_field.dart';

class VehicleTypeProvider extends ChangeNotifier {
  List<StVehiclesTypeResponse> _allVehiclesType = []; // Lista completa
  List<StVehiclesTypeResponse> _vehiclesType = []; // Lista filtrada  

  bool _isLoading = false;

  String? _errorMessage = '';
  String? _selectedVehicleType = '';
  String? _newVehicleTypeName;

  List<StVehiclesTypeResponse> get vehiclesType => _vehiclesType;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String? get selectedVehiclesType => _selectedVehicleType;
  String? get newVehicleTypeName => _newVehicleTypeName;

  // Método para buscar tipos de vehículos

  void searchVehiclesType(String query){
    if (query.isEmpty){
      _vehiclesType = List.from(_allVehiclesType);
    }else{
      _vehiclesType = _allVehiclesType.where((vehicleType) => 
        vehicleType.vehiclesTypesName?.toLowerCase().contains(query.toLowerCase()) ?? false
      ).toList();
    }
    notifyListeners();
  }

  // cargar tipos de vehículos desde la API
  Future<void> loadVehiclesType() async{
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try{
      final response = await SmartTollsApi().getAllTypeVehicles();
      if(response.isSuccess() && response.dataList != null){
        _allVehiclesType = response.dataList!;
        _vehiclesType = List.from(_allVehiclesType);
      }else{
        _errorMessage = response.message ?? 'Error al cargar los tipos de vehículos';
      }
    }catch(e){
      _errorMessage = 'Error de conexión: ${e.toString()}';
    }finally{
      _isLoading = false;
      notifyListeners();
    }
  }

  // agregar nuevo tipo de vehículo
  Future<void> addVehiclesType(String vehiclesTypeName) async{
    _isLoading = true;
    notifyListeners();

    try{
      // Aca se implementa la logica para agregar un nuevo tipo de vehiculo
    }catch(e){
      _errorMessage = 'Error de conexión: ${e.toString()}';
    }finally{
      _isLoading = false;
      notifyListeners();
    }
  }
  // Mostrar dialgoo para agregar tipo de vehículo

  void goToAddVehiclesType(BuildContext context){
    final vehicleTypeNameController = TextEditingController();

    Utils.textFieldAlert(
      context: context,
      content: CustomField(
        controller: vehicleTypeNameController,
        hintText: S.of(context).vehicleType,
        keyboardType: TextInputType.text,
        onChanged: (value) {},
        prefixIcon: const Icon(Icons.car_rental_sharp),
      ),
      negativeText: S.of(context).cancel,
      positiveOnPressed: (){
        if(vehicleTypeNameController.text.isNotEmpty){
          addVehiclesType(vehicleTypeNameController.text);
          Navigator.pop(context);
        }
      },
      positiveText: S.of(context).add,
      title: S.of(context).addVehicleType,
    );
  }

  // metodo para recargar datos
  void retryLoading(){
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    loadVehiclesType();
  }
  }
