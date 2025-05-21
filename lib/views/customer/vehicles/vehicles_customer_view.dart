import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:smarttolls/generated/l10n.dart';
import 'package:smarttolls/providers/customer/vehicle_customer_provider.dart';
import 'package:smarttolls/providers/providers.dart';
import 'package:smarttolls/style/app_style.dart';
import 'package:smarttolls/utils/utils.dart';
import 'package:smarttolls/widgets/customer/vehicles_customer_card.dart';
import 'package:smarttolls/widgets/menu/mobile/drawerMobile.dart';
import 'package:smarttolls/widgets/widgets.dart';

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
          actions: [
            IconButton(
              onPressed: () => showAddVehicleDialog(context),
              icon: const Icon(Icons.add_rounded, color: AppStyle.primary, size: 30),
            )
          ],
          centerTitle: true,
          text: S.of(context).myVehicles,
        ),
        backgroundColor: AppStyle.white,
        drawer: isMobile ? const SmartTollsMobileDrawer() : null,
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
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final provider = Provider.of<VehiclesCustomerProvider>(context, listen: false);
      
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
        if (provider.errorMessage != null)
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
        if (!provider.isLoading && provider.vehicles.isEmpty && provider.errorMessage == null)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 32),
            child: Text(
              'No hay vehículos registrados',
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.w700,
                color: AppStyle.primary.withOpacity(0.5),
              ),
            ),
          ),
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

