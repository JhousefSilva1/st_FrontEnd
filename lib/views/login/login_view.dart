import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:smarttolls/utils/assets_images.dart';
import 'package:smarttolls/widgets/custom_button.dart';
import 'package:smarttolls/widgets/custom_field.dart';

class LoginView extends StatelessWidget {
  static const String routerName = 'login';
  static const String routerPath = '/login';
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 60),
                AssetsImages.map(height: 200, width: 200),
                AssetsImages.logo(height: 100, width: 200),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Inicia sesión',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 2),
                CustomField(
                  hintText: 'Correo electrónico',
                  keyboardType: TextInputType.emailAddress,
                  onChanged: (value) {},
                ),
                const SizedBox(height: 16),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Contraseña',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                CustomField(
                  hintText: 'Contraseña',
                  keyboardType: TextInputType.visiblePassword,
                  onChanged: (value) {},
                  obscureText: true,
                ),
                const SizedBox(height: 16),
                CustomButton(
                  onPressed: () {}, 
                  text: 'Iniciar sesión',
                )
              ],
            ),
          ),
        )
      ),
    );
  }
}