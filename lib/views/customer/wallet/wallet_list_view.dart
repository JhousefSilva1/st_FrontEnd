import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:smarttolls/api/api.dart';
import 'package:smarttolls/api/response/customer/st_wallet_response.dart';
import 'package:smarttolls/api/response/operador/tolls/transaction_response.dart';
import 'package:smarttolls/generated/l10n.dart';
import 'package:smarttolls/providers/providers.dart';
import 'package:smarttolls/style/app_style.dart';
import 'package:smarttolls/widgets/menu/mobile/drawerMobile.dart';
import 'package:smarttolls/widgets/widgets.dart';
import 'package:u_credit_card/u_credit_card.dart';
import 'package:intl/intl.dart';

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
        // drawer: isMobile ? const SmartTollsMobileDrawer() : null,
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
        SmartTollsMobileDrawer(),
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
   int? _lastLoadedVehicleId;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<WalletProvider>(context, listen: false);
      provider.loadUserVehicles();
    });
  }

  @override
  Widget build(BuildContext context) {
    final walletProvider = Provider.of<WalletProvider>(context);

    final currentVehicleId = walletProvider.selectedVehicle?.idVehicle;
    if (currentVehicleId != null && currentVehicleId != _lastLoadedVehicleId) {
      _lastLoadedVehicleId = currentVehicleId;
      walletProvider.loadTransactionsForVehicle(currentVehicleId);
    }
    
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
        
        if (walletProvider.selectedVehicleWallet != null)
          _buildTransactionList(context, walletProvider),
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

  Widget _buildTransactionList(BuildContext context, WalletProvider walletProvider) {
    if (walletProvider.isLoading && walletProvider.transactions.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(16),
        child: CircularProgressIndicator(color: AppStyle.primary),
      );
    }
    
    if (walletProvider.errorMessage != null && walletProvider.transactions.isEmpty) {
      return Column(
        children: [
          Text(
            walletProvider.errorMessage!,
            style: const TextStyle(color: Colors.red),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => walletProvider.loadTransactionsForVehicle(
              walletProvider.selectedVehicle!.idVehicle!),
            child: Text(S.of(context).retry),
          ),
        ],
      );
    }
    
    final transactionsToShow = walletProvider.transactions.take(6).toList();
    
    if (transactionsToShow.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(16),
        child: Text(
          S.of(context).noTransactionsFound,
          style: const TextStyle(color: Colors.grey),
        ),
      );
    }
    
    return Column(
      children: [
        ListView.separated(
          itemCount: transactionsToShow.length,
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          separatorBuilder: (context, index) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final transaction = transactionsToShow[index];
            return _buildTransactionItem(context, transaction);
          },
        ),
        if (walletProvider.transactions.length > 6)
          TextButton(
            onPressed: () => walletProvider.goToTransactionHistory(context),
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
    );
  }

Widget _buildTransactionItem(BuildContext context, TransactionResponse transaction) {
  return FutureBuilder<String?>(
    future: Provider.of<WalletProvider>(context).getTollName(transaction.tollId ?? 0),
    builder: (context, snapshot) {
      final tollName = snapshot.data ?? 'Peaje #${transaction.tollId ?? 'N/A'}';
      
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
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: AppStyle.ligthGrey,
                radius: 24,
                child: const Icon(Icons.credit_card, color: AppStyle.primary),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            tollName, // Usamos el nombre del peaje aquí
                            style: const TextStyle(
                              color: AppStyle.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        Text(
                          'Bs. ${transaction.amount?.toStringAsFixed(2) ?? '0.00'}',
                          style: TextStyle(
                            color: transaction.amount != null && transaction.amount! < 0 
                                ? Colors.red 
                                : Colors.green,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      transaction.transactionDate != null
                          ? DateFormat('dd/MM/yy HH:mm').format(transaction.transactionDate!)
                          : 'Fecha no disponible',
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppStyle.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
}