import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:smarttolls/generated/l10n.dart';
import 'package:smarttolls/providers/providers.dart';
import 'package:smarttolls/providers/customer/vehicle_customer_provider.dart';
import 'package:smarttolls/style/app_style.dart';
import 'package:smarttolls/utils/utils.dart';
import 'package:smarttolls/widgets/widgets.dart';

class AddVehicleCustomerView extends StatefulWidget {
  static const String routerName = 'addVehicleCustomer';
  static const String routerPath = '/addVehicleCustomer';

  const AddVehicleCustomerView({super.key});

  @override
  State<AddVehicleCustomerView> createState() => _AddVehicleCustomerViewState();
}

class _AddVehicleCustomerViewState extends State<AddVehicleCustomerView> {
  final _formKey = GlobalKey<FormState>();
  final _plateController = TextEditingController();
  final _chassisController = TextEditingController();
  final _engineController = TextEditingController();
  final _yearController = TextEditingController();
  final _weightController = TextEditingController();

  String? _selectedFuelTypeId;
  String? _selectedColorId;
  String? _selectedBrandId;
  String? _selectedModelId;
  String? _selectedTypeId;
  String? _selectedCountryId;
  String? _selectedCityId;

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  void _loadInitialData() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final fuelProvider = Provider.of<FuelTypeProvider>(context, listen: false);
      final colorsProvider = Provider.of<VehiclesColorsProvider>(context, listen: false);
      final brandsProvider = Provider.of<BrandProvider>(context, listen: false);
      final typesProvider = Provider.of<VehicleTypeProvider>(context, listen: false);
      final countriesProvider = Provider.of<CountryProvider>(context, listen: false);

