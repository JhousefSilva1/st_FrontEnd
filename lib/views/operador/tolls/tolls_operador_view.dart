import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
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


class ManualMjpegViewer extends StatefulWidget {
  final String url;

  const ManualMjpegViewer({super.key, required this.url});

  @override
  _ManualMjpegViewerState createState() => _ManualMjpegViewerState();
}

class _ManualMjpegViewerState extends State<ManualMjpegViewer> {
  late http.Client client;
  late StreamController<Image> _imageController;

  @override
  void initState() {
    super.initState();
    client = http.Client();
    _imageController = StreamController<Image>();
    _startStream();
  }

void _startStream() async {
  try {
    final request = http.Request('GET', Uri.parse(widget.url));
    final response = await client.send(request);
    final stream = response.stream;

    List<int> buffer = [];

    await for (var chunk in stream) {
      buffer.addAll(chunk);

      while (true) {
        final start = _findMarker(buffer, [0xFF, 0xD8]);
        final end = _findMarker(buffer, [0xFF, 0xD9]);

        if (start != -1 && end != -1 && end > start) {
          final imageBytes = buffer.sublist(start, end + 2);
          buffer = buffer.sublist(end + 2);

          final image = Image.memory(
            Uint8List.fromList(imageBytes),
            gaplessPlayback: true, //
            fit: BoxFit.cover,
          );

          _imageController.add(image);

          // 💤 Evita saturar el renderizado
          await Future.delayed(const Duration(milliseconds: 33)); // ~30 fps
        } else {
          break;
        }
      }
    }
  } catch (e) {
    print("Error en MJPEG stream: $e");
  }
}


  int _findMarker(List<int> data, List<int> marker) {
    for (int i = 0; i < data.length - marker.length + 1; i++) {
      bool match = true;
      for (int j = 0; j < marker.length; j++) {
        if (data[i + j] != marker[j]) {
          match = false;
          break;
        }
      }
      if (match) return i;
    }
    return -1;
  }

  @override
  void dispose() {
    client.close();
    _imageController.close();
    super.dispose();
  }

Image? _lastImage;

@override
Widget build(BuildContext context) {
  return StreamBuilder<Image>(
    stream: _imageController.stream,
    builder: (context, snapshot) {
      if (snapshot.hasData) {
        _lastImage = snapshot.data;
      }

      if (_lastImage != null) {
        return AspectRatio(
          aspectRatio: 16 / 9,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: _lastImage!,
          ),
        );
      } else {
        return const Center(child: CircularProgressIndicator());
      }
    },
  );
}
}



class TollsOperadorView extends StatelessWidget {
  static const String routerName = 'tollsOperador';
  static const String routerPath = '/tollsOperador';

  const TollsOperadorView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyle.white,
      body: ResponsiveBreakpoints.of(context).smallerThan(TABLET)
          ? const MobileLayout()
          : const DesktopLayout(),
    );
  }
}

class MobileLayout extends StatelessWidget {
  const MobileLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        centerTitle: true,
        text: S.of(context).tollsOperator,
      ),
      drawer: const SmartTollsMobileDrawer(),
      body: const TollOperatorContent(isMobile: true),
    );
  }
}

class DesktopLayout extends StatelessWidget {
  const DesktopLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        SmartTollsOperadorDrawer(),
        Expanded(
          child: Scaffold(
            body: TollOperatorContent(isMobile: false),
          ),
        ),
      ],
    );
  }
}

class TollOperatorContent extends StatefulWidget {
  final bool isMobile;

  const TollOperatorContent({super.key, required this.isMobile});

  @override
  State<TollOperatorContent> createState() => _TollOperatorContentState();
}

class _TollOperatorContentState extends State<TollOperatorContent> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<TollsOperadorProvider>(context, listen: false).loadCountries();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isMobile) {
      return SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const LocationFilterSection(),
            const SizedBox(height: 24),
            const VideoStreamWithOCR(),
            const SizedBox(height: 24),
            const TollSelectionSection(),
            const SizedBox(height: 24),
            const VehicleSearchSection(),
            const SizedBox(height: 24),
            const VehicleInfoSection(),
            const SizedBox(height: 24),
            _buildActionButtons(),
          ],
        ),
      );
    }

    // Layout para escritorio con dos columnas
return Padding(
  padding: const EdgeInsets.all(24),
  child: Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      // Columna izquierda: video más ancho
      const Expanded(
        flex: 2, // Aumentamos el tamaño del video
        child: Column(
          children: [
            VideoStreamWithOCR(),
          ],
        ),
      ),
      const SizedBox(width: 24),
      // Columna derecha: formularios más angostos
      Expanded(
        flex: 1, // Reducimos el tamaño de los formularios
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const LocationFilterSection(),
              const SizedBox(height: 24),
              const TollSelectionSection(),
              const SizedBox(height: 24),
              const VehicleSearchSection(),
              const SizedBox(height: 24),
              const VehicleInfoSection(),
              const SizedBox(height: 24),
              _buildActionButtons(),
            ],
          ),
        ),
      ),
    ],
  ),
);
  }

