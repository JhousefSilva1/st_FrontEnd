import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:overlay_loading_progress/overlay_loading_progress.dart';
import 'package:provider/provider.dart';
import 'package:smarttolls/api/api.dart';
import 'package:smarttolls/config/preferences.dart';
import 'package:smarttolls/providers/providers.dart';
import 'package:smarttolls/utils/utils.dart';
import 'package:smarttolls/views/views.dart';
import 'package:smarttolls/widgets/widgets.dart';

class LoginProvider extends ChangeNotifier {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  StAuthRequest request = StAuthRequest.createEmpty();
  void _showErrorDialog(BuildContext context, String title, String content) {
    if(context.mounted){
      Utils.dialogOption(
        content: content,
        context: context,
        iconData: Icons.close,
        title: title,
        width: MediaQuery.of(context).size.width * 0.6
      );
    }
  }

void goHome(BuildContext context) async {
  if(validateForm()){
    OverlayLoadingProgress.start(
      context,
      widget: const Loading(
        title: "Iniciando sesión",
        message: "Por favor espere...",
      ),
    );
    
    try {
      final response = await SmartTollsApi().autenticateUser(request);
      OverlayLoadingProgress.stop();
      
      if(response.isSuccess() && response.data != null){
        final token = response.data!; // Ya es del tipo StTokenRequest
        final data = SmartTollsApi().parseJwt(token.accessToken ?? '');
        
        // Guardar tokens y datos de usuario
        Preferences().setAccessToken(token.accessToken ?? '');
        Preferences().setRefreshToken(token.refreshToken ?? '');
        Preferences().setEmail(data['email'] ?? '');
        Preferences().setLastName(data['lastName'] ?? '');
        Preferences().setName(data['name'] ?? '');
        Preferences().setRole(data['roles']?[0] ?? ''); // Ajuste para el campo roles
        Preferences().setPersonId(data['personId'] ?? 0); // Si es null, guarda 0
        // En tu LoginProvider
        final userProvider = Provider.of<UserProvider>(context, listen: false);
        final role = data['roles']?[0] ?? '';
        userProvider.setUserData(
          data['name'] ?? '',
          data['lastName'] ?? '',
          role,
          data['email'] ?? '',
          data['personId'] ?? 0 

        );
        // Redirección basada en el rol
        if(context.mounted) {
          if(role == 'ROLE_ADMINISTRADOR'){
            context.goNamed(HomeAdminView.routerName);
          } else if(role == 'ROLE_CLIENTE') {
            context.goNamed(HomeView.routerName);
          }
        }
      } else if(response.isUnauthorized()){
        _showErrorDialog(context, 'Credenciales incorrectas', 
          'Por favor verifica tus credenciales e intenta nuevamente');
      } else {
        _showErrorDialog(context, 'Error', 
          response.message ?? 'Ha ocurrido un error inesperado');
      }
    } catch (e) {
      OverlayLoadingProgress.stop();
      _showErrorDialog(context, 'Error', 
        'Excepción durante el login: ${e.toString()}');
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
    context.pushNamed(SignUpView.routerName);
  }

  bool validateForm() {
    final isValid = formKey.currentState?.validate() ?? false;
    notifyListeners();
    return isValid;
  }

  
}

