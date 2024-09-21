import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:smarttolls/generated/l10n.dart';
import 'package:smarttolls/providers/providers.dart';
import 'package:smarttolls/style/app_style.dart';
import 'package:smarttolls/widgets/custom_progress.dart';
import 'package:smarttolls/widgets/widgets.dart';
import 'package:u_credit_card/u_credit_card.dart';

class EditVehicleAdminView extends StatelessWidget {
  static const String routerName = 'editVehicleAdmin';
  static const String routerPath = '/editVehicleAdmin';
  const EditVehicleAdminView({super.key});

  @override
  Widget build(BuildContext context) {
    bool isMobile = ResponsiveBreakpoints.of(context).smallerThan(TABLET);
    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBar(
          centerTitle: true,
          text: S.of(context).editVehicle
        ),
        backgroundColor: AppStyle.white,
        drawer: isMobile? const SmartTollsDrawer(): null,
        body: isMobile? const SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                EditVehiclesAdminMobileView(),
              ],
            )
          ),
        ): const EditVehiclesAdminTabletView(),
      ),
    );
  }
}

class EditVehiclesAdminMobileView extends StatelessWidget {
  const EditVehiclesAdminMobileView({super.key});

  @override
  Widget build(BuildContext context) {
    final VehiclesProvider vehiclesProvider = Provider.of<VehiclesProvider>(context);
    return Column(
      children: [
        if(vehiclesProvider.editCurrentForm == 0) const EditVehiclesAdminForm(),
        if(vehiclesProvider.editCurrentForm == 1) const EditCustomerForm(),
        if(vehiclesProvider.editCurrentForm == 2) const EditWalletForm(),
      ],
    );
  }
}

class EditVehiclesAdminTabletView extends StatelessWidget {
  const EditVehiclesAdminTabletView({super.key});

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
                  if(vehiclesProvider.editCurrentForm == 0) const EditVehiclesAdminForm(),
                  if(vehiclesProvider.editCurrentForm == 1) const EditCustomerForm(),
                  if(vehiclesProvider.editCurrentForm == 2) const EditWalletForm(),
                ],
              )
            ),
          )
        )
      ],
    );
  }
}

class EditVehiclesAdminForm extends StatelessWidget {
  const EditVehiclesAdminForm({super.key});

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
        const CustomProgress(current: 1, height: 4, isFirst: true),
        const SizedBox(height: 24),
        Container(
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
              const Icon(Icons.drive_eta, color: AppStyle.primary, size: 50),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Text(S.of(context).plate, style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.w700)),
                        ),
                        const SizedBox(width: 16),
                        const Expanded(
                          flex: 2,
                          child: Text('5617-KNK', style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w500)),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Text(S.of(context).typeOfVehicle, style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.w700)),
                        ),
                        const SizedBox(width: 16),
                        const Expanded(
                          flex: 2,
                          child: Text('Automovil', style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w500)),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Text(S.of(context).brand, style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.w700)),
                        ),
                        const SizedBox(width: 16),
                        const Expanded(
                          flex: 2,
                          child: Text('Suzuki', style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w500)),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Text(S.of(context).model, style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.w700)),
                        ),
                        const SizedBox(width: 16),
                        const Expanded(
                          flex: 2,
                          child: Text('Dzire', style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w500)),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Text(S.of(context).year, style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.w700)),
                        ),
                        const SizedBox(width: 16),
                        const Expanded(
                          flex: 2,
                          child: Text('2022', style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w500)),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Text(S.of(context).weight, style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.w700)),
                        ),
                        const SizedBox(width: 16),
                        const Expanded(
                          flex: 2,
                          child: Text('1340 KG', style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w500)),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Text(S.of(context).chassis, style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.w700)),
                        ),
                        const SizedBox(width: 16),
                        const Expanded(
                          flex: 2,
                          child: Text('MASKSSDA12SD', style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w500)),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Text(S.of(context).engineNumber, style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.w700)),
                        ),
                        const SizedBox(width: 16),
                        const Expanded(
                          flex: 2,
                          child: Text('K12FDSDSFFDS', style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w500)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 32),
        CustomField(
          hintText: S.of(context).circulationSquare,
          keyboardType: TextInputType.text,
          onChanged: (value) {},
          prefixIcon: const Icon(Icons.location_on_rounded),
        ),
        const SizedBox(height: 16),
        CustomField(
          hintText: S.of(context).fuel,
          keyboardType: TextInputType.text,
          onChanged: (value) {},
          prefixIcon: const Icon(Icons.local_gas_station_rounded),
        ),
        const SizedBox(height: 16),
        CustomField(
          hintText: S.of(context).vehicleService,
          keyboardType: TextInputType.text,
          onChanged: (value) {},
          prefixIcon: const Icon(Icons.build_circle_rounded),
        ),
        const SizedBox(height: 32),
        CustomButton(
          onPressed: () => vehiclesProvider.setEditCurrentForm(1),
          text: S.of(context).next,
        ),
      ],
    );
  }
}

class EditCustomerForm extends StatelessWidget {
  const EditCustomerForm({super.key});

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
        const CustomProgress(current: 2, height: 4, isSecond: true),
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
                onPressed: () => vehiclesProvider.setEditCurrentForm(0),
                text: S.of(context).back,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              flex: 2,
              child: CustomButton(
                onPressed: () => vehiclesProvider.setEditCurrentForm(2),
                text: S.of(context).next,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class EditWalletForm extends StatelessWidget {
  const EditWalletForm({super.key});

  @override
  Widget build(BuildContext context) {
    final VehiclesProvider vehiclesProvider = Provider.of<VehiclesProvider>(context);
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            S.of(context).wallet,
            style: const TextStyle(color: AppStyle.primaryLigth, fontSize: 20, fontWeight: FontWeight.w500),
          ),
        ),
        const SizedBox(height: 12),
        const CustomProgress(current: 3, height: 4, isThree: true),
        const SizedBox(height: 24),
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
        Text(S.of(context).accountNumber, 
          style: const TextStyle(
            color: AppStyle.primary,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 16),
        const Text('5617-8440004-KNK', 
          style: TextStyle(
            color: AppStyle.grey,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 16),
        Text(S.of(context).plate, 
          style: const TextStyle(
            color: AppStyle.primary,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 16),
        const Text('5617-KNK', 
          style: TextStyle(
            color: AppStyle.grey,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 32),
        Row(
          children: [
            Expanded(
              flex: 2,
              child: CustomButton(
                backgroundColor: AppStyle.white,
                color: AppStyle.primary,
                onPressed: () => vehiclesProvider.setEditCurrentForm(1),
                text: S.of(context).back,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              flex: 2,
              child: CustomButton(
                onPressed: () => vehiclesProvider.setEditCurrentForm(2),
              text: S.of(context).edit,
              ),
            ),
          ],
        ),
      ],
    );
  }
}