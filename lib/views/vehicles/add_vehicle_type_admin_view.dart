import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:smarttolls/generated/l10n.dart';
import 'package:smarttolls/style/app_style.dart';
import 'package:smarttolls/widgets/widgets.dart';

class AddVehicleTypeAdminView extends StatelessWidget {
  static const String routerName = 'addVehicleTypeAdmin';
  static const String routerPath = '/addVehicleTypeAdmin';
  const AddVehicleTypeAdminView({super.key});

  @override
  Widget build(BuildContext context) {
    bool isMobile = ResponsiveBreakpoints.of(context).smallerThan(TABLET);
    return SafeArea(
      child: Scaffold(
        appBar:  CustomAppBar(
          centerTitle: true,
          text: S.of(context).addVehicleType,
        ),
        drawer: isMobile? const SmartTollsDrawer(): null,
        body: isMobile? const SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                AddVehicleTypeAdminMobileView(),
              ],
            )
          ),
        ): const AddVehicleTypeAdminTabletView(),
      ),
    );
  }
}

class AddVehicleTypeAdminMobileView extends StatelessWidget {
  const AddVehicleTypeAdminMobileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class AddVehicleTypeAdminTabletView extends StatelessWidget {
  const AddVehicleTypeAdminTabletView({super.key});

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
                  AddVehicleTypeAdmin()
                ],
              )
            ),
          ),
        )
      ],
    );
  }
}

class AddVehicleTypeAdmin extends StatelessWidget {
  const AddVehicleTypeAdmin({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomField(
          hintText: S.of(context).typeOfVehicle,
          keyboardType: TextInputType.text,
          onChanged: (value) {},
          prefixIcon: const Icon(Icons.drive_eta),            
        ),
        const SizedBox(height: 12),
        CustomField(
          hintText: S.of(context).numberOfDoors,
          keyboardType: TextInputType.text,
          onChanged: (value) {},
          prefixIcon: const Icon(Icons.drive_eta),            
        ),
        const SizedBox(height: 12),
        CustomField(
          hintText: S.of(context).numberOfPassengers,
          keyboardType: TextInputType.text,
          onChanged: (value) {},
          prefixIcon: const Icon(Icons.drive_eta),            
        ),
        const SizedBox(height: 12),
        CustomField(
          hintText: S.of(context).status,
          keyboardType: TextInputType.text,
          onChanged: (value) {},
          prefixIcon: const Icon(Icons.check),            
        ),
        const SizedBox(height: 32),
        CustomButton(
          onPressed: () {},
          text: S.of(context).next,
        ),
      ],
    );
  }
}