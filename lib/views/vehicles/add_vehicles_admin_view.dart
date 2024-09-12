import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:smarttolls/generated/l10n.dart';
import 'package:smarttolls/providers/providers.dart';
import 'package:smarttolls/style/app_style.dart';
import 'package:smarttolls/widgets/widgets.dart';

class AddVehiclesAdminView extends StatelessWidget {
  static const String routerName = 'addVehiclesAdmin';
  static const String routerPath = '/addVehiclesAdmin';
  const AddVehiclesAdminView({super.key});

  @override
  Widget build(BuildContext context) {
    bool isMobile = ResponsiveBreakpoints.of(context).smallerThan(TABLET);
    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBar(
          centerTitle: true,
          text: S.of(context).addVehicles,
        ),
        drawer: isMobile? const SmartTollsDrawer(): null,
        body: isMobile? const SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                AddVehiclesAdminMobileView(),
              ],
            )
          ),
        ): const AddVehiclesAdminTabletView(),
      ),
    );
  }
}

class AddVehiclesAdminMobileView extends StatelessWidget {
  const AddVehiclesAdminMobileView({super.key});

  @override
  Widget build(BuildContext context) {
    final VehiclesProvider vehiclesProvider = Provider.of<VehiclesProvider>(context);
    return Column(
      children: [
        if(vehiclesProvider.currentForm == 0) const AddVehiclesAdminForm(),
        if(vehiclesProvider.currentForm == 1) const AddCustomerForm(),
      ],
    );
  }
}

class AddVehiclesAdminTabletView extends StatelessWidget {
  const AddVehiclesAdminTabletView({super.key});

  @override
  Widget build(BuildContext context) {
    final VehiclesProvider vehiclesProvider = Provider.of<VehiclesProvider>(context);
    return Row(
      children: [
        const SmartTollsDrawer(),
        Expanded(
          flex: 2,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  if(vehiclesProvider.currentForm == 0) const AddVehiclesAdminForm(),
                  if(vehiclesProvider.currentForm == 1) const AddCustomerForm(),
                ],
              )
            ),
          )
        )
      ],
    );
  }
}

class AddVehiclesAdminForm extends StatelessWidget {
  const AddVehiclesAdminForm({super.key});

  @override
  Widget build(BuildContext context) {
    final VehiclesProvider vehiclesProvider = Provider.of<VehiclesProvider>(context);
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            S.of(context).vehicleData,
            style: const TextStyle(color: AppStyle.primaryLigth, fontSize: 20, fontWeight: FontWeight.w500),
          ),
        ),
        const SizedBox(height: 12),
        const CustomProgressIndicator(current: 1, height: 4),
        const SizedBox(height: 24),
        Row(
          children: [
            Expanded(
              flex: 2,
              child: CustomField(
                hintText: S.of(context).plate,
                keyboardType: TextInputType.text,
                onChanged: (value) {},
                prefixIcon: const Icon(Icons.drive_eta),
                
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              flex: 2,
              child: CustomField(
                hintText: S.of(context).circulationSquare,
                keyboardType: TextInputType.text,
                onChanged: (value) {},
                prefixIcon: const Icon(Icons.location_on_rounded),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              flex: 2,
              child: CustomField(
                hintText: S.of(context).typeOfVehicle,
                keyboardType: TextInputType.text,
                onChanged: (value) {},
                prefixIcon: const Icon(Icons.car_repair_rounded),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              flex: 2,
              child: CustomField(
                hintText: S.of(context).brand,
                keyboardType: TextInputType.text,
                onChanged: (value) {},
                prefixIcon: const Icon(Icons.ballot_outlined),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              flex: 2,
              child: CustomField(
                hintText: S.of(context).model,
                keyboardType: TextInputType.text,
                onChanged: (value) {},
                prefixIcon: const Icon(Icons.ballot_outlined),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              flex: 2,
              child: CustomField(
                hintText: S.of(context).year,
                keyboardType: TextInputType.text,
                onChanged: (value) {},
                prefixIcon: const Icon(Icons.calendar_month_outlined),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              flex: 2,
              child: CustomField(
                hintText: S.of(context).fuel,
                keyboardType: TextInputType.text,
                onChanged: (value) {},
                prefixIcon: const Icon(Icons.local_gas_station_rounded),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              flex: 2,
              child: CustomField(
                hintText: S.of(context).weight,
                keyboardType: TextInputType.text,
                onChanged: (value) {},
                prefixIcon: const Icon(Icons.line_weight_rounded),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              flex: 2,
              child: CustomField(
                hintText: S.of(context).vehicleService,
                keyboardType: TextInputType.text,
                onChanged: (value) {},
                prefixIcon: const Icon(Icons.build_circle_rounded),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              flex: 2,
              child: CustomField(
                hintText: S.of(context).chassis,
                keyboardType: TextInputType.text,
                onChanged: (value) {},
                prefixIcon: const Icon(Icons.dvr_sharp),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        CustomField(
          hintText: S.of(context).engineNumber,
          keyboardType: TextInputType.text,
          onChanged: (value) {},
          prefixIcon: const Icon(Icons.engineering_sharp),
        ),
        const SizedBox(height: 32),
        CustomButton(
          onPressed: () => vehiclesProvider.setCurrentForm(1),
          text: S.of(context).next,
        ),
      ],
    );
  }
}

class AddCustomerForm extends StatelessWidget {
  const AddCustomerForm({super.key});

  @override
  Widget build(BuildContext context) {
    final VehiclesProvider vehiclesProvider = Provider.of<VehiclesProvider>(context);
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            S.of(context).personData,
            style: const TextStyle(color: AppStyle.primaryLigth, fontSize: 20, fontWeight: FontWeight.w500),
          ),
        ),
        const SizedBox(height: 12),
        const CustomProgressIndicator(current: 2, height: 4),
        const SizedBox(height: 24),
        Row(
          children: [
            Expanded(
              flex: 2,
              child: CustomField(
                hintText: S.of(context).lastNameM,
                keyboardType: TextInputType.text,
                onChanged: (value) {},
                prefixIcon: const Icon(Icons.person),
                
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              flex: 2,
              child: CustomField(
                hintText: S.of(context).lastNameF,
                keyboardType: TextInputType.text,
                onChanged: (value) {},
                prefixIcon: const Icon(Icons.person),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              flex: 2,
              child: CustomField(
                hintText: S.of(context).name,
                keyboardType: TextInputType.text,
                onChanged: (value) {},
                prefixIcon: const Icon(Icons.person),
                
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              flex: 2,
              child: CustomField(
                hintText: S.of(context).typeOfDocument,
                keyboardType: TextInputType.text,
                onChanged: (value) {},
                prefixIcon: const Icon(Icons.badge_outlined),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              flex: 2,
              child: CustomField(
                hintText: S.of(context).dni,
                keyboardType: TextInputType.text,
                onChanged: (value) {},
                prefixIcon: const Icon(Icons.badge_outlined),
                
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              flex: 2,
              child: CustomField(
                hintText: S.of(context).country,
                keyboardType: TextInputType.text,
                onChanged: (value) {},
                prefixIcon: const Icon(Icons.location_on),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              flex: 2,
              child: CustomButton(
                backgroundColor: AppStyle.white,
                color: AppStyle.primary,
                onPressed: () => vehiclesProvider.setCurrentForm(0),
                text: S.of(context).back,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              flex: 2,
              child: CustomButton(
                onPressed: () => vehiclesProvider.setCurrentForm(1),
                text: S.of(context).next,
              ),
            ),
          ],
        ),
      ],
    );
  }
}