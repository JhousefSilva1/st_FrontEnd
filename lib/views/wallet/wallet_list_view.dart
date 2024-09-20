import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:smarttolls/generated/l10n.dart';
import 'package:smarttolls/providers/wallet_provider.dart';
import 'package:smarttolls/style/app_style.dart';
import 'package:smarttolls/widgets/custom_app_bar.dart';
import 'package:smarttolls/widgets/drawer.dart';

class WalletListView extends StatelessWidget {
  static const String routerName = 'walletList';
  static const String routerPath = '/walletList';
  const WalletListView({super.key});

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
        drawer: isMobile? const SmartTollsDrawer(): null,
        body: isMobile? const SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                WalletListMobileView()
              ],
            ),
          ),
        ): const WalletListTabletView(),
      ),
    );
  }
}

class WalletListMobileView extends StatelessWidget {
  const WalletListMobileView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        WalletList()
      ],
    );
  }
}

class WalletListTabletView extends StatelessWidget {
  const WalletListTabletView({super.key});

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
                  WalletList()
                ],
              ),
            ),
          ),
        )
      ],
    );
  }
}

class WalletList extends StatelessWidget {
  const WalletList({super.key});

  @override
  Widget build(BuildContext context) {
    final WalletProvider walletProvider = Provider.of<WalletProvider>(context);
    return Column(
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
    );
  }
}