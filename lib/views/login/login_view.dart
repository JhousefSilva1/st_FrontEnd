import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:smarttolls/generated/l10n.dart';
import 'package:smarttolls/providers/providers.dart';
import 'package:smarttolls/style/app_style.dart';
import 'package:smarttolls/utils/assets_images.dart';
import 'package:smarttolls/views/views.dart';
import 'package:smarttolls/widgets/widgets.dart';

class LoginView extends StatelessWidget {
  static const String routerName = 'login';
  static const String routerPath = '/login';
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    final LoginProvider loginProvider = Provider.of<LoginProvider>(context);
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    onPressed: () => context.pop(), 
                    icon: const Icon(Icons.arrow_back_ios, color: AppStyle.primary)
                  ),
                ),
                const SizedBox(height: 80),
                AssetsImages.map(height: 100, width: 100),
                AssetsImages.logo(height: 100, width: 200),
                const SizedBox(height: 20),
                Text(
                  S.of(context).loginToYourAccount,
                  style: const TextStyle(
                    color: AppStyle.primary,
                    fontSize: 20, 
                    fontWeight: FontWeight.bold
                  ),
                ),
                const SizedBox(height: 16),
                CustomField(
                  hintText: S.of(context).email,
                  keyboardType: TextInputType.emailAddress,
                  onChanged: (value) {},
                  prefixIcon: const Icon(Icons.email),
                ),
                const SizedBox(height: 16),
                CustomField(
                  hintText: S.of(context).password,
                  keyboardType: TextInputType.visiblePassword,
                  obscureText: true,
                  onChanged: (value) {},
                  prefixIcon: const Icon(Icons.lock),
                ),
                const SizedBox(height: 16),
                CustomButton(
                  onPressed: () => loginProvider.goHome(context), 
                  text: S.of(context).login,
                ),
                const SizedBox(height: 24),
                GestureDetector(
                  onTap: () => context.go(SignupView.routerPath),
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: S.of(context).dontHaveAnAccount,
                          style: const TextStyle(
                            color: AppStyle.primary,
                            fontSize: 16,
                            fontWeight: FontWeight.w500
                          ),
                        ),
                        TextSpan(
                          text: S.of(context).signUp,
                          style: const TextStyle(
                            color: AppStyle.primary,
                            fontSize: 16,
                            fontWeight: FontWeight.bold
                          ),
                        ),
                      ],
                      style: const TextStyle(
                        color: AppStyle.primary,
                        fontSize: 16,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        )
      ),
    );
  }
}