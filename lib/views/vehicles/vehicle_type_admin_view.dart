import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:smarttolls/generated/l10n.dart';
import 'package:smarttolls/providers/providers.dart';
import 'package:smarttolls/style/app_style.dart';
import 'package:smarttolls/widgets/widgets.dart';

class VehicleTypeAdminView extends StatelessWidget {
  static const String routerName = 'vehicleTypeAdmin';
  static const String routerPath = '/vehicleTypeAdmin';
  const VehicleTypeAdminView({super.key});

  @override
  Widget build(BuildContext context) {
    final VehicleTypeProvider vehicleTypeProvider = Provider.of<VehicleTypeProvider>(context);
    bool isMobile = ResponsiveBreakpoints.of(context).smallerThan(TABLET);
    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBar(
          actions: [
            IconButton(
              onPressed: () => vehicleTypeProvider.goToAddVehicleTypeAdmin(context),
              icon: const Icon(Icons.add_rounded, color: AppStyle.primary, size: 30),
            )
          ],
          centerTitle: true,
          text: S.of(context).vehicleType,
        ),
        drawer: isMobile? const SmartTollsDrawer(): null,
        body: isMobile? const SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                VehicleTypeAdminMobileView(),
              ],
            )
          ),
        ): const VehicleTypeAdminTabletView(),
      ),
    );
  }
}

class VehicleTypeAdminMobileView extends StatelessWidget {
  const VehicleTypeAdminMobileView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        VehicleTypeAdmin()
      ],
    );
  }
}

class VehicleTypeAdminTabletView extends StatelessWidget {
  const VehicleTypeAdminTabletView({super.key});

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
                  VehicleTypeAdmin()
                ],
              )
            ),
          ),
        )
      ],
    );
  }
}

class VehicleTypeAdmin extends StatelessWidget {
  const VehicleTypeAdmin({super.key});

  @override
  Widget build(BuildContext context) {
    return  Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CustomField(
          hintText: S.of(context).search,
          prefixIcon: const Icon(Icons.search),
          onChanged: (value) {},
        ),
        ListView.separated(
          itemCount: 5,
          itemBuilder: (context, index) {
            return const VehicleTypeCard();
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