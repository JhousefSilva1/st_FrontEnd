import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:smarttolls/generated/l10n.dart';
import 'package:smarttolls/style/app_style.dart';
import 'package:smarttolls/widgets/widgets.dart';

class VehicleAdminView extends StatelessWidget {
  static const String routerName = 'vehicleAdmin';
  static const String routerPath = '/vehicleAdmin';
  const VehicleAdminView({super.key});

  @override
  Widget build(BuildContext context) {
    bool isMobile = ResponsiveBreakpoints.of(context).smallerThan(TABLET);
    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBar(
          centerTitle: true,
          text: S.of(context).vehicle
        ),
        backgroundColor: AppStyle.white,
        drawer: isMobile? const SmartTollsDrawer(): null,
        body: isMobile? const SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                VehicleAdminMobileView(),
              ],
            )
          ),
        ): const VehicleAdminTabletView(),
      ),
    );
  }
}

class VehicleAdminMobileView extends StatelessWidget {
  const VehicleAdminMobileView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        VehicleForm(),
      ],
    );
  }
}

class VehicleAdminTabletView extends StatelessWidget {
  const VehicleAdminTabletView({super.key});

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
                  VehicleForm(),
                ],
              )
            ),
          )
        )
      ],
    );
  }
}

class VehicleForm extends StatelessWidget {
  const VehicleForm({super.key});

  @override
  Widget build(BuildContext context) {
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
                          child: Text(S.of(context).circulationSquare, style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.w700)),
                        ),
                        const SizedBox(width: 16),
                        const Expanded(
                          flex: 2,
                          child: Text('La Paz', style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w500)),
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
                          child: Text(S.of(context).fuel, style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.w700)),
                        ),
                        const SizedBox(width: 16),
                        const Expanded(
                          flex: 2,
                          child: Text('Gasolina', style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w500)),
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
                          child: Text(S.of(context).vehicleService, style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.w700)),
                        ),
                        const SizedBox(width: 16),
                        const Expanded(
                          flex: 2,
                          child: Text('Particular', style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w500)),
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
        const SizedBox(height: 12),
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            S.of(context).personData,
            style: const TextStyle(color: AppStyle.primaryLigth, fontSize: 20, fontWeight: FontWeight.w500),
          ),
        ),
        const SizedBox(height: 12),
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
              const Icon(Icons.account_circle_rounded, color: AppStyle.primary, size: 50),
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
                          child: Text(S.of(context).lastNameF, style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.w700)),
                        ),
                        const SizedBox(width: 16),
                        const Expanded(
                          flex: 2,
                          child: Text('Pozo', style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w500)),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Text(S.of(context).lastNameM, style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.w700)),
                        ),
                        const SizedBox(width: 16),
                        const Expanded(
                          flex: 2,
                          child: Text('Silva', style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w500)),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Text(S.of(context).name, style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.w700)),
                        ),
                        const SizedBox(width: 16),
                        const Expanded(
                          flex: 2,
                          child: Text('Jose', style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w500)),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Text(S.of(context).typeOfDocument, style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.w700)),
                        ),
                        const SizedBox(width: 16),
                        const Expanded(
                          flex: 2,
                          child: Text('Cedula de identidad', style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w500)),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Text(S.of(context).dni, style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.w700)),
                        ),
                        const SizedBox(width: 16),
                        const Expanded(
                          flex: 2,
                          child: Text('12345678', style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w500)),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Text(S.of(context).country, style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.w700)),
                        ),
                        const SizedBox(width: 16),
                        const Expanded(
                          flex: 2,
                          child: Text('Bolivia', style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w500)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            S.of(context).wallet,
            style: const TextStyle(color: AppStyle.primaryLigth, fontSize: 20, fontWeight: FontWeight.w500),
          ),
        ),
        const SizedBox(height: 12),
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
              const Icon(Icons.account_circle_rounded, color: AppStyle.primary, size: 50),
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
                          child: Text(S.of(context).accountNumber, style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.w700)),
                        ),
                        const SizedBox(width: 16),
                        const Expanded(
                          flex: 2,
                          child: Text('5617-12345678-KNK', style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w500)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}