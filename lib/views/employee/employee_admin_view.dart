import 'package:flutter/material.dart';

class EmployeeAdminView extends StatelessWidget {
  static const String routerName = 'employeeAdmin';
  static const String routerPath = '/employeeAdmin';
  const EmployeeAdminView({super.key});

  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: Scaffold(
        body: Center(
          child: Text('Employee Admin View'),
        ),
      ),
    );
  }
}