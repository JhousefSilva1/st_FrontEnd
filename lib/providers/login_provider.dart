import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:smarttolls/views/login/login_view.dart';
import 'package:smarttolls/views/signup/signup_view.dart';

class LoginProvider extends ChangeNotifier {
  void login(BuildContext context) {
    context.pushNamed(LoginView.routerName);
  }

  void signup(BuildContext context) {
    context.pushNamed(SignupView.routerName);
  }
}