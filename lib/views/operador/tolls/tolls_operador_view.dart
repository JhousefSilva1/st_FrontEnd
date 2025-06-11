import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:smarttolls/api/api.dart';
import 'package:smarttolls/widgets/widgets.dart';
import 'package:smarttolls/generated/l10n.dart';
import 'package:smarttolls/style/app_style.dart';
import 'package:smarttolls/widgets/menu/desktop/drawer_operador.dart';
import 'package:smarttolls/widgets/menu/mobile/drawerMobile.dart';

import '../../../providers/operador/tolls_operador_provider.dart';

class TollsOperadorView extends StatefulWidget {
  static const String routerName = 'tollsOperador';
  static const String routerPath = '/tollsOperador';

  const TollsOperadorView({super.key});

  @override
  State<TollsOperadorView> createState() => _TollsOperadorViewState();
}

class _TollsOperadorViewState extends State<TollsOperadorView> with WidgetsBindingObserver {
  CameraController? _controller;
  List<CameraDescription>? _cameras;
  bool _isCameraInitialized = false;
  bool _hasCameraPermission = false;
  XFile? _capturedImage;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _checkCameraPermission();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller?.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (_controller == null || !_controller!.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      _controller?.dispose();
    } else if (state == AppLifecycleState.resumed) {
      if (_controller != null) {
        _initializeCamera(_controller!.description);
      }
    }
  }

  Future<void> _checkCameraPermission() async {
    final status = await Permission.camera.request();
    setState(() {
      _hasCameraPermission = status.isGranted;
    });
    
    if (_hasCameraPermission) {
      _initializeCamera();
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Se necesitan permisos de cámara para usar esta función')),
        );
      }
    }
  }

  Future<void> _initializeCamera([CameraDescription? camera]) async {
    try {
      _cameras = await availableCameras();
      
      if (_cameras == null || _cameras!.isEmpty) {
        setState(() => _isCameraInitialized = false);
        return;
      }

      final cameraToUse = camera ?? _cameras!.first;
      
      _controller = CameraController(
        cameraToUse,
        ResolutionPreset.high,
        enableAudio: false,
      );

      await _controller!.initialize();
      
      if (!mounted) return;
      
      setState(() => _isCameraInitialized = true);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al inicializar cámara: ${e.toString()}')),
        );
      }
      setState(() => _isCameraInitialized = false);
    }
  }

  Future<void> _takePicture() async {
    if (!_isCameraInitialized || _controller == null) return;
    
    try {
      final image = await _controller!.takePicture();
      setState(() => _capturedImage = image);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Foto tomada con éxito')),
        );
        
        // Procesar imagen para lectura de matrícula
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al tomar foto: ${e.toString()}')),
        );
      }
    }
  }

  Widget _buildCameraSection(BuildContext context) {
    if (!_hasCameraPermission) {
      return _buildCameraPermissionRequest();
    }
    
    if (!_isCameraInitialized) {
      return _buildCameraLoading();
    }
    
    return _buildCameraPreview();
  }

  Widget _buildCameraPermissionRequest() {
    return Column(
      children: [
        const Icon(Icons.camera_alt, size: 64),
        const SizedBox(height: 16),
        const Text('Se necesitan permisos de cámara', style: TextStyle(fontSize: 16)),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: _checkCameraPermission,
          child: const Text('Solicitar permisos'),
        ),
      ],
    );
  }

  Widget _buildCameraLoading() {
    return Column(
      children: [
        const CircularProgressIndicator(),
        const SizedBox(height: 16),
        const Text('Inicializando cámara...', style: TextStyle(fontSize: 16)),
        if (_cameras == null || _cameras!.isEmpty)
          const Text('No se encontraron cámaras disponibles'),
      ],
    );
  }

  Widget _buildCameraPreview() {
    return Column(
      children: [
        Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Cámara para lectura de placa',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const Divider(height: 24),
                AspectRatio(
                  aspectRatio: _controller!.value.aspectRatio,
                  child: CameraPreview(_controller!),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton.icon(
                      icon: const Icon(Icons.camera_alt),
                      label: const Text('Tomar foto'),
                      onPressed: _takePicture,
                    ),
                    const SizedBox(width: 16),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.qr_code_scanner),
                      label: const Text('Escanear QR'),
                      onPressed: () {
                        // Lógica de escaneo QR
                      },
                    ),
                  ],
                ),
                if (_capturedImage != null) ...[
                  const SizedBox(height: 16),
                  Text(
                    'Imagen capturada: ${_capturedImage!.path.split('/').last}',
                    style: const TextStyle(fontStyle: FontStyle.italic),
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }

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
                  children: [
                    TextButton.icon(
                      onPressed: () => provider.clearAllFields(),
                      icon: const Icon(Icons.refresh),
                      label: const Text('Limpiar todo'),
                    ),
                    const LocationFilterSection(),
                    const SizedBox(height: 24),
                    _buildCameraSection(context),
                    const SizedBox(height: 24),
                    const TollSelectionSection(),
                    const SizedBox(height: 24),
                    const VehicleSearchSection(),
                    const SizedBox(height: 24),
                    const VehicleInfoSection(),
                    const SizedBox(height: 24),
                    const ChargeButton(),
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
                      children: [
                        TextButton.icon(
                          onPressed: () => provider.clearAllFields(),
                          icon: const Icon(Icons.refresh),
                          label: const Text('Limpiar todo'),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 7,
                              child: Column(
                                children: [
                                  _buildCameraSection(context),
                                  const SizedBox(height: 16),
                                  Card(
                                    child: Padding(
                                      padding: const EdgeInsets.all(16),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          const Text('IDs para Transacción:', 
                                            style: TextStyle(fontWeight: FontWeight.bold)),
                                          const SizedBox(height: 8),
                                          Consumer<TollsOperadorProvider>(
                                            builder: (context, provider, _) {
                                              return Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  if (provider.selectedVehicle != null)
                                                    Text('Vehículo ID: ${provider.selectedVehicle?.idVehicle}'),
                                                  if (provider.selectedToll != null)
                                                    Text('Peaje ID: ${provider.selectedToll?.idTolls}'),
                                                  if (provider.vehicleWallet != null)
                                                    Text('Wallet ID: ${provider.vehicleWallet?.idWallet}'),
                                                  const SizedBox(height: 8),
                                                  Text('Monto a cobrar: Bs. ${provider.tollChargeAmount.toStringAsFixed(2)}',
                                                    style: const TextStyle(fontWeight: FontWeight.bold)),
                                                ],
                                              );
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 24),
                            Expanded(
                              flex: 3,
                              child: Column(
                                children: [
                                  const LocationFilterSection(),
                                  const SizedBox(height: 24),
                                  const TollSelectionSection(),
                                  const SizedBox(height: 24),
                                  const VehicleSearchSection(),
                                  const SizedBox(height: 24),
                                  const VehicleInfoSection(),
                                  const SizedBox(height: 24),
                                  const ChargeButton(),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
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
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Filtrar por ubicación',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Divider(height: 24),
            
            // Dropdown de Países
            DropdownButtonFormField<int>(
              value: provider.selectedCountryId,
              hint: Text('Seleccione país'),
              items: provider.countries.map((country) {
                return DropdownMenuItem<int>(
                  value: country.idCountry,
                  child: Text(country.countryName ?? 'N/A'),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  provider.loadCitiesByCountry(value);
                }
              },
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.flag),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 16),
            
            // Dropdown de Ciudades
            DropdownButtonFormField<int>(
              value: provider.selectedCityId,
              hint: Text('Seleccione ciudad'),
              items: provider.cities.map((city) {
                return DropdownMenuItem<int>(
                  value: city.idCity,
                  child: Text(city.cityName ?? 'N/A'),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  provider.loadPlacesByCity(value);
                }
              },
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.location_city),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 16),
            
            // Dropdown de Lugares
            DropdownButtonFormField<int>(
              value: provider.selectedPlaceId,
              hint: Text('Seleccione lugar'),
              items: provider.places.map((place) {
                return DropdownMenuItem<int>(
                  value: place.idPlaces,
                  child: Text(place.placeName ?? 'N/A'),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  provider.selectPlace(value);
                }
              },
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.place),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
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
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              S.of(context).selectToll,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Divider(height: 24),
            provider.isLoading && provider.tolls.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: DropdownButton<StTollsResponse>(
                      value: provider.selectedToll,
                      isExpanded: true,
                      underline: const SizedBox(),
                      items: provider.tolls.map((toll) {
                        return DropdownMenuItem<StTollsResponse>(
                          value: toll,
                          child: Text(
                            toll.tollsName ?? 'Peaje sin nombre',
                            style: const TextStyle(fontSize: 16),
                          ),
                        );
                      }).toList(),
                      onChanged: (toll) {
                        provider.selectToll(toll);
                      },
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}


class VehicleSearchSection extends StatefulWidget {
  const VehicleSearchSection({super.key});

  @override
  State<VehicleSearchSection> createState() => _VehicleSearchSectionState();
}

class _VehicleSearchSectionState extends State<VehicleSearchSection> {
  late TextEditingController _licensePlateController;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    final provider = Provider.of<TollsOperadorProvider>(context, listen: false);
    _licensePlateController = TextEditingController(text: provider.licensePlateQuery);
  }

  @override
  void dispose() {
    _licensePlateController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TollsOperadorProvider>(context);

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              S.of(context).enterLicensePlate,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Divider(height: 24),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _licensePlateController,
                    focusNode: _focusNode,
                    decoration: InputDecoration(
                      hintText: S.of(context).licensePlate,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onSubmitted: (value) async {
                      provider.setLicensePlateQuery(value);
                      await provider.searchVehicleByLicensePlate();

                      if (!mounted) return;

                      if (provider.foundVehicles.isNotEmpty) {
                        await provider.selectVehicle(provider.foundVehicles.first);
                      }

                      if (!mounted) return;

                      final vehicle = provider.selectedVehicle;
                      final wallet = provider.vehicleWallet;
                      final amount = provider.tollChargeAmount;

                      if (vehicle != null && wallet != null) {
                        if ((wallet.balance ?? 0) < amount) {
                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (_) => const AlertDialog(
                              title: Text('Saldo insuficiente'),
                              content: Text('El vehículo no tiene saldo suficiente para pagar el peaje.'),
                            ),
                          );
                          await Future.delayed(const Duration(seconds: 3));
                          if (context.mounted) Navigator.pop(context);
                        } else {
                          final success = await provider.chargeTollFee(context);
                          if (!mounted) return;

                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (_) => AlertDialog(
                              title: Text(success ? 'Cobro exitoso' : 'Error'),
                              content: Text(success
                                  ? 'Se cobró correctamente Bs. ${amount.toStringAsFixed(2)}'
                                  : (provider.errorMessage ?? 'No se pudo procesar el cobro')),
                            ),
                          );
                          await Future.delayed(const Duration(seconds: 3));
                          if (context.mounted) Navigator.pop(context);
                        }
                      } else if (provider.errorMessage != null) {
                        showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                            title: const Text('Error'),
                            content: Text(provider.errorMessage!),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('Cerrar'),
                              ),
                            ],
                          ),
                        );
                      }
                    },
                  ),
                ),
              ],
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

    if (provider.selectedVehicle == null || provider.vehicleWallet == null) {
      return Container();
    }

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              S.of(context).vehicleInfo,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Divider(height: 24),
            _buildInfoRow(S.of(context).licensePlate, provider.selectedVehicle?.licensePlate ?? 'N/A'),
            const SizedBox(height: 12),
            _buildInfoRow(S.of(context).model, provider.selectedVehicle?.vehiclesModels.modelName ?? 'N/A'),
            const SizedBox(height: 12),
            _buildInfoRow(S.of(context).balance, 
              'Bs. ${provider.vehicleWallet?.balance?.toStringAsFixed(2) ?? '0.00'}'),
            const SizedBox(height: 12),
            _buildInfoRow(S.of(context).tollCharge, 
              'Bs. ${provider.tollChargeAmount.toStringAsFixed(2)}',
              valueStyle: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
            if ((provider.vehicleWallet?.balance ?? 0) < provider.tollChargeAmount)
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Text(
                  S.of(context).insufficientBalance,
                  style: const TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, {TextStyle? valueStyle}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 100,
          child: Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.grey[600],
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            value,
            style: valueStyle ?? const TextStyle(fontSize: 16),
          ),
        ),
      ],
    );
  }
}