      fuelProvider.loadFuelTypes();
      colorsProvider.loadVehiclesColors();
      brandsProvider.loadBrands();
      typesProvider.loadVehicleTypes();
      countriesProvider.loadCountries();
    });
  }

  @override
  void dispose() {
    _plateController.dispose();
    _chassisController.dispose();
    _engineController.dispose();
    _yearController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveBreakpoints.of(context).smallerThan(TABLET);
    
    return Scaffold(
      appBar: CustomAppBar(
        centerTitle: true,
        text: S.of(context).addVehicle,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppStyle.primary),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: isMobile 
                ? _buildMobileForm()
                : _buildTabletForm(),
          ),
        ),
      ),
      bottomNavigationBar: _buildSubmitButton(),
    );
  }

  Widget _buildMobileForm() {
    return Column(
      children: [
        _buildPlateField(),
        const SizedBox(height: 16),
        _buildChassisField(),
        const SizedBox(height: 16),
        _buildEngineField(),
        const SizedBox(height: 16),
        _buildYearField(),
        const SizedBox(height: 16),
        _buildWeightField(),
        const SizedBox(height: 16),
        _buildFuelTypeDropdown(),
        const SizedBox(height: 16),
        _buildColorDropdown(),
        const SizedBox(height: 16),
        _buildBrandDropdown(),
        const SizedBox(height: 16),
        _buildModelDropdown(),
        const SizedBox(height: 16),
        _buildTypeDropdown(),
        const SizedBox(height: 16),
        _buildCountryDropdown(),
        const SizedBox(height: 16),
        _buildCityDropdown(),
        const SizedBox(height: 32),
      ],
    );
  }

  Widget _buildTabletForm() {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: _buildPlateField()),
            const SizedBox(width: 16),
            Expanded(child: _buildChassisField()),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: _buildEngineField()),
            const SizedBox(width: 16),
            Expanded(child: _buildYearField()),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: _buildWeightField()),
            const SizedBox(width: 16),
            Expanded(child: _buildFuelTypeDropdown()),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: _buildColorDropdown()),
            const SizedBox(width: 16),
            Expanded(child: _buildBrandDropdown()),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: _buildModelDropdown()),
            const SizedBox(width: 16),
            Expanded(child: _buildTypeDropdown()),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: _buildCountryDropdown()),
            const SizedBox(width: 16),
            Expanded(child: _buildCityDropdown()),
          ],
        ),
        const SizedBox(height: 32),
      ],
    );
  }

  Widget _buildPlateField() {
    return CustomField(
      controller: _plateController,
      hintText: S.of(context).plate,
      keyboardType: TextInputType.text,
      prefixIcon: const Icon(Icons.car_crash, color: AppStyle.primary),
      validator: (value) => value?.isEmpty ?? true ? 'Ingrese la matrícula' : null,
    );
  }

  Widget _buildChassisField() {
    return CustomField(
      controller: _chassisController,
      hintText: S.of(context).chassisNumber,
      keyboardType: TextInputType.text,
      prefixIcon: const Icon(Icons.confirmation_number, color: AppStyle.primary),
      validator: (value) => value?.isEmpty ?? true ? 'Ingrese el número de chasis' : null,
    );
  }

  Widget _buildEngineField() {
    return CustomField(
      controller: _engineController,
      hintText: S.of(context).engineNumber,
      keyboardType: TextInputType.text,
      prefixIcon: const Icon(Icons.engineering, color: AppStyle.primary),
      validator: (value) => value?.isEmpty ?? true ? 'Ingrese el número de motor' : null,
    );
  }

  Widget _buildYearField() {
    return CustomField(
      controller: _yearController,
      hintText: S.of(context).manufacturingYear,
      keyboardType: TextInputType.number,
      prefixIcon: const Icon(Icons.calendar_today, color: AppStyle.primary),
      validator: (value) => value?.isEmpty ?? true ? 'Ingrese el año de fabricación' : null,
    );
  }

  Widget _buildWeightField() {
    return CustomField(
      controller: _weightController,
      hintText: S.of(context).weight,
      keyboardType: TextInputType.number,
      prefixIcon: const Icon(Icons.monitor_weight, color: AppStyle.primary),
      validator: (value) => value?.isEmpty ?? true ? 'Ingrese el peso del vehículo' : null,
    );
  }

  Widget _buildFuelTypeDropdown() {
    return Consumer<FuelTypeProvider>(
      builder: (context, provider, _) {
        return DropdownButtonFormField<String>(
          value: _selectedFuelTypeId,
          hint: Text(S.of(context).fuelType),
          items: provider.fuelTypes.map((fuel) {
            return DropdownMenuItem(
              value: fuel.idFuelType.toString(),
              child: Text(fuel.fuelTypeName ?? 'N/A'),
            );
          }).toList(),
          onChanged: (value) {
            setState(() => _selectedFuelTypeId = value);
          },
          decoration: _dropdownDecoration(Icons.local_gas_station),
          validator: (value) => value == null ? 'Seleccione un tipo de combustible' : null,
        );
      },
    );
  }

  Widget _buildColorDropdown() {
    return Consumer<VehiclesColorsProvider>(
      builder: (context, provider, _) {
        return DropdownButtonFormField<String>(
          value: _selectedColorId,
          hint: Text(S.of(context).color),
          items: provider.colors.map((color) {
            return DropdownMenuItem(
              value: color.idColor.toString(),
              child: Text(color.colorName ?? 'N/A'),
            );
          }).toList(),
          onChanged: (value) {
            setState(() => _selectedColorId = value);
          },
          decoration: _dropdownDecoration(Icons.color_lens),
          validator: (value) => value == null ? 'Seleccione un color' : null,
        );
      },
    );
  }

  Widget _buildBrandDropdown() {
    return Consumer<BrandProvider>(
      builder: (context, provider, _) {
        return DropdownButtonFormField<String>(
          value: _selectedBrandId,
          hint: Text(S.of(context).brand),
          items: provider.brands.map((brand) {
            return DropdownMenuItem(
              value: brand.idBrand.toString(),
              child: Text(brand.brandName ?? 'N/A'),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              _selectedBrandId = value;
              _selectedModelId = null; // Reset model when brand changes
              if (value != null) {
                Provider.of<ModelProvider>(context, listen: false)
                  .loadModelsByBrand(int.parse(value));
              }
            });
          },
          decoration: _dropdownDecoration(Icons.directions_car),
          validator: (value) => value == null ? 'Seleccione una marca' : null,
        );
      },
    );
  }

  Widget _buildModelDropdown() {
    return Consumer<ModelProvider>(
      builder: (context, provider, _) {
        return DropdownButtonFormField<String>(
          value: _selectedModelId,
          hint: Text(S.of(context).model),
          items: provider.models.map((model) {
            return DropdownMenuItem(
              value: model.idModel.toString(),
              child: Text(model.modelName ?? 'N/A'),
            );
          }).toList(),
          onChanged: (value) {
            setState(() => _selectedModelId = value);
          },
          decoration: _dropdownDecoration(Icons.directions_car),
          validator: (value) => value == null ? 'Seleccione un modelo' : null,
        );
      },
    );
  }

  Widget _buildTypeDropdown() {
    return Consumer<VehicleTypeProvider>(
      builder: (context, provider, _) {
        return DropdownButtonFormField<String>(
          value: _selectedTypeId,
          hint: Text(S.of(context).vehicleType),
          items: provider.vehicleTypes.map((type) {
            return DropdownMenuItem(
              value: type.idVehiclesType.toString(),
              child: Text(type.vehiclesTypesName ?? 'N/A'),
            );
          }).toList(),
          onChanged: (value) {
            setState(() => _selectedTypeId = value);
          },
          decoration: _dropdownDecoration(Icons.directions_car),
          validator: (value) => value == null ? 'Seleccione un tipo de vehículo' : null,
        );
      },
    );
  }

  Widget _buildCountryDropdown() {
    return Consumer<CountryProvider>(
      builder: (context, provider, _) {
        return DropdownButtonFormField<String>(
          value: _selectedCountryId,
          hint: Text(S.of(context).country),
          items: provider.countries.map((country) {
            return DropdownMenuItem(
              value: country.idCountry.toString(),
              child: Text(country.countryName ?? 'N/A'),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              _selectedCountryId = value;
              _selectedCityId = null; // Reset city when country changes
              if (value != null) {
                Provider.of<CityProvider>(context, listen: false)
                  .loadCitiesByCountry(int.parse(value));
              }
            });
          },
          decoration: _dropdownDecoration(Icons.public),
          validator: (value) => value == null ? 'Seleccione un país' : null,
        );
      },
    );
  }

  Widget _buildCityDropdown() {
    return Consumer<CityProvider>(
      builder: (context, provider, _) {
        return DropdownButtonFormField<String>(
          value: _selectedCityId,
          hint: Text(S.of(context).city),
          items: provider.cities.map((city) {
            return DropdownMenuItem(
              value: city.idCity.toString(),
              child: Text(city.cityName ?? 'N/A'),
            );
          }).toList(),
          onChanged: (value) {
            setState(() => _selectedCityId = value);
          },
          decoration: _dropdownDecoration(Icons.location_city),
          validator: (value) => value == null ? 'Seleccione una ciudad' : null,
        );
      },
    );
  }

  InputDecoration _dropdownDecoration(IconData icon) {
    return InputDecoration(
      prefixIcon: Icon(icon, color: AppStyle.primary),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: const BorderSide(color: AppStyle.primary, width: 1.0),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: const BorderSide(color: AppStyle.primary, width: 1.0),
      ),
    );
  }

  Widget _buildSubmitButton() {
    final provider = Provider.of<VehiclesCustomerProvider>(context);
    
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ElevatedButton(
        onPressed: provider.isLoading ? null : _submitForm,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppStyle.primary,
          minimumSize: const Size(double.infinity, 50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: provider.isLoading
            ? const CircularProgressIndicator(color: Colors.white)
            : Text(
                S.of(context).addVehicle,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
      ),
    );
  }

  void _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final personId = userProvider.personId;
    
    if (personId == null || personId == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("No se pudo identificar al usuario"),
            behavior: SnackBarBehavior.floating,
          ),
        );
      return;
    }

    final vehicleProvider = Provider.of<VehiclesCustomerProvider>(context, listen: false);
    
    try {
      await vehicleProvider.addVehicle(
        _plateController.text,
        _chassisController.text,
        _engineController.text,
        _yearController.text,
        _weightController.text,
        int.parse(_selectedFuelTypeId!),
        int.parse(_selectedColorId!),
        int.parse(_selectedModelId!),
        int.parse(_selectedTypeId!),
        int.parse(_selectedBrandId!),
        int.parse(_selectedCityId!),
        int.parse(_selectedCountryId!),
        personId,
      );

      // Si todo sale bien, regresamos a la vista anterior
      if (mounted) {
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Error al agregar vehículo: ${e.toString()}"),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }
}