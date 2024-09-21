import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:smarttolls/generated/l10n.dart';
import 'package:smarttolls/style/app_style.dart';
import 'package:smarttolls/widgets/widgets.dart';

class QrView extends StatelessWidget {
  static const String routerName = 'qr';
  static const String routerPath = '/qr';
  const QrView({super.key});

  @override
  Widget build(BuildContext context) {
    bool isMobile = ResponsiveBreakpoints.of(context).smallerThan(TABLET);
    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBar(
          centerTitle: true,
          text: S.of(context).payWithQr,
        ),
        backgroundColor: AppStyle.ligthGrey,
        drawer: isMobile? const SmartTollsDrawer(): null,
        body: isMobile? const SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                QrMobileView()
              ],
            ),
          ),
        ): const QrTabletView(),
      ),
    );
  }
}

class QrMobileView extends StatelessWidget {
  const QrMobileView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        QrBody()
      ],
    );
  }
}

class QrTabletView extends StatelessWidget {
  const QrTabletView({super.key});

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
                  QrBody()
                ],
              ),
            ),
          ),
        )
      ],
    );
  }
}

class QrBody extends StatelessWidget {
  const QrBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: AppStyle.primary, 
              width: 1.0
            ),
            color: Colors.white,
          ),
          padding: const EdgeInsets.all(16),
          width: double.infinity,
          child: Center(
            child: Column(
              children: [
                QrImageView(
                  data: 'This QR code has an embedded image as well',
                  version: QrVersions.auto,
                  size: 250,
                  gapless: true,
                  embeddedImage: const AssetImage('assets/car.jpg'),
                  embeddedImageStyle: const QrEmbeddedImageStyle(
                    size: Size(50, 50),
                  ),
                ),
                const SizedBox(height: 16),
                const Text('Bs. 20',
                  style: TextStyle(
                    color: AppStyle.primary,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                ExtraText(data: '5617-KNK', title: S.of(context).plate, flexFirst: 1, flexSecond: 1),
                ExtraText(data: 'Suzuki', title: S.of(context).brand, flexFirst: 1, flexSecond: 1),
                ExtraText(data: 'Dzire', title: S.of(context).model, flexFirst: 1, flexSecond: 1),
                ExtraText(data: '2022', title: S.of(context).year, flexFirst: 1, flexSecond: 1),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        CustomButton(
          onPressed: () {}, 
          text: S.of(context).download
        )
      ],
    );
  }
}