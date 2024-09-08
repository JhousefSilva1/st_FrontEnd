import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:smarttolls/views/views.dart';

class SignUpProvider extends ChangeNotifier {
  void goHome(BuildContext context){
    context.goNamed(HomeView.routerName);
  }

  void goToSignUp(BuildContext context) {	
    context.pushNamed(SignupView.routerName);
  }

  void goToSignUpStepTwo(BuildContext context) {	
    context.pushNamed(SignUpStepTwoView.routerName);
  }

  void goToWelcome(BuildContext context) {	
    context.pushNamed(WelcomeView.routerName);
  }
}