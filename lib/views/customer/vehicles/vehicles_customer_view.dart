import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:smarttolls/generated/l10n.dart';
import 'package:smarttolls/providers/customer/vehicle_customer_provider.dart';
import 'package:smarttolls/providers/providers.dart';
import 'package:smarttolls/style/app_style.dart';
import 'package:smarttolls/utils/utils.dart';
import 'package:smarttolls/views/customer/vehicles/add_vehicle_customer_view.dart';
import 'package:smarttolls/widgets/customer/vehicles/vehicles_customer_card.dart';
import 'package:smarttolls/widgets/menu/mobile/drawerMobile.dart';
import 'package:smarttolls/widgets/widgets.dart';

import '../../../api/response/admin/st_vehicles_response.dart';

class VehiclesCustomerView extends StatelessWidget {
  static const String routerName = 'customerVehicles';
  static const String routerPath = '/customerVehicles';

  const VehiclesCustomerView({super.key});

  @override
  Widget build(BuildContext context) {
    bool isMobile = ResponsiveBreakpoints.of(context).smallerThan(TABLET);
    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBar(
          actions: [IconButton(
            onPressed: () => context.pushNamed(AddVehicleCustomerView.routerName),
            icon: const Icon(Icons.add_rounded, color: AppStyle.primary, size: 30),
          )
          ],
          centerTitle: true,
          text: S.of(context).myVehicles,
        ),
        backgroundColor: AppStyle.white,
        // drawer: isMobile ? const SmartTollsMobileDrawer() : null,
        body: isMobile
            ? const SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    children: [
                      VehiclesCustomerList(),
                    ],
                  ),
                ),
              )
            : const VehiclesCustomerTabletView(),
      ),
    );
  }
}

class VehiclesCustomerTabletView extends StatelessWidget {
  const VehiclesCustomerTabletView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        SmartTollsDrawer(),
        Expanded(
          flex: 2,
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  VehiclesCustomerList(),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class VehiclesCustomerList extends StatefulWidget {
  const VehiclesCustomerList({super.key});

  @override
  State<VehiclesCustomerList> createState() => _VehiclesCustomerListState();
}

class _VehiclesCustomerListState extends State<VehiclesCustomerList> {
  @override
  void initState() {
    super.initState();
    _loadVehicles();
  }

  void _loadVehicles() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<VehiclesCustomerProvider>(context, listen: false);
      
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      provider.loadCustomerVehicles(userProvider.personId ?? 0).then((_) {
        final errorMsg = provider.errorMessage;
        if (errorMsg != null && errorMsg.isNotEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(errorMsg)),
          );
        }
      });
    });
  }

