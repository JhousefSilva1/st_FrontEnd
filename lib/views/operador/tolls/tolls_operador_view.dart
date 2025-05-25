import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
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

class _TollsOperadorViewState extends State<TollsOperadorView> {
  CameraController? _controller;
  List<CameraDescription>? _cameras;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    _cameras = await availableCameras();
    if (_cameras!.isNotEmpty) {
      _controller = CameraController(
        _cameras![0],
        ResolutionPreset.medium,
      );
      await _controller!.initialize();
      if (mounted) {
        setState(() {});
      }
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isMobile = ResponsiveBreakpoints.of(context).smallerThan(TABLET);

    return Scaffold(
      backgroundColor: AppStyle.white,
      appBar: isMobile
          ? CustomAppBar(
              centerTitle: true,
              text: S.of(context).tollsOperator,
            )
          : null,
      drawer: isMobile ? const SmartTollsMobileDrawer() : null,
      body: isMobile
          ? const SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: TollsOperadorMobileView(),
              ),
            )
          : const TollsOperadorTabletView(),
    );
  }
}

class TollsOperadorMobileView extends StatelessWidget {
  const TollsOperadorMobileView({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.findAncestorStateOfType<_TollsOperadorViewState>();

    return Column(
      children: [
        // Sección de la cámara
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
                Text(
                  'Cámara para lectura de placa',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Divider(height: 24),
                if (state?._controller != null && state!._controller!.value.isInitialized)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: SizedBox(
                      height: 200,
                      width: double.infinity,
                      child: CameraPreview(state._controller!),
                    ),
                  )
                else
                  Container(
                    height: 200,
                    width: double.infinity,
                    color: Colors.black,
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton.icon(
                      icon: const Icon(Icons.camera_alt),
                      label: const Text('Tomar foto'),
                      onPressed: () {
                        // Lógica para tomar foto
                      },
                    ),
                    const SizedBox(width: 16),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.qr_code_scanner),
                      label: const Text('Escanear QR'),
                      onPressed: () {
                        // Lógica para escanear QR
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),
        const TollSelectionSection(),
        const SizedBox(height: 24),
        const VehicleSearchSection(),
        const SizedBox(height: 24),
        const VehicleInfoSection(),
        const SizedBox(height: 24),
        const ChargeButton(),
      ],
    );
  }
}

class TollsOperadorTabletView extends StatelessWidget {
  const TollsOperadorTabletView({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.findAncestorStateOfType<_TollsOperadorViewState>();

    return Row(
      children: [
        const SmartTollsOperadorDrawer(),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Sección de cámara (70%)
                    Expanded(
                      flex: 7,
                      child: Card(
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
                                'Cámara para lectura de placa',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const Divider(height: 24),
                              if (state?._controller != null && state!._controller!.value.isInitialized)
                                AspectRatio(
                                  aspectRatio: 16/9,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: CameraPreview(state._controller!),
                                  ),
                                )
                              else
                                Container(
                                  height: 200,
                                  color: Colors.black,
                                  child: const Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                ),
                              const SizedBox(height: 16),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ElevatedButton.icon(
                                    icon: const Icon(Icons.camera_alt),
                                    label: const Text('Tomar foto'),
                                    onPressed: () {
                                      // Lógica para tomar foto
                                    },
                                  ),
                                  const SizedBox(width: 16),
                                  ElevatedButton.icon(
                                    icon: const Icon(Icons.qr_code_scanner),
                                    label: const Text('Escanear QR'),
                                    onPressed: () {
                                      // Lógica para escanear QR
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 24),
                    // Sección de controles (30%)
                    Expanded(
                      flex: 3,
                      child: Column(
                        children: [
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
                : provider.errorMessage != null
                    ? Column(
                        children: [
                          Text(
                            provider.errorMessage!,
                            style: const TextStyle(color: Colors.red),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: provider.retryLoading,
                            child: Text(S.of(context).retry),
                          ),
                        ],
                      )
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
                    onChanged: (value) {
                      provider.setLicensePlateQuery(value);
                    },
                  ),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: provider.isLoading ? null : provider.searchVehicleByLicensePlate,
                  child: provider.isLoading 
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(S.of(context).search),
                ),
              ],
            ),
            if (provider.foundVehicles.isNotEmpty) ...[
              const SizedBox(height: 16),
              Text(
                S.of(context).foundVehicles,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              ...provider.foundVehicles.map((vehicle) => Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  title: Text(vehicle.licensePlate ?? ''),
                  subtitle: Text('Modelo: ${vehicle.vehiclesModels.modelName ?? ''}'),
                  trailing: provider.selectedVehicle?.idVehicle == vehicle.idVehicle
                      ? const Icon(Icons.check, color: Colors.green)
                      : null,
                  onTap: () {
                    provider.selectVehicle(vehicle);
                  },
                ),
              )),
            ],
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
        ),
        onPressed: (provider.isLoading || (provider.vehicleWallet?.balance ?? 0) < provider.tollChargeAmount)
            ? null
            : () async {
                final success = await provider.chargeTollFee(context);
                if (success) {
                  // Lógica adicional si es necesario
                }
              },
        child: provider.isLoading
            ? const CircularProgressIndicator()
            : Text(
                S.of(context).charge.toUpperCase(),
                style: const TextStyle(fontSize: 16),
              ),
      ),
    );
  }
}