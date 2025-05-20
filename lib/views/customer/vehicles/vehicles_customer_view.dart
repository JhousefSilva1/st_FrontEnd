import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:smarttolls/generated/l10n.dart';
import 'package:smarttolls/providers/customer/vehicle_customer_provider.dart';
import 'package:smarttolls/providers/providers.dart';
import 'package:smarttolls/style/app_style.dart';
import 'package:smarttolls/widgets/customer/vehicles_customer_card.dart';
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
          centerTitle: true,
          text: S.of(context).myVehicles,
        ),
        backgroundColor: AppStyle.white,
        drawer: isMobile ? const SmartTollsDrawer() : null,
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