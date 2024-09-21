import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:smarttolls/generated/l10n.dart';
import 'package:smarttolls/style/app_style.dart';
import 'package:smarttolls/widgets/widgets.dart';

class VehiclesView extends StatelessWidget {
  static const String routerName = 'vehicles';
  static const String routerPath = '/vehicles';
  const VehiclesView({super.key});

  @override
  Widget build(BuildContext context) {
    bool isMobile = ResponsiveBreakpoints.of(context).smallerThan(TABLET);
    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBar(
          centerTitle: true,
          text: S.of(context).vehicles,
        ),
        backgroundColor: AppStyle.ligthGrey,
        drawer: isMobile? const SmartTollsDrawer(): null,
        body: isMobile? const SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                VehiclesMobileView()
              ],
            ),
          ),
        ): const VehiclesTabletView(),
      )
    );
  }
}

class VehiclesMobileView extends StatelessWidget {
  const VehiclesMobileView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Vehicles()
      ],
    );
  }
}

class VehiclesTabletView extends StatelessWidget {
  const VehiclesTabletView({super.key});

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
                  Vehicles()
                ],
              ),
            ),
          ),
        )
      ],
    );
  }
}

class Vehicles extends StatelessWidget {
  const Vehicles({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: 5,
      itemBuilder: (context, index) {
        return const VehicleCard();
      },
      physics: const NeverScrollableScrollPhysics(),
      primary: true,
      shrinkWrap: true,
      separatorBuilder: (context, index) => const SizedBox(height: 8),
    );
  }
}