@override
Widget build(BuildContext context) {
  final provider = Provider.of<VehiclesCustomerProvider>(context);
  return Column(
    children: [
      if (provider.isLoading && provider.vehicles.isEmpty)
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: CircularProgressIndicator(
            color: AppStyle.primary,
            strokeWidth: 2,
          ),
        ),
      
      // Mostrar error solo si hay un mensaje Y la lista está vacía
      if (provider.errorMessage != null && provider.vehicles.isEmpty)
        Column(
          children: [
            Text(
              provider.errorMessage!,
              style: const TextStyle(color: AppStyle.red),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                final userProvider = Provider.of<UserProvider>(context, listen: false);
                provider.retryLoading(userProvider.personId ?? 0);
              },
              child: Text(
                S.of(context).retry,
                style: const TextStyle(
                  color: AppStyle.white,
                  fontSize: 16.0,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      
      // Mostrar estado vacío solo cuando no hay error y no hay vehículos
      if (!provider.isLoading && provider.vehicles.isEmpty && provider.errorMessage == null)
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 32),
          child: Column(
            children: [
              Icon(Icons.directions_car, size: 50, color: AppStyle.primary.withOpacity(0.3)),
              const SizedBox(height: 16),
              Text(
                'No tienes vehículos registrados',
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w700,
                  color: AppStyle.primary.withOpacity(0.5),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Presiona el botón "+" para agregar tu primer vehículo',
                style: TextStyle(
                  fontSize: 14.0,
                  color: AppStyle.primary.withOpacity(0.5),
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      
      // Mostrar lista solo si hay vehículos
      if (provider.vehicles.isNotEmpty)
        ListView.separated(
          itemCount: provider.vehicles.length,
          itemBuilder: (context, index) {
            final vehicle = provider.vehicles[index];
            return VehiclesCustomerCard(vehicle: vehicle);
          },
          physics: const NeverScrollableScrollPhysics(),
          primary: false,
          shrinkWrap: true,
          separatorBuilder: (context, index) => const SizedBox(height: 16),
        ),
    ],
  );
}
}


void showEditVehicleDialog(BuildContext context, StVehicleResponse vehicle) {
  // Controllers inicializados con los valores del vehículo
  final vehiclePlateController = TextEditingController(text: vehicle.licensePlate);
  final vehicleChassisNumberController = TextEditingController(text: vehicle.chassisNumber);
  final vehicleEngineNumberController = TextEditingController(text: vehicle.engineNumber);
  final vehicleManufacturingYearController = TextEditingController(text: vehicle.manufacturingYear);
  final vehicleWeightController = TextEditingController(text: vehicle.weight?.toString() ?? '');

  // Providers
  final provider = Provider.of<VehiclesCustomerProvider>(context, listen: false);
  final fuelTypesProvider = Provider.of<FuelTypeProvider>(context, listen: false);
  final vehicleColorsProvider = Provider.of<VehiclesColorsProvider>(context, listen: false);
  final vehicleBrandsProvider = Provider.of<BrandProvider>(context, listen: false);
  final vehicleModelsProvider = Provider.of<ModelProvider>(context, listen: false);
  final vehicleTypesProvider = Provider.of<VehicleTypeProvider>(context, listen: false);
  final vehicleCityProvider = Provider.of<CityProvider>(context, listen: false);
  final vehicleCountryProvider = Provider.of<CountryProvider>(context, listen: false);
  final userProvider = Provider.of<UserProvider>(context, listen: false);

  // Variables para almacenar los valores seleccionados
  String? selectedFuelTypeId = vehicle.fuelTypes.idFuelType.toString();
  String? selectedVehicleColorId = vehicle.vehiclesColors.idColor.toString();
  String? selectedVehicleBrandId = vehicle.vehiclesModels.brand.idBrand.toString();
  String? selectedVehicleModelId = vehicle.vehiclesModels.idModel.toString();
  String? selectedVehiclesTypeId = vehicle.vehiclesType.idVehiclesType.toString();
  String? selectedVehiclesCountryId = vehicle.country.idCountry.toString();
  String? selectedVehiclesCityId = vehicle.city.idCity.toString();

    String? selectedFuelTypeName;
  String? selectedVehicleColorName;
  String? selectedVehicleModelName;
  String? selectedVehicleBrandName;
  String? selectedVehiclesTypeName;
  String? selectedVehiclesCityName;
  String? selectedVehiclesCountryName;

  // Cargar datos necesarios
  WidgetsBinding.instance.addPostFrameCallback((_) {
    fuelTypesProvider.loadFuelTypes();
    vehicleColorsProvider.loadVehiclesColors();
    vehicleBrandsProvider.loadBrands();
    vehicleModelsProvider.loadModelsByBrand(vehicle.vehiclesModels.brand.idBrand);
    vehicleTypesProvider.loadVehicleTypes();
    vehicleCountryProvider.loadCountries();
    vehicleCityProvider.loadCitiesByCountry(vehicle.country.idCountry);
  });

  Utils.textFieldAlert(
    context: context,
    content: StatefulBuilder(
      builder: (BuildContext context, StateSetter setState) {
        return SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Placa del vehículo
              CustomField(
                controller: vehiclePlateController,
                hintText: S.of(context).plate,
                keyboardType: TextInputType.text,
                prefixIcon: const Icon(Icons.car_crash, color: AppStyle.primary),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese la matrícula del vehículo';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Número de chasis
              CustomField(
                controller: vehicleChassisNumberController,
                hintText: S.of(context).chassisNumber,
                keyboardType: TextInputType.text,
                prefixIcon: const Icon(Icons.confirmation_number, color: AppStyle.primary),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese el número de chasis';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Número de motor
              CustomField(
                controller: vehicleEngineNumberController,
                hintText: S.of(context).engineNumber,
                keyboardType: TextInputType.text,
                prefixIcon: const Icon(Icons.engineering, color: AppStyle.primary),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese el número de motor';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Año de fabricación
              CustomField(
                controller: vehicleManufacturingYearController,
                hintText: S.of(context).manufacturingYear,
                keyboardType: TextInputType.number,
                prefixIcon: const Icon(Icons.calendar_today, color: AppStyle.primary),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese el año de fabricación';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Peso
              CustomField(
                controller: vehicleWeightController,
                hintText: S.of(context).weight,
                keyboardType: TextInputType.number,
                prefixIcon: const Icon(Icons.monitor_weight, color: AppStyle.primary),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese el peso del vehículo';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Tipo de combustible

            ],
          ),
        );
      },
    ),
    negativeText: S.of(context).cancel,
    positiveOnPressed: () async {
      if (vehiclePlateController.text.isNotEmpty && selectedFuelTypeId != null) {
                final userProvider = Provider.of<UserProvider>(context, listen: false);

        final personId = userProvider.personId ?? 0;
        
        await provider.updateVehicle(
          vehicle.idVehicle ??  0,
          vehiclePlateController.text,
          vehicleChassisNumberController.text,
          vehicleEngineNumberController.text,
          vehicleManufacturingYearController.text,
          vehicleWeightController.text,
          int.parse(selectedFuelTypeId!),
          int.parse(selectedVehicleColorId!),
          int.parse(selectedVehicleModelId!),
          int.parse(selectedVehicleBrandId!),
          int.parse(selectedVehiclesTypeId!),
          int.parse(selectedVehiclesCityId!),
          int.parse(selectedVehiclesCountryId!),
          personId,
        );
        
        Navigator.of(context, rootNavigator: true).pop();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Todos los campos son requeridos")),
        );
      }
    },
    positiveText: S.of(context).update,
    title: S.of(context).editVehicle,
  );
}