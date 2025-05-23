import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:smarttolls/api/api.dart';
import 'package:smarttolls/api/response/customer/st_wallet_response.dart';
import 'package:smarttolls/generated/l10n.dart';
import 'package:smarttolls/providers/providers.dart';
import 'package:smarttolls/style/app_style.dart';
import 'package:smarttolls/widgets/widgets.dart';
import 'package:u_credit_card/u_credit_card.dart';

class WalletView extends StatelessWidget {
  static const String routerName = 'wallet';
  static const String routerPath = '/wallet';
  const WalletView({super.key});

  @override
  Widget build(BuildContext context) {
    bool isMobile = ResponsiveBreakpoints.of(context).smallerThan(TABLET);
    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBar(
          centerTitle: true,
          text: S.of(context).wallet,
        ),
        backgroundColor: AppStyle.ligthGrey,
        drawer: isMobile ? const SmartTollsDrawer() : null,
        body: isMobile 
            ? const SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      WalletMobileView()
                    ],
                  ),
                ),
              )
            : const WalletTabletView(),
      ),
    );
  }
}

class WalletMobileView extends StatelessWidget {
  const WalletMobileView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Wallet()
      ],
    );
  }
}

class WalletTabletView extends StatelessWidget {
  const WalletTabletView({super.key});

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
                  Wallet()
                ],
              ),
            ),
          ),
        )
      ],
    );
  }
}

class Wallet extends StatefulWidget {
  const Wallet({super.key});

  @override
  State<Wallet> createState() => _WalletState();
}

class _WalletState extends State<Wallet> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<WalletProvider>(context, listen: false).loadUserVehicles();
    });
  }

  @override
  Widget build(BuildContext context) {
    final walletProvider = Provider.of<WalletProvider>(context);
    
    return Column(
      children: [
        // Vehicle Dropdown
        if (walletProvider.isLoading)
          const Padding(
            padding: EdgeInsets.all(16),
            child: CircularProgressIndicator(color: AppStyle.primary),
          )
        else if (walletProvider.errorMessage != null)
          Column(
            children: [
              Text(
                walletProvider.errorMessage!,
                style: const TextStyle(color: Colors.red),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: walletProvider.retryLoading,
                child: Text(S.of(context).retry),
              ),
            ],
          )
        else if (walletProvider.vehicles.isEmpty)
          Text(
            S.of(context).noVehiclesFound,
            style: const TextStyle(color: Colors.grey),
          )
        else
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: AppStyle.primary),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: DropdownButton<StVehicleResponse>(
                  value: walletProvider.selectedVehicle,
                  isExpanded: true,
                  underline: const SizedBox(),
                  items: walletProvider.vehicles.map((vehicle) {
                    return DropdownMenuItem<StVehicleResponse>(
                      value: vehicle,
                      child: Text(
                        vehicle.licensePlate ?? 'N/A',
                        style: const TextStyle(
                          fontSize: 16,
                          color: AppStyle.primary,
                        ),
                      ),
                    );
                  }).toList(),
                  onChanged: (vehicle) {
                    walletProvider.selectVehicle(vehicle);
                  },
                ),
              ),
            ),
          ),

        // Wallet Card
        if (walletProvider.selectedVehicle != null)
          FutureBuilder<StWalletResponse?>(
            future: _getWalletForVehicle(walletProvider.selectedVehicle!.idVehicle),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Padding(
                  padding: EdgeInsets.all(16),
                  child: CircularProgressIndicator(color: AppStyle.primary),
                );
              } else if (snapshot.hasError) {
                return Text(
                  'Error: ${snapshot.error}',
                  style: const TextStyle(color: Colors.red),
                );
              } else if (snapshot.hasData && snapshot.data != null) {
                return _buildWalletCard(context, snapshot.data!);
              } else {
                return const Padding(
                  padding: EdgeInsets.all(16),
                  child: Text('No se encontró información de la billetera'),
                );
              }
            },
          ),

        const SizedBox(height: 16),
        
        // Transaction History
        _buildTransactionHistoryHeader(context, walletProvider),
        
        const SizedBox(height: 8),
        
        _buildTransactionList(),
      ],
    );
  }

  Future<StWalletResponse?> _getWalletForVehicle(int? vehicleId) async {
    if (vehicleId == null) return null;
    try {
      final response = await SmartTollsApi().getWalletByVehicleId(vehicleId);
      if (response.isSuccess()) {
        return response.data;
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Widget _buildWalletCard(BuildContext context, StWalletResponse wallet) {
    return CreditCardUi(
      autoHideBalance: false,
      balance: wallet.balance ?? 0.0,
      cardHolderFullName: wallet.walletNumber ?? 'N/A',
      cardNumber: wallet.walletNumber ?? '0000000000000000',
      cardType: CardType.debit,
      cvvNumber: wallet.walletCVS ?? '000',
      doesSupportNfc: true,
      enableFlipping: false,
      placeNfcIconAtTheEnd: true,
      showBalance: true,
      showValidFrom: false,
      showValidThru: false,
      topLeftColor: Colors.blue,
      validFrom: '',
      validThru: '',
      width: double.infinity,
      cardProviderLogo: InkWell(
        onTap: () => Provider.of<WalletProvider>(context, listen: false)
            .goToRechargeWallet(context),
        child: const Chip(
          labelStyle: TextStyle(color: AppStyle.primary),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(16)),
            side: BorderSide(color: AppStyle.primary, width: 1),
          ),
          label: Text('Recargar'),
        ),
      ),
    );
  }

  Widget _buildTransactionHistoryHeader(
      BuildContext context, WalletProvider walletProvider) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        children: [
          Expanded(
            child: Text(
              S.of(context).transactionHistory,
              style: const TextStyle(
                color: AppStyle.primary,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          GestureDetector(
            onTap: () => walletProvider.goToTransactionHistory(context),
            child: Text(
              S.of(context).seeAll,
              style: const TextStyle(
                color: AppStyle.primary,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionList() {
    return ListView.separated(
      itemBuilder: (context, index) {
        return Container(
          decoration: BoxDecoration(
            border: Border.all(color: AppStyle.white, width: 1),
            borderRadius: const BorderRadius.all(Radius.circular(8)),
            color: AppStyle.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 4,
                spreadRadius: 1,
              ),
            ],
          ),
          child: Row(
            children: [
              const SizedBox(width: 8),
              CircleAvatar(
                backgroundColor: AppStyle.white,
                radius: 24,
                child: Image.asset('assets/car.jpg', height: 50, width: 50),
              ),
              const SizedBox(width: 8),
              const Expanded(
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Urujsssara',
                            style: TextStyle(
                              color: AppStyle.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Bs. 2',
                          style: TextStyle(
                            color: AppStyle.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(width: 8),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            '01/09/24 12:00',
                            style: TextStyle(
                              fontSize: 14,
                              color: AppStyle.grey,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
      itemCount: 5,
      physics: const NeverScrollableScrollPhysics(),
      primary: true,
      shrinkWrap: true,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
    );
  }
}