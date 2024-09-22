import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:smarttolls/views/views.dart';

class TollProvider extends ChangeNotifier {
  void goToAddTollAdmin(BuildContext context) {
    context.pushNamed(AddTollAdminView.routerName);
  }
}