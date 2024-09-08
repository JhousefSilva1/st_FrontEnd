import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:smarttolls/views/views.dart';

class LoginProvider extends ChangeNotifier {
  void goHome(BuildContext context){
    context.goNamed(HomeView.routerName);
  }

  void goToSelectMode(BuildContext context){
    context.goNamed(SelectModeView.routerName);
  }

  void login(BuildContext context) {
    context.pushNamed(LoginView.routerName);
  }

  void signup(BuildContext context) {
    context.pushNamed(SignupView.routerName);
  }
}