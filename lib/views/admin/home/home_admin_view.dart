import 'package:flutter/material.dart';

class HomeAdminView extends StatelessWidget {
  static const String routerName = 'homeAdmin';
  static const String routerPath = '/homeAdmin';
  const HomeAdminView({super.key});

  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: Scaffold(
        body: Center(
          child: Text('Home Admin View'),
        ),
      ),
    );
  }
}