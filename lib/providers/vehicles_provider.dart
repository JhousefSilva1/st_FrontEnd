import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:smarttolls/views/views.dart';

class VehiclesProvider extends ChangeNotifier {
  int _currentForm = 0;
  int get currentForm => _currentForm;

  void setCurrentForm(int form) {
    _currentForm = form;
    notifyListeners();
  }

  void goToAddVehicle(BuildContext context) {
    context.pushNamed(AddVehiclesView.routerName);
  }

  void goToAddVehicleAdmin(BuildContext context) {
    context.pushNamed(AddVehiclesAdminView.routerName);
  }
}