void showAddVehicleDialog(BuildContext context){

  
  // controller
  final provider = Provider.of<VehiclesCustomerProvider>(context, listen: false);
  final vehiclePlateController = TextEditingController();
  final vehicleChassisNumberController = TextEditingController();
  final vehicleEngineNumberController = TextEditingController();
  final vehicleManufacturingYearController = TextEditingController();
  final vehicleWeightController = TextEditingController();
  
  // providers
  final fuelTypesProvider = Provider.of<FuelTypeProvider>(context, listen: false);
  final vehicleColorsProviders = Provider.of<VehiclesColorsProvider>(context, listen: false);
  final vehicleBrandsProviders = Provider.of<BrandProvider>(context, listen: false);
  final vehicleModelsProviders = Provider.of<ModelProvider>(context, listen: false);
  final vehicleTypesProviders = Provider.of<VehicleTypeProvider>(context, listen: false);
  final vehicleCityProvider = Provider.of<CityProvider>(context, listen: false);
  final vehicleCountryProvider = Provider.of<CountryProvider>(context, listen: false);
  final userProvider = Provider.of<UserProvider>(context, listen: false);
  


    WidgetsBinding.instance.addPostFrameCallback((_) {
    fuelTypesProvider.loadFuelTypes();
    vehicleColorsProviders.loadVehiclesColors();
    vehicleBrandsProviders.loadBrands();
    vehicleModelsProviders.loadModelsByBrand(0);
    vehicleTypesProviders.loadVehiclesType();
    vehicleCountryProvider.loadCountries();
  });
  //varialebles Id
  String? selectedFuelTypeId;
  String? selectedVehicleColorId;
  String? selectedVehicleModelId;
  String? selectedVehicleBrandId;
  String? selectedVehiclesTypeId;
  String? selectedVehiclesCityId;
  String? selectedVehiclesCountryId;

  // variables con name segun Id
  String? selectedFuelTypeName;
  String? selectedVehicleColorName;
  String? selectedVehicleModelName;
  String? selectedVehicleBrandName;
  String? selectedVehiclesTypeName;
  String? selectedVehiclesCityName;
  String? selectedVehiclesCountryName;
  

  Utils.textFieldAlert(
    context: context,
    content: SingleChildScrollView(
      child: StatefulBuilder(
        builder: (BuildContext context, StateSetter setState){
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // vehicle plate
              CustomField(
                controller: vehiclePlateController,
                hintText: S.of(context).plate,
                keyboardType: TextInputType.text,
                prefixIcon: const Icon(Icons.car_crash, color: AppStyle.primary),
                validator: (value)  {
                  if(value == null || value.isEmpty){
                    return 'Por favor ingrese la matricula del coche';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              // vehicle chassis number
              CustomField(
                controller: vehicleChassisNumberController,
                hintText: S.of(context).chassisNumber,
                keyboardType: TextInputType.text,
                prefixIcon: const Icon(Icons.car_crash, color: AppStyle.primary),
                validator: (value)  {
                  if(value == null || value.isEmpty){
                    return 'Por favor ingrese el numero de chasis del coche';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              // vehicle engine number
              CustomField(
                controller: vehicleEngineNumberController,
                hintText: S.of(context).engineNumber,
                keyboardType: TextInputType.text,
                prefixIcon: const Icon(Icons.car_crash, color: AppStyle.primary),
                validator: (value)  {
                  if(value == null || value.isEmpty){
                    return 'Por favor ingrese el numero de motor del coche';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              // manufacturing year
              CustomField(
                controller: vehicleManufacturingYearController,
                hintText: S.of(context).manufacturingYear,
                keyboardType: TextInputType.number,
                prefixIcon: const Icon(Icons.calendar_today, color: AppStyle.primary),
                validator: (value)  {
                  if(value == null || value.isEmpty){
                    return 'Por favor ingrese el año de fabricacion del coche';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              // weight
              CustomField(
                controller: vehicleWeightController,
                hintText: S.of(context).weight,
                keyboardType: TextInputType.number,
                prefixIcon: const Icon(Icons.monitor_weight, color: AppStyle.primary),
                validator: (value)  {
                  if(value == null || value.isEmpty){
                    return 'Por favor ingrese el peso del coche';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              // fuel type Dropdown
              Consumer<FuelTypeProvider>(
                builder: (context, fuelTypesProvider, _){
                  return DropdownButtonFormField<String>(
                    value: selectedFuelTypeId,
                    hint: Text(S.of(context).fuelType),
                    items: fuelTypesProvider.fuelType.map((fuel){
                     return DropdownMenuItem<String>( 
                      value: fuel.idFuelType.toString(),
                      child: Text(fuel.fuelTypeName ?? 'N/A'),
                     ) ;
                    }).toList(),
                    onChanged: (value) {
                      setState((){
                        selectedFuelTypeId = value;
                        selectedFuelTypeName = fuelTypesProvider.fuelType
                          .firstWhere((c) => c.idFuelType.toString() == value)
                          .fuelTypeName;

                          if (value == null) {
                            vehicleColorsProviders.loadVehiclesColors();
                          }
                      });
                    },
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.local_gas_station, color: AppStyle.primary),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: const BorderSide(color: AppStyle.primary, width: 1.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: const BorderSide(color: AppStyle.primary, width: 1.0),
                      ),
                    ),
                  );
                },
              ),
              // color
              Consumer<VehiclesColorsProvider>(
                builder: (context, vehiclesColorsProvider,_){
                  return DropdownButtonFormField<String>(
                    value: selectedVehicleColorId,
                    hint: Text(S.of(context).color),
                    items: vehiclesColorsProvider.colors.map((color){
                     return DropdownMenuItem<String>( 
                      value: color.idColor.toString(),
                      child: Text(color.colorName ?? 'N/A'),
                     ) ;
                    }).toList(),
                    onChanged: (value) {
                      setState((){
                        selectedVehicleColorId = value;
                        selectedVehicleColorName = vehiclesColorsProvider.colors
                          .firstWhere((c) => c.idColor.toString() == value)
                          .colorName;
                      });
                    },
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.color_lens, color: AppStyle.primary),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: const BorderSide(color: AppStyle.primary, width: 1.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: const BorderSide(color: AppStyle.primary, width: 1.0),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),
              // brands
              Consumer<BrandProvider>(
                builder: (context, brandsProvider,_){
                  return DropdownButtonFormField<String>(
                    value: selectedVehicleBrandId,
                    hint: Text(S.of(context).brand),
                    items:  brandsProvider.brands.map((brand){
                     return DropdownMenuItem<String>( 
                      value: brand.idBrand.toString(),
                      child: Text(brand.brandName ?? 'N/A'),
                     ) ;
                    }).toList(),
                    onChanged: (value){
                      setState((){
                        selectedVehicleBrandId = value;
                        selectedVehicleBrandName = brandsProvider.brands
                          .firstWhere((c) => c.idBrand.toString() == value)
                          .brandName;
                          // resetar los modelos

                          selectedVehicleModelId = null;
                          selectedVehicleModelName = null;

                          if(value != null){
                            vehicleModelsProviders.loadModelsByBrand(int.parse(value));
                          }
                      });
                    },
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.directions_car, color: AppStyle.primary),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: const BorderSide(color: AppStyle.primary, width: 1.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: const BorderSide(color: AppStyle.primary, width: 1.0),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),
              Consumer<ModelProvider>(
                builder:(context, modelProvider,_ ){
                  return DropdownButtonFormField<String>(
                    value: selectedVehicleModelId,
                    hint: Text(S.of(context).model),
                    items: modelProvider.models.map((model){
                      return DropdownMenuItem<String>( 
                        value: model.idModel.toString(),
                        child: Text(model.modelName ?? 'N/A'),
                      ) ;
                    }).toList(),
                    onChanged: (value){
                      setState((){
                        selectedVehicleModelId = value;
                        selectedVehicleModelName = modelProvider.models
                          .firstWhere((c) => c.idModel.toString() == value)
                          .modelName;
                      });
                    },
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.directions_car, color: AppStyle.primary),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: const BorderSide(color: AppStyle.primary, width: 1.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: const BorderSide(color: AppStyle.primary, width: 1.0),
                      ),
                    ),
                  );
                }
              ),
              Consumer<VehicleTypeProvider>(
                builder: (context, vehicleTypesProvider,_){
                  return DropdownButtonFormField<String>(
                    value: selectedVehiclesTypeId,
                    hint: Text(S.of(context).vehicleType),
                    items: vehicleTypesProvider.vehiclesType.map((type){
                     return DropdownMenuItem<String>( 
                      value: type.idVehiclesType.toString(),
                      child: Text(type.vehiclesTypesName ?? 'N/A'),
                     ) ;
                    }).toList(),
                    onChanged: (value) {
                      setState((){
                        selectedVehiclesTypeId = value;
                        selectedVehiclesTypeName = vehicleTypesProvider.vehiclesType
                          .firstWhere((c) => c.idVehiclesType.toString() == value)
                          .vehiclesTypesName;


                          
                      });
                    },
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.directions_car, color: AppStyle.primary),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: const BorderSide(color: AppStyle.primary, width: 1.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: const BorderSide(color: AppStyle.primary, width: 1.0),
                      ),
                    ),
                  );
                }
              ),
              const SizedBox(height: 16),
              Consumer<CountryProvider>(
                builder: (context, countryProvider,_){
                  return DropdownButtonFormField<String>(
                    value: selectedVehiclesCountryId,
                    hint: Text(S.of(context).country),
                    items: countryProvider.countries.map((country){
                     return DropdownMenuItem<String>( 
                      value: country.idCountry.toString(),
                      child: Text(country.countryName ?? 'N/A'),
                     ) ;
                    }).toList(),
                    onChanged: (value) {
                      setState((){
                        selectedVehiclesCountryId = value;
                        selectedVehiclesCountryName = countryProvider.countries
                          .firstWhere((c) => c.idCountry.toString() == value)
                          .countryName;

                          // resetear las ciudades
                          selectedVehiclesCityId = null;
                          selectedVehiclesCityName = null;

                          if(value != null){
                            vehicleCityProvider.loadCitiesByCountry(int.parse(value));
                          }
                      });
                    },
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.public, color: AppStyle.primary),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: const BorderSide(color: AppStyle.primary, width: 1.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: const BorderSide(color: AppStyle.primary, width: 1.0),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),
              Consumer<CityProvider>(
                builder: (context, cityProvider,_){
                  return DropdownButtonFormField<String>(
                    value: selectedVehiclesCityId,
                    hint: Text(S.of(context).city),
                    items: cityProvider.cities.map((city){
                     return DropdownMenuItem<String>( 
                      value: city.idCity.toString(),
                      child: Text(city.cityName ?? 'N/A'),
                     ) ;
                    }).toList(),
                    onChanged: (value) {
                      setState((){
                        selectedVehiclesCityId = value;
                        selectedVehiclesCityName = cityProvider.cities
                          .firstWhere((c) => c.idCity.toString() == value)
                          .cityName;
                      });
                    },
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.location_city, color: AppStyle.primary),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: const BorderSide(color: AppStyle.primary, width: 1.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: const BorderSide(color: AppStyle.primary, width: 1.0),
                      ),
                    ),
                  );
                }
              ),
            ],
          );
        },
      ),
    ),
    negativeText: S.of(context).cancel,
 positiveOnPressed: () async {
      if (vehiclePlateController.text.isNotEmpty && selectedFuelTypeId != null) {
        // Obtener el personId del UserProvider aquí
        final userProvider = Provider.of<UserProvider>(context, listen: false);
        final personId = userProvider.personId ?? 0;
        
        await provider.addVehicle(
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
          personId, // Pasar el personId aquí
        );
        Navigator.of(context, rootNavigator: true).pop();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Todos los campos son requeridos")),
        );
      }
    },
    positiveText: S.of(context).add,
    title: S.of(context).addVehicle
  );
}