import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:smarttolls/views/views.dart';

class EmployeeProvider extends ChangeNotifier {
  void goToAddEmployeeAdmin(BuildContext context){
    context.pushNamed(AddEmployeeAdminView.routerName);
  }
}