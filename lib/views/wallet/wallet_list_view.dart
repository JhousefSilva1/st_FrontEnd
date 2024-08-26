import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smarttolls/generated/l10n.dart';
import 'package:smarttolls/providers/wallet_provider.dart';
import 'package:smarttolls/style/app_style.dart';
import 'package:smarttolls/widgets/custom_app_bar.dart';

class WalletListView extends StatelessWidget {
  static const String routerName = 'walletList';
  static const String routerPath = '/walletList';
  const WalletListView({super.key});

  @override
  Widget build(BuildContext context) {
    final WalletProvider walletProvider = Provider.of<WalletProvider>(context);
    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBar(
          centerTitle: true,
          text: S.of(context).wallet,
        ),
        backgroundColor: AppStyle.ligthGrey,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ListView.separated(
                  itemCount: 5,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () => walletProvider.goToWallet(context),
                      child: Container(
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
                            Image.asset('assets/car.jpg', height: 120, width: 120),
                            const SizedBox(width: 8),
                            const Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text('Suzuki, Dzire', style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w700)),
                                  Text('5617-KNK', style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w500)),
                                  Text('Bs. 128.32', style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w500)),
                                ],
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.touch_app_sharp, color: AppStyle.primary),
                              onPressed: () => walletProvider.goToWallet(context),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  physics: const NeverScrollableScrollPhysics(),
                  primary: true,
                  shrinkWrap: true,
                  separatorBuilder: (context, index) => const SizedBox(height: 8),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}