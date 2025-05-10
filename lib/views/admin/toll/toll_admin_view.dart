import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:smarttolls/generated/l10n.dart';
import 'package:smarttolls/style/app_style.dart';
import 'package:smarttolls/utils/utils.dart';
import 'package:smarttolls/widgets/widgets.dart';

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
                      TollAdminList(),
                    ],
                  ),
                ),
              )
            : TollAdminTabletView(),
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
                  TollAdminList(),
                ],
              ),
            ),
          )
        )
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
                child: Text(S.of(context).retry,
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
            child: Text('No Hay Peajes',
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
          )
      ],
    );
  }
}

void showAddTollDialog(BuildContext context) {
  final tollNameController = TextEditingController();
  final provider = Provider.of<TollProvider>(context, listen: false);
  final countryProvider = Provider.of<CountryProvider>(context, listen: false);
  final cityProvider = Provider.of<CityProvider>(context, listen: false);
  final placeProvider = Provider.of<PlaceProvider>(context, listen: false);

  // Inicializar valores si es necesario
  String? selectedCountry;
  String? selectedCity;
  String? selectedPlace;
  int? selectedCountryId;
  int? selectedCityId;
  int? selectedPlaceId;

  Utils.textFieldAlert(
    context: context,
    content: SingleChildScrollView( // <-- Envuelve el contenido en un SingleChildScrollView
      child: StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return Column(
            mainAxisSize: MainAxisSize.min, // <-- Importante mantener mainAxisSize.min
            children: [
              CustomField(
                controller: tollNameController,
                hintText: S.of(context).tollName,
                keyboardType: TextInputType.text,
                prefixIcon: const Icon(Icons.route, color: AppStyle.primary),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese el nombre del peaje';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: selectedCountry,
                hint: Text(S.of(context).selectCountry),
                items: countryProvider.countries.map((country) {
                  return DropdownMenuItem<String>(
                    value: country.idCountry.toString(),
                    child: Text(country.countryName ?? 'N/A'),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedCountry = value;
                    selectedCountryId = int.tryParse(value ?? '0');
                    selectedCity = null;
                    selectedCityId = null;
                    selectedPlace = null;
                    selectedPlaceId = null;
                    if (selectedCountryId != null) {
                      cityProvider.loadCitiesByCountry(selectedCountryId!);
                    }
                  });
                },
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.flag, color: AppStyle.primary),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: selectedCity,
                hint: Text(S.of(context).selectCity),
                items: cityProvider.cities.map((city) {
                  return DropdownMenuItem<String>(
                    value: city.idCity.toString(),
                    child: Text(city.cityName ?? 'N/A'),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedCity = value;
                    selectedCityId = int.tryParse(value ?? '0');
                    selectedPlace = null;
                    selectedPlaceId = null;
                    if (selectedCityId != null) {
                      placeProvider.loadPlacesByCity(selectedCityId!);
                    }
                  });
                },
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.location_city, color: AppStyle.primary),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: selectedPlace,
                hint: Text(S.of(context).selectPlace),
                items: placeProvider.places.map((place) {
                  return DropdownMenuItem<String>(
                    value: place.idPlaces.toString(),
                    child: Text(place.placeName ?? 'N/A'),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedPlace = value;
                    selectedPlaceId = int.tryParse(value ?? '0');
                  });
                },
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.place, color: AppStyle.primary),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    ),
    negativeText: S.of(context).cancel,
    positiveOnPressed: () async {
      if (tollNameController.text.isNotEmpty && selectedPlaceId != null) {
        await provider.addToll(tollNameController.text, selectedPlaceId!);
        Navigator.of(context, rootNavigator: true).pop();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Todos los campos son requeridos')),
        );
      }
    },
    positiveText: S.of(context).add,
    title: S.of(context).addToll,
  );
}