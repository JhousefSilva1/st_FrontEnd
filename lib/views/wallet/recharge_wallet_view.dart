import 'package:flutter/material.dart';
import 'package:smarttolls/generated/l10n.dart';
import 'package:smarttolls/style/app_style.dart';
import 'package:smarttolls/widgets/custom_app_bar.dart';
import 'package:u_credit_card/u_credit_card.dart';

class RechargeWalletView extends StatelessWidget {
  static const String routerName = 'rechargeWallet';
  static const String routerPath = '/rechargeWallet';
  const RechargeWalletView({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBar(
          centerTitle: true,
          text: S.of(context).rechargeWallet,
        ),
        backgroundColor: AppStyle.ligthGrey,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
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
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}