Widget _buildActionButtons() {
  return Consumer<TollsOperadorProvider>(
    builder: (context, provider, _) {
      if (provider.isLoading) {
        return const Center(child: CircularProgressIndicator());
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
        // if (false) const SizedBox.shrink(), // nunca se ejecutará

          const SizedBox(height: 16),
          ElevatedButton.icon(
            icon: const Icon(Icons.clear),
            label: const Text('Limpiar formulario'),
            onPressed: () {
              provider.clearAllFields();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.grey[300],
              foregroundColor: Colors.black,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      );
    },
  );
}


  Future<void> _processPayment(BuildContext context, TollsOperadorProvider provider) async {
    final success = await provider.chargeTollFee(context);

    if (success) {
      _showPaymentSuccessDialog(context, provider);
    } else {
      _showPaymentErrorDialog(context, provider);
    }
  }

  void _showPaymentSuccessDialog(BuildContext context, TollsOperadorProvider provider) {
    showDialog(
      context: context,
      builder: (context) => PaymentSuccessDialog(
        plate: provider.selectedVehicle?.licensePlate ?? '',
        amount: provider.tollChargeAmount,
      ),
    );
  }

  void _showPaymentErrorDialog(BuildContext context, TollsOperadorProvider provider) {
    showDialog(
      context: context,
      builder: (context) => PaymentErrorDialog(
        errorMessage: provider.errorMessage ?? 'Error desconocido',
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
  bool _isProcessing = false;
  String? _lastProcessedPlate;

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
    if (_isProcessing) return;

    try {
      _isProcessing = true;
      final provider = Provider.of<TollsOperadorProvider>(context, listen: false);

      final response = await http.get(Uri.parse('http://192.168.0.10:5000/last_plate'));
      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        final rawPlate = body['plate']?.toString().trim() ?? '';
        final plate = rawPlate.replaceAll(' ', '');

        if (plate.isNotEmpty && plate != _lastProcessedPlate) {
          _lastProcessedPlate = plate;

          // 🔍 Validación: campos obligatorios seleccionados
          final missing = <String>[];
          if (provider.selectedCountryId == null) missing.add("país");
          if (provider.selectedCityId == null) missing.add("ciudad");
          if (provider.selectedPlaceId == null) missing.add("lugar");
          if (provider.selectedToll == null) missing.add("peaje");

          if (missing.isNotEmpty) {
            _showAutoDialog(
              title: 'Faltan datos',
              message: 'Selecciona: ${missing.join(', ')}',
              isSuccess: false,
            );
            return;
          }

          provider.setLicensePlateQuery(plate);
          await provider.searchVehicleByLicensePlate();
          if (provider.foundVehicles.isEmpty) {
            _showAutoDialog(
              title: 'Vehículo no encontrado',
              message: 'No se encontró ningún vehículo con la placa: $plate',
              isSuccess: false,
            );
            return;
          }


          if (provider.foundVehicles.isNotEmpty) {
            await provider.selectVehicle(provider.foundVehicles.first);

            if (provider.vehicleWallet != null) {
              final success = await provider.chargeTollFee(context);

              if (success) {
                _showAutoDialog(
                  title: '¡Pago exitoso!',
                  message: 'Placa: $plate\nMonto: Bs. ${provider.tollChargeAmount.toStringAsFixed(2)}',
                  isSuccess: true,
                );
                
              } else {
                _showAutoDialog(
                  title: 'Error de pago',
                  message: provider.errorMessage ?? 'Ocurrió un error desconocido.',
                  isSuccess: false,
                );
              }
            }
          }
        }
      }
    } catch (e) {
      debugPrint('Error en polling: $e');
    } finally {
      _isProcessing = false;
    }
  });
}


void _showAutoDialog({required String title, required String message, bool isSuccess = false}) {
  if (!mounted) return; // ✅ Evita usar un context destruido

  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (ctx) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      backgroundColor: Colors.white,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isSuccess ? Icons.check_circle : Icons.error,
            color: isSuccess ? Colors.green : Colors.red,
            size: 60,
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: isSuccess ? Colors.green : Colors.red,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
    ),
  );

  Future.delayed(const Duration(seconds: 3), () {
    if (mounted && Navigator.canPop(context)) {
      Navigator.of(context).pop();
    }
  });
}


  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: AspectRatio(
        aspectRatio: 16/9,
        child: Stack(
          children: [
          const ManualMjpegViewer(url: 'http://192.168.0.10:5000/video'),

            Positioned(
              bottom: 8,
              left: 8,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.videocam, color: Colors.white, size: 16),
                    SizedBox(width: 4),
                    Text(
                      'Sistema de reconocimiento activo',
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
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
            Text(
              'Ubicación',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            _buildCountryDropdown(provider),
            const SizedBox(height: 12),
            _buildCityDropdown(provider),
            const SizedBox(height: 12),
            _buildPlaceDropdown(provider),
          ],
        ),
      ),
    );
  }

  Widget _buildCountryDropdown(TollsOperadorProvider provider) {
    return DropdownButtonFormField<int>(
      decoration: const InputDecoration(
        labelText: 'País',
        border: OutlineInputBorder(),
      ),
      value: provider.selectedCountryId,
      items: provider.countries.map((e) => DropdownMenuItem(
        value: e.idCountry,
        child: Text(e.countryName ?? 'Desconocido'),
      )).toList(),
      onChanged: (int? value) {
        if (value != null) {
          provider.loadCitiesByCountry(value);
        }
      },
    );
  }

  Widget _buildCityDropdown(TollsOperadorProvider provider) {
    return DropdownButtonFormField<int>(
      decoration: const InputDecoration(
        labelText: 'Ciudad',
        border: OutlineInputBorder(),
      ),
      value: provider.selectedCityId,
      items: provider.cities.map((e) => DropdownMenuItem(
        value: e.idCity,
        child: Text(e.cityName ?? 'Desconocido'),
      )).toList(),
      onChanged: (int? value) {
        if (value != null) {
          provider.loadPlacesByCity(value);
        }
      },
    );
  }

  Widget _buildPlaceDropdown(TollsOperadorProvider provider) {
    return DropdownButtonFormField<int>(
      decoration: const InputDecoration(
        labelText: 'Lugar',
        border: OutlineInputBorder(),
      ),
      value: provider.selectedPlaceId,
      items: provider.places.map((e) => DropdownMenuItem(
        value: e.idPlaces,
        child: Text(e.placeName ?? 'Desconocido'),
      )).toList(),
      onChanged: (int? value) {
        if (value != null) {
          provider.selectPlace(value);
        }
      },
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Selección de peaje',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<StTollsResponse>(
              isExpanded: true,
              decoration: const InputDecoration(
                labelText: 'Peaje',
                border: OutlineInputBorder(),
              ),
              value: provider.selectedToll,
              items: provider.tolls.map((t) => DropdownMenuItem(
                value: t,
                child: Text(t.tollsName ?? 'Peaje desconocido'),
              )).toList(),
              onChanged: provider.selectToll,
            ),
          ],
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

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Búsqueda de vehículo',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            TextFormField(
              readOnly: true,
              controller: TextEditingController(text: provider.licensePlateQuery),
              decoration: InputDecoration(
                labelText: 'Placa detectada',
                border: const OutlineInputBorder(),
                suffixIcon: provider.isLoading
                    ? const Padding(
                        padding: EdgeInsets.all(12),
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : null,
              ),
            ),
          ],
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
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Información del vehículo',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            _buildInfoRow('Placa:', vehicle.licensePlate ?? 'N/A'),
            _buildInfoRow('Modelo:', vehicle.vehiclesModels.modelName ?? 'N/A'),
            _buildInfoRow('Año:', vehicle.manufacturingYear?.toString() ?? 'N/A'),
            const Divider(height: 24),
            _buildInfoRow(
              'Saldo disponible:',
              'Bs. ${wallet.balance?.toStringAsFixed(2) ?? '0.00'}',
              isAmount: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, {bool isAmount = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(width: 8),
          Text(
            value,
            style: isAmount
                ? TextStyle(
                    color: (double.tryParse(value.replaceAll('Bs. ', '')) ?? 0) >= 5
                        ? Colors.green
                        : Colors.red,
                    fontWeight: FontWeight.bold,
                  )
                : null,
          ),
        ],
      ),
    );
  }
}

