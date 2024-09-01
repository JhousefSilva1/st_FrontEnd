import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
    final WalletProvider walletProvider = Provider.of<WalletProvider>(context, listen: false);
    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBar(
          centerTitle: true,
          text: S.of(context).wallet,
        ),
        backgroundColor: AppStyle.ligthGrey,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.center,
                  child: CreditCardUi(
                    autoHideBalance: false,
                    balance: 128.32434343,
                    cardHolderFullName: '5617-KNK',
                    cardNumber: '1234567812345678',
                    cardType: CardType.debit,
                    cvvNumber: '',
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
                      onTap: () => walletProvider.goToRechargeWallet(context),
                      child: const Chip(
                        labelStyle: TextStyle(color: AppStyle.primary),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16)), side: BorderSide(color: AppStyle.primary, width: 1)),
                        label: Text('Recargar')
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: Text(S.of(context).transactionHistory, 
                        style: const TextStyle(
                          color: AppStyle.primary,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      )
                    ),
                    GestureDetector(
                      onTap: () => walletProvider.goToTransactionHistory(context),
                      child: Text(S.of(context).seeAll,
                        style: const TextStyle(
                          color: AppStyle.primary,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ListView.separated(
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
                            spreadRadius: 1
                          ),
                        ]
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
                                      child: Text('Urujara', 
                                        style: TextStyle(
                                          color: AppStyle.black,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 8),
                                    Text('Bs. 2', 
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
                                      child: Text('01/09/24 12:00', 
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
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}