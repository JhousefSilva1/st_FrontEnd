import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:smarttolls/views/views.dart';

class VehiclesProvider extends ChangeNotifier {
  void goToAddVehicle(BuildContext context) {
    context.pushNamed(AddVehiclesView.routerName);
  }
}