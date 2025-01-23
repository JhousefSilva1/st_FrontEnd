import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:overlay_loading_progress/overlay_loading_progress.dart';
import 'package:smarttolls/api/api.dart';
import 'package:smarttolls/config/preferences.dart';
import 'package:smarttolls/utils/utils.dart';
import 'package:smarttolls/views/views.dart';
import 'package:smarttolls/widgets/widgets.dart';

class LoginProvider extends ChangeNotifier {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  StAuthRequest request = StAuthRequest.createEmpty();

  void goHome(BuildContext context) async {
    if(validateForm()){
      OverlayLoadingProgress.start(
        context,
        widget: const Loading(
          title: "Iniciando sesión",
          message: "Por favor espere...",
        ),
      );
      Future.delayed(const Duration(seconds: 100), () {});
      final response = await SmartTollsApi().autenticateUser(request);
      OverlayLoadingProgress.stop();
      if(response.isSuccess()){
        final StTokenRequest token = response.data as StTokenRequest;
        final data = SmartTollsApi().parseJwt(token.accessToken ?? '');
        Preferences().setAccessToken(token.accessToken ?? '');
        Preferences().setRefreshToken(token.refreshToken ?? '');
        Preferences().setEmail(data['email']);
        Preferences().setLastName(data['lastName']);
        Preferences().setName(data['name']);
        Preferences().setRole(data['role']);
        if(data['role'] == 'ROLE_ADMIN'){
          if(context.mounted) context.goNamed(HomeAdminView.routerName);
        } else if(data['role'] == 'ROLE_CUSTOMER'){
          if(context.mounted) context.goNamed(HomeView.routerName);
        } else {
          if(context.mounted) context.goNamed(HomeView.routerName);
        }
      } else if(response.isUnauthorized()){
        if(context.mounted){
          Utils.dialogOption(
            content: 'Por favor verifica tus credenciales e intenta nuevamente',
            context: context,
            iconData: Icons.close,
            title: 'Credenciales incorrectas',
            width: MediaQuery.of(context).size.width * 0.6
          );
        }
      } else {
        if(context.mounted){
          Utils.dialogOption(
            content: 'Ha ocurrido un error inesperado, por favor intenta nuevamente',
            context: context,
            iconData: Icons.close,
            title: 'Error',
            width: MediaQuery.of(context).size.width * 0.6
          );
        }
      }
    }
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

  bool validateForm() {
    final isValid = formKey.currentState?.validate() ?? false;
    notifyListeners();
    return isValid;
  }
}

