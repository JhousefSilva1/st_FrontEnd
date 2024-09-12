import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:smarttolls/generated/l10n.dart';
import 'package:smarttolls/providers/providers.dart';
import 'package:smarttolls/style/app_style.dart';
import 'package:smarttolls/widgets/widgets.dart';

class VehiclesAdminView extends StatelessWidget {
  static const String routerName = 'vehiclesAdmin';
  static const String routerPath = '/vehiclesAdmin';
  const VehiclesAdminView({super.key});

  @override
  Widget build(BuildContext context) {
    final VehiclesProvider vehiclesProvider = Provider.of<VehiclesProvider>(context);
    bool isMobile = ResponsiveBreakpoints.of(context).smallerThan(TABLET);
    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBar(
          actions: [
            IconButton(
              onPressed: () => vehiclesProvider.goToAddVehicleAdmin(context),
              icon: const Icon(Icons.add_rounded, color: AppStyle.primary, size: 30),
            )
          ],
          centerTitle: true,
          text: S.of(context).vehicles,
        ),
        drawer: isMobile? const SmartTollsDrawer(): null,
        backgroundColor: AppStyle.white,
        body: isMobile? const SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                VehiclesAdminMobileView(),
              ],
            )
          ),
        ): const VehiclesAdminTabletView(),
      ),
    );
  }
}

class VehiclesAdminMobileView extends StatelessWidget {
  const VehiclesAdminMobileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
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
            return const VehiclesCard();
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

class VehiclesAdminTabletView extends StatelessWidget {
  const VehiclesAdminTabletView({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const SmartTollsDrawer(),
        Expanded(
          flex: 2,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
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
                      return const VehiclesCard();
                    },
                    physics: const NeverScrollableScrollPhysics(),
                    primary: true,
                    shrinkWrap: true,
                    separatorBuilder: (context, index) => const SizedBox(height: 8),
                  ),
                ],
              ),
            ),
          )
        )
      ],
    );
  }
}