class ChargeButton extends StatelessWidget {
  const ChargeButton({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TollsOperadorProvider>(context);

    if (provider.selectedVehicle == null || provider.vehicleWallet == null) {
      return Container();
    }

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          backgroundColor: AppStyle.primary, // Color primario de tu app
        ),
        onPressed: (provider.isLoading || (provider.vehicleWallet?.balance ?? 0) < provider.tollChargeAmount)
            ? null
            : () => _processPayment(context, provider),
        child: provider.isLoading
            ? const CircularProgressIndicator(color: Colors.white)
            : Text(
                'COBRAR Bs. ${provider.tollChargeAmount.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
      ),
    );
  }

  Future<void> _processPayment(BuildContext context, TollsOperadorProvider provider) async {
    // Mostrar diálogo de confirmación
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar cobro'),
        content: Text(
          '¿Confirmar cobro de Bs. ${provider.tollChargeAmount.toStringAsFixed(2)} '
          'al vehículo ${provider.selectedVehicle?.licensePlate}?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppStyle.primary,
            ),
            child: const Text('Confirmar', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    // Procesar el pago
    final success = await provider.chargeTollFee(context);

    if (success && context.mounted) {
      // Mostrar mensaje de éxito
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Cobro exitoso: Bs. ${provider.tollChargeAmount.toStringAsFixed(2)}'),
          backgroundColor: Colors.green,
        ),
      );
    } else if (!success && context.mounted) {
      // Mostrar mensaje de error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(provider.errorMessage ?? 'Error en el cobro'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}