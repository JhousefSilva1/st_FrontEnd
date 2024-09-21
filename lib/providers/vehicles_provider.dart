import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:smarttolls/views/views.dart';

class VehiclesProvider extends ChangeNotifier {
  int _currentForm = 0;
  int _editCurrentForm = 0;
  int get currentForm => _currentForm;
  int get editCurrentForm => _editCurrentForm;

  void setCurrentForm(int form) {
    _currentForm = form;
    notifyListeners();
  }

  void setEditCurrentForm(int form) {
    _editCurrentForm = form;
    notifyListeners();
  }

  void goToAddVehicle(BuildContext context) {
    context.pushNamed(AddVehiclesView.routerName);
  }

  void goToAddVehicleAdmin(BuildContext context) {
    context.pushNamed(AddVehiclesAdminView.routerName);
  }

  void goToEditVehicleAdmin(BuildContext context) {
    context.pushNamed(EditVehicleAdminView.routerName);
  }

  void goToVehicleAdmin(BuildContext context) {
    context.pushNamed(VehicleAdminView.routerName);
  }
}