import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:smarttolls/views/views.dart';

class DrawerProvider extends ChangeNotifier {

  void goToHomeAdmin(BuildContext context) {
    context.pushNamed(HomeAdminView.routerName);
  }



  void goToBrandsAdmin(BuildContext context) {
    context.pushNamed(BrandsAdminView.routerName);
  }
  void goToVehicleTypeAdmin(BuildContext context) {
    context.pushNamed(VehicleTypeAdminView.routerName);
  }

  void goToFuelTypeAdmin(BuildContext context) {
    context.pushNamed(FuelTypeAdminView.routerName);
  }
  
  void goToVehiclesColorsAdmin(BuildContext context) {
    context.pushNamed(VehiclesColorsAdminView.routerName);
  }

  void goToCountriesAdmin(BuildContext context) {
    context.pushNamed(CountryAdminView.routerName);
  }

  void goToRoadTypeAdmin(BuildContext context) {
    context.pushNamed(RoadTypeAdminView.routerName);
  }

  void goToTollAdmin(BuildContext context) {
    context.pushNamed(TollAdminView.routerName);
  }

  void goToGenderAdmin(BuildContext context) {
    context.pushNamed(GenderAdminView.routerName);
  }

  void goToPersonTypeAdmin(BuildContext context) {
    context.pushNamed(PersonTypeAdminView.routerName);
  }

  void goToStaffAdmin(BuildContext context) {
    context.pushNamed(StaffPreviewAdminView.routerName);
  }

  void goToPersonAdmin(BuildContext context) {
    context.pushNamed(PersonAdminView.routerName);
  }

  void goToProfile(BuildContext context) {
  context.goNamed(ProfileView.routerName);
}
}