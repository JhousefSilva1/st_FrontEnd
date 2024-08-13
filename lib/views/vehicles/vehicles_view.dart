import 'package:flutter/material.dart';
import 'package:smarttolls/generated/l10n.dart';
import 'package:smarttolls/style/app_style.dart';
import 'package:smarttolls/widgets/widgets.dart';

class VehiclesView extends StatelessWidget {
  static const String routerName = 'vehicles';
  static const String routerPath = '/vehicles';
  const VehiclesView({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBar(
          backgroundColor: AppStyle.white,
          centerTitle: true,
          iconThemeData: const IconThemeData(color: AppStyle.primary),
          text: S.of(context).vehicles,
          textStyle: const TextStyle(color: AppStyle.primary, fontSize: 20),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                
              ],
            ),
          ),
        ),
      ),
    );
  }
}