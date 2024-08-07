import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:smarttolls/generated/l10n.dart';
import 'package:smarttolls/providers/providers.dart';
import 'package:smarttolls/style/app_style.dart';
import 'package:smarttolls/utils/assets_images.dart';
import 'package:smarttolls/widgets/widgets.dart';

class SignupView extends StatelessWidget {
  static const String routerName = 'signup';
  static const String routerPath = '/signup';
  const SignupView({super.key});

  @override
  Widget build(BuildContext context) {
    final SignUpProvider signUpProvider = Provider.of<SignUpProvider>(context);
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Center(
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
                  AssetsImages.logo(height: 100, width: 200),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      S.of(context).welcome,
                      style: const TextStyle(color: AppStyle.primaryLigth, fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      S.of(context).createAccount,
                      style: const TextStyle(color: AppStyle.primaryLigth, fontSize: 20, fontWeight: FontWeight.w500),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const CustomProgressIndicator(current: 1, height: 4),
                  const SizedBox(height: 24),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      S.of(context).password,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 2),
                  CustomField(
                    hintText: S.of(context).password,
                    keyboardType: TextInputType.name,
                    onChanged: (value) {},
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      S.of(context).lastNameM,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 2),
                  CustomField(
                    hintText: S.of(context).lastNameM,
                    keyboardType: TextInputType.name,
                    onChanged: (value) {},
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      S.of(context).name,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 2),
                  CustomField(
                    hintText: S.of(context).name,
                    keyboardType: TextInputType.name,
                    onChanged: (value) {},
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      S.of(context).dni,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 2),
                  CustomField(
                    hintText: S.of(context).dni,
                    keyboardType: TextInputType.text,
                    onChanged: (value) {},
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      S.of(context).phone,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 2),
                  CustomField(
                    hintText: S.of(context).phone,
                    keyboardType: TextInputType.text,
                    onChanged: (value) {},
                  ),
                  const SizedBox(height: 8),
                  CustomButton(
                    backgroundColor: AppStyle.primaryLigth,
                    onPressed: () => signUpProvider.signUpStepTwo(context), 
                    text: S.of(context).next,
                  )
                ],
              ),
            ),
          ),
        )
      ),
    );
  }
}