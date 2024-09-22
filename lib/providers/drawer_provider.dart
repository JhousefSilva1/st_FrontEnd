import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:smarttolls/views/views.dart';

class DrawerProvider extends ChangeNotifier {
  void goToBrandsAdmin(BuildContext context) {
    context.pushNamed(BrandsAdminView.routerName);
  }
  void goToVehicleTypeAdmin(BuildContext context) {
    context.pushNamed(VehicleTypeAdminView.routerName);
  }
}