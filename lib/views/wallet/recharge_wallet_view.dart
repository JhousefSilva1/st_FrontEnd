import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
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
    final WalletProvider walletProvider = Provider.of<WalletProvider>(context);
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
                const SizedBox(height: 16),
                const Align(
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
                        hintText: S.of(context).introduceAmount,
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(6),
                          FilteringTextInputFormatter.allow(RegExp("[0-9]"))
                        ],
                        keyboardType: TextInputType.number,
                      ),
                    const SizedBox(
                      height: 32,
                    ),
                    CustomButton(
                      onPressed: () {}, 
                      text: S.of(context).next,
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}