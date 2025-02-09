import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:smarttolls/api/api.dart';
import 'package:smarttolls/generated/l10n.dart';
import 'package:smarttolls/providers/providers.dart';
import 'package:smarttolls/style/app_style.dart';
import 'package:smarttolls/widgets/custom_dropdown_field.dart';
import 'package:smarttolls/widgets/custom_progress.dart';
import 'package:smarttolls/widgets/widgets.dart';
import 'package:u_credit_card/u_credit_card.dart';

class AddVehiclesAdminView extends StatefulWidget {
  static const String routerName = 'addVehiclesAdmin';
  static const String routerPath = '/addVehiclesAdmin';
  const AddVehiclesAdminView({super.key});

  @override
  State<AddVehiclesAdminView> createState() => _AddVehiclesAdminViewState();
}

class _AddVehiclesAdminViewState extends State<AddVehiclesAdminView> {
  
  @override
  void initState() {
    _loadInitialData();
    super.initState();
  }

  Future _loadInitialData() async {
    final VehiclesProvider vehiclesProvider = Provider.of<VehiclesProvider>(context, listen: false);
    await Future.wait([
      vehiclesProvider.fetchAllBrands(),
      vehiclesProvider.fetchAllColors(),
      vehiclesProvider.fetchAllFuelTypes(),
      vehiclesProvider.fetchAllModels(),
      vehiclesProvider.fetchAllVehiclesType(),
    ]);
  }
  
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
        if(vehiclesProvider.currentForm == 2) const AddWalletForm(),
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
                  if(vehiclesProvider.currentForm == 2) const AddWalletForm(),
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
        const CustomProgress(current: 1, height: 4, isFirst: true),
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
              child: vehiclesProvider.vehiclesType.isEmpty?
              const Center(child: CircularProgressIndicator()):
              CustomDropdownfield(
                label: S.of(context).typeOfVehicle,
                value: vehiclesProvider.vehiclesType.first,
                items: vehiclesProvider.vehiclesType.map((StVehiclesTypeResponse value) {
                  return DropdownMenuItem(
                    value: value,
                    child: Text(value.vehiclesTypes?? ''),
                  );
                }).toList(),
                onChanged: (value) {
                  vehiclesProvider.setVehicleType = value;
                },
              )
            )
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              flex: 2,
              child: vehiclesProvider.brands.isEmpty?
              const Center(child: CircularProgressIndicator()): 
              CustomDropdownfield(
                label: S.of(context).brand,
                value: vehiclesProvider.brands.first,
                items: vehiclesProvider.brands.map((StBrandResponse value) {
                  return DropdownMenuItem(
                    value: value,
                    child: Text(value.brandName?? ''),
                  );
                }).toList(),
                onChanged: (value) {
                  vehiclesProvider.setBrand = value;
                  vehiclesProvider.fetchAllModelsByBrand(value);
                },
              )
            ),
            const SizedBox(width: 16),
            Expanded(
              flex: 2,
              child: vehiclesProvider.vehiclesModels.isEmpty?
              const Center(child: CircularProgressIndicator()):
              CustomDropdownfield(
                label: S.of(context).model,
                value: vehiclesProvider.vehiclesModels.first,
                items: vehiclesProvider.vehiclesModels.map((StVehiclesModelsResponse value) {
                  return DropdownMenuItem(
                    value: value,
                    child: Text(value.modelName?? ''),
                  );
                }).toList(),
                onChanged: (value) {
                  vehiclesProvider.setModel = value;
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              flex: 2,
              child: vehiclesProvider.fuelTypes.isEmpty?
              const Center(child: CircularProgressIndicator()):
              CustomDropdownfield(
                label: S.of(context).fuel,
                value: vehiclesProvider.fuelTypes.first,
                items: vehiclesProvider.fuelTypes.map((StFuelTypesResponse value) {
                  return DropdownMenuItem(
                    value: value,
                    child: Text(value.fuelTypeFuel?? ''),
                  );
                }).toList(),
                onChanged: (value) {
                  vehiclesProvider.setFuelType = value;
                },
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              flex: 2,
              child: CustomField(
                hintText: S.of(context).year,
                keyboardType: TextInputType.number,
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
                hintText: S.of(context).chassis,
                keyboardType: TextInputType.text,
                onChanged: (value) {},
                prefixIcon: const Icon(Icons.dvr_sharp),
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
                hintText: S.of(context).engineNumber,
                keyboardType: TextInputType.text,
                onChanged: (value) {},
                prefixIcon: const Icon(Icons.engineering_sharp),
              ),
            )
          ],
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
                onPressed: () => vehiclesProvider.setCurrentForm(0),
                text: S.of(context).back,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              flex: 2,
              child: CustomButton(
                onPressed: () => vehiclesProvider.setCurrentForm(2),
                text: S.of(context).next,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class AddWalletForm extends StatelessWidget {
  const AddWalletForm({super.key});

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
            cardProviderLogo: InkWell(
              // onTap: () => walletProvider.goToRechargeWallet(context),
              child:Chip(
                labelStyle: TextStyle(color: AppStyle.primary),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16)), side: BorderSide(color: AppStyle.primary, width: 1)),
                label: Text('Recargar')
              ),
            ),
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
                onPressed: () => vehiclesProvider.setCurrentForm(1),
                text: S.of(context).back,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              flex: 2,
              child: CustomButton(
                onPressed: () => vehiclesProvider.setCurrentForm(2),
                text: S.of(context).add,
              ),
            ),
          ],
        ),
      ],
    );
  }
}