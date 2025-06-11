// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:http/http.dart' as http;
import 'package:smarttolls/api/api.dart';
import 'package:smarttolls/generated/l10n.dart';
import 'package:smarttolls/providers/operador/tolls_operador_provider.dart';
import 'package:smarttolls/style/app_style.dart';
import 'package:smarttolls/widgets/menu/desktop/drawer_operador.dart';
import 'package:smarttolls/widgets/menu/mobile/drawerMobile.dart';
import 'package:smarttolls/widgets/widgets.dart';

class TollsOperadorView extends StatelessWidget {
  static const String routerName = 'tollsOperador';
  static const String routerPath = '/tollsOperador';

  const TollsOperadorView({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isMobile = ResponsiveBreakpoints.of(context).smallerThan(TABLET);
    final provider = Provider.of<TollsOperadorProvider>(context, listen: false);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      provider.loadCountries();
    });

    return Scaffold(
      backgroundColor: AppStyle.white,
      appBar: isMobile
          ? CustomAppBar(centerTitle: true, text: S.of(context).tollsOperator)
          : null,
      drawer: isMobile ? const SmartTollsMobileDrawer() : null,
      body: isMobile
          ? SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: const [
                    LocationFilterSection(),
                    SizedBox(height: 24),
                    VideoStreamWithOCR(),
                    SizedBox(height: 24),
                    TollSelectionSection(),
                    SizedBox(height: 24),
                    VehicleSearchSection(),
                    SizedBox(height: 24),
                    VehicleInfoSection(),
                  ],
                ),
              ),
            )
          : Row(
              children: [
                const SmartTollsOperadorDrawer(),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        LocationFilterSection(),
                        SizedBox(height: 24),
                        VideoStreamWithOCR(),
                        SizedBox(height: 24),
                        TollSelectionSection(),
                        SizedBox(height: 24),
                        VehicleSearchSection(),
                        SizedBox(height: 24),
                        VehicleInfoSection(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}

class VideoStreamWithOCR extends StatefulWidget {
  const VideoStreamWithOCR({super.key});

  @override
  State<VideoStreamWithOCR> createState() => _VideoStreamWithOCRState();
}

class _VideoStreamWithOCRState extends State<VideoStreamWithOCR> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startPolling();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startPolling() {
    _timer = Timer.periodic(const Duration(seconds: 2), (_) async {
      try {
        final response = await http.get(Uri.parse('http://192.168.0.10:5000/last_plate'));
        if (response.statusCode == 200) {
          final body = jsonDecode(response.body);
          final plate = body['plate']?.toString().trim() ?? '';
          if (plate.isNotEmpty) {
            final provider = Provider.of<TollsOperadorProvider>(context, listen: false);
            if (provider.licensePlateQuery != plate) {
              provider.setLicensePlateQuery(plate);
              await provider.searchVehicleByLicensePlate();
              if (provider.foundVehicles.isNotEmpty) {
                await provider.selectVehicle(provider.foundVehicles.first);

                final wallet = provider.vehicleWallet;
                final amount = provider.tollChargeAmount;

                if (wallet != null && amount <= (wallet.balance ?? 0) && provider.selectedToll != null) {
                  await provider.chargeTollFee(context);
                  provider.setLicensePlateQuery('');
                }
              }
            }
          }
        }
      } catch (_) {}
    });
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Image.network(
        'http://192.168.0.10:5000/video',
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => const Center(child: Text('No se pudo cargar el video')),
      ),
    );
  }
}

class LocationFilterSection extends StatelessWidget {
  const LocationFilterSection({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TollsOperadorProvider>(context);

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Ubicación', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            DropdownButtonFormField<int>(
              decoration: const InputDecoration(labelText: 'País'),
              value: provider.selectedCountryId,
              items: provider.countries.map((e) => DropdownMenuItem(value: e.idCountry, child: Text(e.countryName ?? ''))).toList(),
              onChanged: (int? value) {
                if (value != null) {
                  provider.loadCitiesByCountry(value);
                }
              },
            ),
            DropdownButtonFormField<int>(
              decoration: const InputDecoration(labelText: 'Ciudad'),
              value: provider.selectedCityId,
              items: provider.cities.map((e) => DropdownMenuItem(value: e.idCity, child: Text(e.cityName ?? ''))).toList(),
              onChanged: (int? value) {
                if (value != null) {
                  provider.loadPlacesByCity(value);
                }
              },
            ),
            DropdownButtonFormField<int>(
              decoration: const InputDecoration(labelText: 'Lugar'),
              value: provider.selectedPlaceId,
              items: provider.places.map((e) => DropdownMenuItem(value: e.idPlaces, child: Text(e.placeName ?? ''))).toList(),
              onChanged: (int? value) {
                if (value != null) {
                  provider.selectPlace(value);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

class TollSelectionSection extends StatelessWidget {
  const TollSelectionSection({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TollsOperadorProvider>(context);

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: DropdownButtonFormField(
          isExpanded: true,
          decoration: const InputDecoration(labelText: 'Peaje'),
          value: provider.selectedToll,
          items: provider.tolls.map((t) => DropdownMenuItem(value: t, child: Text(t.tollsName ?? ''))).toList(),
          onChanged: provider.selectToll,
        ),
      ),
    );
  }
}

class VehicleSearchSection extends StatelessWidget {
  const VehicleSearchSection({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TollsOperadorProvider>(context);
    final controller = TextEditingController(text: provider.licensePlateQuery);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: TextField(
          controller: controller,
          readOnly: true,
          decoration: const InputDecoration(
            labelText: 'Placa detectada',
            border: OutlineInputBorder(),
          ),
        ),
      ),
    );
  }
}

class VehicleInfoSection extends StatelessWidget {
  const VehicleInfoSection({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TollsOperadorProvider>(context);
    final vehicle = provider.selectedVehicle;
    final wallet = provider.vehicleWallet;

    if (vehicle == null || wallet == null) return const SizedBox();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Vehículo: ${vehicle.licensePlate ?? 'N/A'}'),
            Text('Modelo: ${vehicle.vehiclesModels.modelName ?? 'N/A'}'),
            Text('Saldo: Bs. ${wallet.balance?.toStringAsFixed(2) ?? '0.00'}'),
          ],
        ),
      ),
    );
  }
}


class ChargeButton extends StatelessWidget {
  const ChargeButton({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TollsOperadorProvider>(context);
    final wallet = provider.vehicleWallet;
    final amount = provider.tollChargeAmount;

    if (wallet == null || provider.selectedVehicle == null || provider.selectedToll == null) {
      return const SizedBox();
    }

    return Center(
      child: ElevatedButton.icon(
        onPressed: () async {
          if ((wallet.balance ?? 0) < amount) {
            showDialog(
              context: context,
              builder: (_) => const AlertDialog(
                title: Text('Saldo insuficiente'),
                content: Text('El vehículo no tiene saldo suficiente para pagar el peaje.'),
              ),
            );
            return;
          }

          final success = await provider.chargeTollFee(context);

          showDialog(
            context: context,
            builder: (_) => AlertDialog(
              title: Text(success ? 'Cobro exitoso' : 'Error'),
              content: Text(success
                  ? 'Se cobró correctamente Bs. ${amount.toStringAsFixed(2)}'
                  : (provider.errorMessage ?? 'Error al procesar el cobro.')),
            ),
          );
        },
        icon: const Icon(Icons.attach_money),
        label: const Text('Cobrar Peaje'),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
      ),
    );
  }
}
