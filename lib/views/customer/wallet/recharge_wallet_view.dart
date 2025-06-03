import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:smarttolls/generated/l10n.dart';
import 'package:smarttolls/providers/providers.dart';
import 'package:smarttolls/style/app_style.dart';
import 'package:smarttolls/widgets/widgets.dart';
import 'package:u_credit_card/u_credit_card.dart';

class RechargeWalletView extends StatelessWidget {
  static const String routerName = 'rechargeWallet';
  static const String routerPath = '/rechargeWallet';
  const RechargeWalletView({super.key});

  @override
  Widget build(BuildContext context) {
    bool isMobile = ResponsiveBreakpoints.of(context).smallerThan(TABLET);
    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBar(
          centerTitle: true,
          text: S.of(context).rechargeWallet,
        ),
        backgroundColor: AppStyle.ligthGrey,
        // drawer: isMobile ? const SmartTollsDrawer() : null,
        body: isMobile
            ? const SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [RechargeWalletMobileView()],
                  ),
                ),
              )
            : const RechargeWalletTabletView(),
      ),
    );
  }
}

class RechargeWalletMobileView extends StatelessWidget {
  const RechargeWalletMobileView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [RechargeWalletBody()],
    );
  }
}

class RechargeWalletTabletView extends StatelessWidget {
  const RechargeWalletTabletView({super.key});

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
                children: [RechargeWalletBody()],
              ),
            ),
          ),
        )
      ],
    );
  }
}

class RechargeWalletBody extends StatefulWidget {
  const RechargeWalletBody({super.key});

  @override
  State<RechargeWalletBody> createState() => _RechargeWalletBodyState();
}

class _RechargeWalletBodyState extends State<RechargeWalletBody> {
  final TextEditingController _manualAmountController = TextEditingController();

  @override
  void dispose() {
    _manualAmountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final walletProvider = Provider.of<WalletProvider>(context);
    final selectedVehicle = walletProvider.selectedVehicle;
    final wallet = walletProvider.selectedVehicleWallet;

    return Column(
      children: [
        const SizedBox(height: 16),
        if (selectedVehicle != null && wallet != null)
          CreditCardUi(
            autoHideBalance: false,
            balance: wallet.balance ?? 0.0,
            cardHolderFullName: selectedVehicle.licensePlate ?? 'N/A',
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
          ),
        const SizedBox(height: 16),
        Column(
          children: [
            IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: RechargeWallet(
                      text: "Bs. 5",
                      active: walletProvider.itemSelectOpt == 1,
                      onPressed: () => walletProvider.setItemSelectOpt(1),
                    ),
                  ),
                  SizedBox(width: MediaQuery.of(context).size.width * 0.04),
                  Expanded(
                    child: RechargeWallet(
                      text: "Bs. 10",
                      active: walletProvider.itemSelectOpt == 2,
                      onPressed: () => walletProvider.setItemSelectOpt(2),
                    ),
                  ),
                  SizedBox(width: MediaQuery.of(context).size.width * 0.04),
                  Expanded(
                    child: RechargeWallet(
                      text: "Bs. 20",
                      active: walletProvider.itemSelectOpt == 3,
                      onPressed: () => walletProvider.setItemSelectOpt(3),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20.0),
            IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: RechargeWallet(
                      text: "Bs. 30",
                      active: walletProvider.itemSelectOpt == 4,
                      onPressed: () => walletProvider.setItemSelectOpt(4),
                    ),
                  ),
                  SizedBox(width: MediaQuery.of(context).size.width * 0.04),
                  Expanded(
                    child: RechargeWallet(
                      text: "Bs. 50",
                      active: walletProvider.itemSelectOpt == 5,
                      onPressed: () => walletProvider.setItemSelectOpt(5),
                    ),
                  ),
                  SizedBox(width: MediaQuery.of(context).size.width * 0.04),
                  Expanded(
                    child: RechargeWallet(
                      text: "Otro",
                      active: walletProvider.itemSelectOpt == 6,
                      onPressed: () => walletProvider.setItemSelectOpt(6),
                    ),
                  ),
                ],
              ),
            ),
            if (walletProvider.itemSelectOpt == 6)
              const SizedBox(height: 16),
            if (walletProvider.itemSelectOpt == 6)
              CustomField(
                controller: _manualAmountController,
                hintText: S.of(context).introduceAmount,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(6),
                  FilteringTextInputFormatter.allow(RegExp("[0-9]"))
                ],
                keyboardType: TextInputType.number,
              ),
            const SizedBox(height: 32),
            CustomButton(
              onPressed: () {
                // Determinar el monto seleccionado
                double amount;
                switch (walletProvider.itemSelectOpt) {
                  case 1:
                    amount = 5.0;
                    break;
                  case 2:
                    amount = 10.0;
                    break;
                  case 3:
                    amount = 20.0;
                    break;
                  case 4:
                    amount = 30.0;
                    break;
                  case 5:
                    amount = 50.0;
                    break;
                  case 6:
                    // Validar monto manual
                    final manualAmount = double.tryParse(
                            _manualAmountController.text) ??
                        0.0;
                    if (manualAmount <= 0) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Ingrese un monto válido')),
                      );
                      return;
                    }
                    amount = manualAmount;
                    break;
                  default:
                    amount = 0.0;
                }

                // Preparar la recarga con el vehículo y monto seleccionados
                walletProvider.prepareRecharge(
                    selectedVehicle!, amount);

                // Navegar a la pantalla QR
                walletProvider.goToQr(context);
              },
              text: S.of(context).next,
            ),
          ],
        ),
      ],
    );
  }
}