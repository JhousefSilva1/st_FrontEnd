// city_admin_view.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:smarttolls/generated/l10n.dart';
import 'package:smarttolls/providers/city_provider.dart';
import 'package:smarttolls/style/app_style.dart';
import 'package:smarttolls/utils/utils.dart';
import 'package:smarttolls/widgets/city_card.dart';
import 'package:smarttolls/widgets/custom_app_bar.dart';
import 'package:smarttolls/widgets/custom_field.dart';
import 'package:smarttolls/widgets/menu/desktop/drawer.dart';

class CityAdminView extends StatelessWidget {
  static const String routerName = 'cityAdmin';
  static const String routerPath = '/cityAdmin/:countryId';

  final int countryId;

  const CityAdminView({super.key, required this.countryId});

  @override
  Widget build(BuildContext context) {

    bool isMobile = ResponsiveBreakpoints.of(context).smallerThan(TABLET);

    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBar(
          actions: [
            IconButton(
              onPressed: () => showAddCityDialog(context, countryId),
              icon: const Icon(Icons.add_rounded, color: AppStyle.primary, size: 30),
            )
          ],
          centerTitle: true,
          text: S.of(context).city,
        ),
        backgroundColor: AppStyle.white,
        body: isMobile
            ? SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    children: [
                      CityAdminList(countryId: countryId), // Pasa el countryId aquí
                    ],
                  ),
                ),
              )
            : CityAdminTabletView(countryId: countryId), // Y aquí
      ),
    );
  }
}

class CityAdminTabletView extends StatelessWidget {
    final int countryId;

  const CityAdminTabletView({super.key, required this.countryId});

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
                  CityAdminList(countryId: countryId), // Pasa el countryId aquí
                ],
              ),
            ),
          ),
        )
      ],
    );
  }
}

class CityAdminList extends StatefulWidget {
  final int countryId;

  const CityAdminList({super.key, required this.countryId});


  @override
  State<CityAdminList> createState() => _CityAdminListState();
}

class _CityAdminListState extends State<CityAdminList> {
  @override
  void initState() {
    super.initState();
    _loadCities();
  }

  @override
  void didUpdateWidget(CityAdminList oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.countryId != widget.countryId) {
      _loadCities();
    }
  }

  void _loadCities() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<CityProvider>(context, listen: false);
      provider.loadCitiesByCountry(widget.countryId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CityProvider>();

    return Column(
      children: [
        CustomField(
          hintText: S.of(context).search,
          prefixIcon: const Icon(Icons.search, color: AppStyle.primary),
          onChanged: (value) {
            provider.searchCities(value);
          },
        ),
        const SizedBox(height: 16),
        
        if (provider.isLoading && provider.cities.isEmpty)
          const Padding(
            padding: EdgeInsets.all(16),
            child: CircularProgressIndicator(),
          ),
        
        if (provider.errorMessage != null)
          Column(
            children: [
              Text(
                provider.errorMessage!,
                style: const TextStyle(color: AppStyle.red, fontSize: 16),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: provider.retryLoading,
                child: Text(S.of(context).retry,
                    style: const TextStyle(color: AppStyle.white)),
              ),
              const SizedBox(height: 16),
            ],
          ),
        
        if (!provider.isLoading && provider.cities.isEmpty && provider.errorMessage == null)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 32),
            child: Text('No hay ciudades disponibles',
                style: const TextStyle(color: AppStyle.primary, fontSize: 16)),
          ),
        
        if (provider.cities.isNotEmpty)
          ListView.separated(
            itemCount: provider.cities.length,
            itemBuilder: (context, index) {
              final city = provider.cities[index];
              return CityCard(city: city);
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

void showAddCityDialog(BuildContext context, int countryId) {
  final cityNameController = TextEditingController();
  final provider = Provider.of<CityProvider>(context, listen: false);

  Utils.textFieldAlert(
    context: context,
    content: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CustomField(
          controller: cityNameController,
          hintText: S.of(context).city,
          keyboardType: TextInputType.text,
          prefixIcon: const Icon(Icons.location_city, color: AppStyle.primary),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Por favor ingrese el nombre de la ciudad';
            }
            return null;
          },
        ),
        const SizedBox(height: 10),
      ],
    ),
    negativeText: S.of(context).cancel,
    positiveOnPressed: () async {
      if (cityNameController.text.isNotEmpty) {
        await provider.addCity(cityNameController.text, countryId);
        Navigator.of(context, rootNavigator: true).pop();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('El nombre de la ciudad es requerido')),
        );
      }
    },
    positiveText: S.of(context).add,
    title: S.of(context).addCity,
  );
}