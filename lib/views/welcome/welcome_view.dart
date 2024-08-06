import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smarttolls/providers/login_provider.dart';
import 'package:smarttolls/style/app_style.dart';
import 'package:smarttolls/utils/assets_images.dart';
import 'package:smarttolls/widgets/custom_button.dart';

class WelcomeView extends StatelessWidget {
  static const String routerName = 'welcome';
  static const String routerPath = '/';
  const WelcomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final LoginProvider loginProvider = Provider.of<LoginProvider>(context);
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AssetsImages.map(height: 200, width: 200),
                AssetsImages.logo(height: 100, width: 200),
                const SizedBox(height: 20),
                CustomButton(
                  onPressed: () => loginProvider.login(context),  
                  text: 'Iniciar Sesión',
                ),
                const SizedBox(height: 20),
                CustomButton(
                  backgroundColor: AppStyle.primaryLigth,
                  onPressed: () => loginProvider.signup(context),  
                  text: 'Registrate',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}