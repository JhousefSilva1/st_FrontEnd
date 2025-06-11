import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:smarttolls/providers/operador/tolls_operador_provider.dart';

class VideoStreamWithOCR extends StatefulWidget {
  const VideoStreamWithOCR({super.key});

  @override
  State<VideoStreamWithOCR> createState() => _VideoStreamWithOCRState();
}

class _VideoStreamWithOCRState extends State<VideoStreamWithOCR> {
  Timer? _pollingTimer;
  String? _lastPlate;
  bool _isFetching = false;

  final String streamUrl = 'http://192.168.0.10:5000/video';      // Tu Raspberry IP
  final String plateUrl = 'http://192.168.0.10:5000/last_plate'; // Tu endpoint Flask

  @override
  void initState() {
    super.initState();
    _startPolling();
  }

  @override
  void dispose() {
    _pollingTimer?.cancel();
    super.dispose();
  }

  void _startPolling() {
    _pollingTimer = Timer.periodic(const Duration(seconds: 3), (_) async {
      if (_isFetching) return;
      _isFetching = true;

      try {
        final response = await http.get(Uri.parse(plateUrl));
        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          final newPlate = data['plate'];

          if (newPlate != null && newPlate.isNotEmpty && newPlate != _lastPlate) {
            setState(() {
              _lastPlate = newPlate;
            });

            final provider = Provider.of<TollsOperadorProvider>(context, listen: false);
            provider.setLicensePlateQuery(newPlate);

            // Busca automáticamente el vehículo
            await provider.searchVehicleByLicensePlate();

            if (provider.foundVehicles.isNotEmpty) {
              await provider.selectVehicle(provider.foundVehicles.first);
            }
          }
        }
      } catch (e) {
        debugPrint('Error al obtener matrícula: $e');
      } finally {
        _isFetching = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          'Reconocimiento automático de placas',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        AspectRatio(
          aspectRatio: 640 / 480,
          child: Image.network(
            streamUrl,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) {
              return const Center(child: Text('Error al cargar el video.'));
            },
          ),
        ),
        const SizedBox(height: 8),
        if (_lastPlate != null)
          Text('Última placa detectada: $_lastPlate', style: const TextStyle(fontStyle: FontStyle.italic)),
      ],
    );
  }
}
