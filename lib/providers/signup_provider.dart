import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:smarttolls/views/signup/signup_step_two_view.dart';

class SignUpProvider extends ChangeNotifier {
  void signUpStepTwo(BuildContext context) {	
    context.pushNamed(SignUpStepTwoView.routerName);
  }
}
  