import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:smarttolls/generated/l10n.dart';
import 'package:smarttolls/providers/providers.dart';
import 'package:smarttolls/style/app_style.dart';
import 'package:smarttolls/utils/assets_images.dart';
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
                const SizedBox(height: 30),
                AssetsImages.map(height: 200, width: 200),
                AssetsImages.logo(height: 100, width: 200),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    S.of(context).email,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 2),
                CustomField(
                  hintText: S.of(context).email,
                  keyboardType: TextInputType.emailAddress,
                  onChanged: (value) {},
                ),
                const SizedBox(height: 16),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    S.of(context).password,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                CustomField(
                  hintText: S.of(context).password,
                  keyboardType: TextInputType.visiblePassword,
                  onChanged: (value) {},
                  obscureText: true,
                ),
                const SizedBox(height: 16),
                CustomButton(
                  onPressed: () => loginProvider.goHome(context), 
                  text: S.of(context).login,
                )
              ],
            ),
          ),
        )
      ),
    );
  }
}