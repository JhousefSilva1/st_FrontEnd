import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:smarttolls/views/views.dart';

class VehicleTypeProvider extends ChangeNotifier {
  void goToAddVehicleTypeAdmin(BuildContext context) {
    context.pushNamed(AddVehicleTypeAdminView.routerName);
  }
}