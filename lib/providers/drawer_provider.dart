import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:smarttolls/views/views.dart';

class DrawerProvider extends ChangeNotifier {
  void goToVehicleTypeAdmin(BuildContext context) {
    context.pushNamed(VehicleTypeAdminView.routerName);
  }
}