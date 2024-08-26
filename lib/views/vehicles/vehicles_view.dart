import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smarttolls/generated/l10n.dart';
import 'package:smarttolls/providers/providers.dart';
import 'package:smarttolls/style/app_style.dart';
import 'package:smarttolls/widgets/widgets.dart';

class VehiclesView extends StatelessWidget {
  static const String routerName = 'vehicles';
  static const String routerPath = '/vehicles';
  const VehiclesView({super.key});

  @override
  Widget build(BuildContext context) {
    final VehiclesProvider vehiclesProvider = Provider.of<VehiclesProvider>(context);
    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBar(
          actions: [
            IconButton(
              onPressed: () => vehiclesProvider.goToAddVehicle(context), 
              icon: const Icon(Icons.add_rounded, color: AppStyle.primary, size: 30),
            )
          ],
          centerTitle: true,
          text: S.of(context).vehicles,
        ),
        backgroundColor: AppStyle.ligthGrey,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: ListView.separated(
              itemCount: 5,
              itemBuilder: (context, index) {
                return Container(
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
                            Text('2022', style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w500)),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.payment_outlined, color: AppStyle.primary),
                        onPressed: () {},
                      ),
                    ],
                  ),
                );
              },
              physics: const NeverScrollableScrollPhysics(),
              primary: true,
              shrinkWrap: true,
              separatorBuilder: (context, index) => const SizedBox(height: 8),
            ),
          ),
        ),
      ),
    );
  }
}