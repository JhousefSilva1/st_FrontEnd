import 'package:flutter/material.dart';
import 'package:smarttolls/generated/l10n.dart';
import 'package:smarttolls/style/app_style.dart';
import 'package:smarttolls/widgets/widgets.dart';

class AddVehiclesView extends StatelessWidget {
  static const String routerName = 'addVehicles';
  static const String routerPath = '/addVehicles';
  const AddVehiclesView({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBar(
          centerTitle: true,
          text: S.of(context).addVehicles,
        ),
        backgroundColor: AppStyle.ligthGrey,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 64),
                CircleAvatar(
                  radius: 70,
                  backgroundColor: AppStyle.white,
                  child: IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.drive_eta, color: AppStyle.primary, size: 60),
                  ),
                ),
                const SizedBox(height: 32),
                CustomField(
                  hintText: S.of(context).plate,
                  keyboardType: TextInputType.text,
                  onChanged: (value) {},
                  prefixIcon: const Icon(Icons.drive_eta),
                ),
                const SizedBox(height: 16),
                CustomField(
                  hintText: S.of(context).chassis,
                  keyboardType: TextInputType.text,
                  onChanged: (value) {},
                  prefixIcon: const Icon(Icons.dvr_sharp),
                ),
                const SizedBox(height: 32),
                CustomButton(
                  onPressed: (){}, 
                  text: S.of(context).add,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}