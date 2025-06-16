
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:smarttolls/generated/l10n.dart';
import 'package:smarttolls/providers/providers.dart';
import 'package:smarttolls/style/app_style.dart';
import 'package:smarttolls/widgets/menu/desktop/drawer.dart';


import '../../../providers/customer/vehicle_customer_provider.dart';

class HomeView extends StatelessWidget {
  static const String routerName = 'home';
  static const String routerPath = '/home';
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    bool isMobile = ResponsiveBreakpoints.of(context).smallerThan(TABLET);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppStyle.primary.withOpacity(0.1),
                  border: Border.all(color: AppStyle.primary, width: 2),
                ),
                child: const Icon(
                  Icons.verified_user,
                  size: 30,
                  color: Colors.blueAccent,
                ),
              ),
              const SizedBox(width: 12),
              Consumer<UserProvider>(
                builder: (context, userProvider, child) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${userProvider.name ?? ''}',
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '${userProvider.lastName ?? ''}',
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
        // drawer: isMobile ? const SmartTollsMobileDrawer() : null,
        backgroundColor: AppStyle.ligthGrey,
        body: isMobile
            ? const SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    children: [HomeMobileView()],
                  ),
                ),
              )
            : const HomeTabletView(),
      ),
    );
  }
}

class HomeMobileView extends StatelessWidget {
  const HomeMobileView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        HomeDashboard()
      ],
    );
  }
}

class HomeTabletView extends StatelessWidget {
  const HomeTabletView({super.key});

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
                  HomeDashboard()
                ],
              ),
            ),
          ),
        )
      ],
    );
  }
}

class HomeDashboard extends StatelessWidget {
  const HomeDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final walletProvider = Provider.of<WalletProvider>(context, listen: false);
    final vehiclesProvider = Provider.of<VehiclesCustomerProvider>(context, listen: false);

    // Cargar datos al iniciar
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final personId = userProvider.personId;
      if (personId != null) {
        vehiclesProvider.loadCustomerVehicles(personId);
        walletProvider.loadUserVehicles();
      }
    });

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: AppStyle.white, width: 1),
            borderRadius: const BorderRadius.all(Radius.circular(8)),
            color: AppStyle.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 4,
                spreadRadius: 1
              ),
            ]
          ),
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 8.0),
            child: Text(
              S.of(context).welcomeMessage,
              
              style: const TextStyle(
                color: AppStyle.primary,
                fontSize: 24,
                fontWeight: FontWeight.w700
              ),
              textAlign: TextAlign.center
            ),
          ),
        ),
        const SizedBox(height: 16),
        Consumer<VehiclesCustomerProvider>(
          builder: (context, vehiclesProvider, child) {
            final vehicleCount = vehiclesProvider.vehicles.length;
            return Row(
              children: [
                Expanded(
                  flex: 2,
                  child: HomeCard(
                    data: vehicleCount.toString(),
                    icon: const Icon(Icons.directions_car, color: AppStyle.primary, size: 30),
                    title: S.of(context).registeredVehicles,
                    subtitle: S.of(context).vehiclesCount(vehicleCount),
                  ),
                ),
                const SizedBox(width: 16),
                Consumer<WalletProvider>(
                  builder: (context, walletProvider, child) {
                    final transactionCount = walletProvider.transactions.length;
                    return Expanded(
                      flex: 2,
                      child: HomeCard(
                        data: transactionCount.toString(),
                        icon: const Icon(Icons.receipt, color: AppStyle.primary, size: 30),
                        title: S.of(context).recentTransactions,
                        subtitle: S.of(context).last30Days,
                      ),
                    );
                  },
                ),
              ],
            );
          },
        ),
        const SizedBox(height: 16),
        Row(
          children: [

            const SizedBox(width: 16),
            Consumer<WalletProvider>(
              builder: (context, walletProvider, child) {
                final balance = walletProvider.selectedVehicleWallet?.balance ?? 0;
                return Expanded(
                  flex: 2,
                  child: HomeCard(
                    data: 'Bs. ${balance.toStringAsFixed(2)}',
                    icon: const Icon(Icons.account_balance_wallet, color: AppStyle.primary, size: 30),
                    title: S.of(context).walletBalance,
                    subtitle: S.of(context).currentBalance,
                  ),
                );
              },
            ),
          ],
        ),
        const SizedBox(height: 24),
        Consumer<WalletProvider>(
          builder: (context, walletProvider, child) {
            final transactions = walletProvider.transactions;
            return Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    S.of(context).recentActivity,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppStyle.primary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (transactions.isEmpty)
                    const Text('No hay transacciones recientes')
                  else
                    SizedBox(
                      height: 200,
                      child: ListView.builder(
                        itemCount: transactions.length > 5 ? 5 : transactions.length,
                        itemBuilder: (context, index) {
                          final transaction = transactions[index];
                          return ListTile(
                            leading: const Icon(Icons.attach_money, color: AppStyle.primary),
                            title: Text('Peaje ${transaction.tollName}'),
                            subtitle: Text((transaction.transactionDate ?? 'Fecha no disponible').toString()),
                            trailing: Text('-Bs. ${transaction.amount?.toStringAsFixed(2) ?? '0.00'}'),
                          );
                        },
                      ),
                    ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}

class HomeCard extends StatelessWidget {
  const HomeCard({
    super.key,
    required this.data,
    required this.icon,
    required this.title,
    this.subtitle = '',
  });
  
  final String data;
  final Widget icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: AppStyle.white, width: 1),
        borderRadius: const BorderRadius.all(Radius.circular(8)),
        color: AppStyle.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            spreadRadius: 1
          ),
        ]
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            icon,
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    data,
                    style: const TextStyle(
                      color: AppStyle.primary,
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  if (subtitle.isNotEmpty)
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 12.0,
                        color: Colors.grey[600],
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}