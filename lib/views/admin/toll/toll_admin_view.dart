import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:smarttolls/generated/l10n.dart';
import 'package:smarttolls/style/app_style.dart';
import 'package:smarttolls/utils/utils.dart';
import 'package:smarttolls/widgets/widgets.dart';

import '../../../api/api.dart';
import '../../../models/models.dart';
import '../../../providers/providers.dart';

class TollAdminView extends StatelessWidget {
  static const String routerName = 'tollAdmin';
  static const String routerPath = '/tollAdmin';

  const TollAdminView({super.key});

  @override
  Widget build(BuildContext context) {
    bool isMobile = ResponsiveBreakpoints.of(context).smallerThan(TABLET);
    
    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBar(
          actions: [
            IconButton(
              onPressed: () => showAddTollDialog(context),
              icon: const Icon(Icons.add_rounded, color: AppStyle.primary, size: 30),
            )
          ],
          centerTitle: true,
          text: S.of(context).tolls,
        ),
        backgroundColor: AppStyle.white,
        body: isMobile
            ? SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      const TollAdminList(),
                    ],
                  ),
                ),
              )
            : const TollAdminTabletView(),
      ),
    );
  }
}

class TollAdminTabletView extends StatelessWidget {
  const TollAdminTabletView({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const SmartTollsDrawer(),
        Expanded(
          flex: 2,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const TollAdminList(),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class TollAdminList extends StatefulWidget {
  const TollAdminList({super.key});

  @override
  State<TollAdminList> createState() => _TollAdminListState();
}

class _TollAdminListState extends State<TollAdminList> {
  @override
  void initState() {
    super.initState();
    _loadTolls();
  }

  void _loadTolls() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<TollProvider>(context, listen: false);
      provider.loadAllTolls();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TollProvider>(context);

    return Column(
      children: [
        CustomField(
          hintText: S.of(context).search,
          prefixIcon: const Icon(Icons.search, color: AppStyle.primary),
          onChanged: (value) {
            provider.searchTolls(value);
          },
        ),
        const SizedBox(height: 16),

        if(provider.isLoading && provider.tolls.isEmpty)
          const Padding(
            padding: EdgeInsets.all(16),
            child: CircularProgressIndicator(color: AppStyle.primary, strokeWidth: 2.5),
          ),

        if(provider.errorMessage != null)
          Column(
            children: [
              Text(
                provider.errorMessage!,
                style: const TextStyle(
                  fontSize: 16,
                  color: AppStyle.red,
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: provider.retryLoading,
                child: Text(
                  S.of(context).retry,
                  style: const TextStyle(
                    fontSize: 16,
                    color: AppStyle.white,
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),

        if(!provider.isLoading && provider.tolls.isEmpty && provider.errorMessage == null)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 32),
            child: Text(
              'No Hay Peajes Registrados',
              style: const TextStyle(
                fontSize: 16,
                color: AppStyle.primary,
              ),
            ),
          ),
        
        if(provider.tolls.isNotEmpty)
          ListView.separated(
            itemCount: provider.tolls.length,
            itemBuilder: (context, index) {
              final toll = provider.tolls[index];
              return TollCard(toll: toll);
            },
            physics: const NeverScrollableScrollPhysics(),
            primary: false,
            shrinkWrap: true,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
          ),
      ],
    );
  }
}

void showAddTollDialog(BuildContext context) {
  final tollNameController = TextEditingController();
  final provider = Provider.of<TollProvider>(context, listen: false);
  
  // Variables para los selectores
  int? selectedCountryId;
  int? selectedCityId;
  int? selectedPlaceId;
  List<StCityResponse> cities = [];
  List<StPlaceResponse> places = [];

  // Cargar países inicialmente
  final countryProvider = Provider.of<CountryProvider>(context, listen: false);
  final cityProvider = Provider.of<CityProvider>(context, listen: false);
  final placeProvider = Provider.of<PlaceProvider>(context, listen: false);

  // Pre-cargar países antes de mostrar el diálogo
  final countriesFuture = countryProvider.loadCountries();

  Utils.textFieldAlert(
    context: context,
    content: FutureBuilder(
      future: countriesFuture,
      builder: (context, countriesSnapshot) {
        if (countriesSnapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomField(
                    controller: tollNameController,
                    hintText: S.of(context).tollName,
                    keyboardType: TextInputType.text,
                    prefixIcon: const Icon(Icons.route, color: AppStyle.primary),
                  ),
                  const SizedBox(height: 16),
                  
                  // Selector de País
                  DropdownButtonFormField<int>(
                    decoration: InputDecoration(
                      labelText: S.of(context).country,
                      prefixIcon: const Icon(Icons.flag, color: AppStyle.primary),
                    ),
                    value: selectedCountryId,
                    items: countryProvider.countries.map((country) {
                      return DropdownMenuItem<int>(
                        value: country.idCountry,
                        child: Text(country.countryName ?? 'Sin nombre'),
                      );
                    }).toList(),
                    onChanged: (value) async {
                      setState(() {
                        selectedCountryId = value;
                        selectedCityId = null;
                        selectedPlaceId = null;
                        cities = [];
                        places = [];
                      });
                      
                      // Cargar ciudades fuera del setState
                      if (value != null) {
                        await cityProvider.loadCitiesByCountry(value);
                        setState(() {
                          cities = cityProvider.cities;
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 16),
                  
                  // Selector de Ciudad
                  if (selectedCountryId != null)
                    DropdownButtonFormField<int>(
                      decoration: InputDecoration(
                        labelText: S.of(context).city,
                        prefixIcon: const Icon(Icons.location_city, color: AppStyle.primary),
                      ),
                      value: selectedCityId,
                      items: cities.map((city) {
                        return DropdownMenuItem<int>(
                          value: city.idCity,
                          child: Text(city.cityName ?? 'Sin nombre'),
                        );
                      }).toList(),
                      onChanged: (value) async {
                        setState(() {
                          selectedCityId = value;
                          selectedPlaceId = null;
                          places = [];
                        });
                        
                        // Cargar lugares fuera del setState
                        if (value != null) {
                          await placeProvider.loadPlacesByCity(value);
                          setState(() {
                            places = placeProvider.places;
                          });
                        }
                      },
                    ),
                  const SizedBox(height: 16),
                  
                  // Selector de Lugar
                  if (selectedCityId != null)
                    DropdownButtonFormField<int>(
                      decoration: InputDecoration(
                        labelText: S.of(context).place,
                        prefixIcon: const Icon(Icons.place, color: AppStyle.primary),
                      ),
                      value: selectedPlaceId,
                      items: places.map((place) {
                        return DropdownMenuItem<int>(
                          value: place.idPlaces,
                          child: Text(place.placeName ?? 'Sin nombre'),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedPlaceId = value;
                        });
                      },
                    ),
                ],
              ),
            );
          },
        );
      },
    ),
    negativeText: S.of(context).cancel,
    positiveOnPressed: () async {
      if (tollNameController.text.isNotEmpty && selectedPlaceId != null) {
        await provider.addToll(tollNameController.text, selectedPlaceId!);
        Navigator.of(context, rootNavigator: true).pop();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Complete todos los campos requeridos')),
        );
      }
    },
    positiveText: S.of(context).add,
    title: S.of(context).addToll,
  );
}