class PaymentButton extends StatelessWidget {
  final double amount;
  final VoidCallback onPressed;

  const PaymentButton({
    super.key,
    required this.amount,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppStyle.primaryColor,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      onPressed: onPressed,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Cobrar Bs. ${amount.toStringAsFixed(2)}',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 8),
          const Icon(Icons.payment, color: Colors.white),
        ],
      ),
    );
  }
}

class PaymentSuccessDialog extends StatelessWidget {
  final String plate;
  final double amount;

  const PaymentSuccessDialog({
    super.key,
    required this.plate,
    required this.amount,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.check_circle,
              color: Colors.green,
              size: 60,
            ),
            const SizedBox(height: 16),
            Text(
              'Pago exitoso',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Colors.green,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildDetailRow('Placa:', plate),
            _buildDetailRow('Monto:', 'Bs. ${amount.toStringAsFixed(2)}'),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Aceptar'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(value),
        ],
      ),
    );
  }
}

class PaymentErrorDialog extends StatelessWidget {
  final String errorMessage;

  const PaymentErrorDialog({
    super.key,
    required this.errorMessage,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.error,
              color: Colors.red,
              size: 60,
            ),
            const SizedBox(height: 16),
            Text(
              'Error en el pago',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              errorMessage,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Aceptar'),
            ),
          ],
        ),
      ),
    );
  }
}

class ErrorMessageCard extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const ErrorMessageCard({
    super.key,
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.red[50],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            const Icon(Icons.error, color: Colors.red),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: TextStyle(color: Colors.red[800]),
              ),
            ),
            TextButton(
              onPressed: onRetry,
              child: const Text('Reintentar'),
            ),
          ],
        ),
      ),
    );
  }
}
