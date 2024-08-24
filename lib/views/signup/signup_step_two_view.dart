import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
// import 'package:provider/provider.dart';
import 'package:smarttolls/generated/l10n.dart';
// import 'package:smarttolls/providers/providers.dart';
import 'package:smarttolls/style/app_style.dart';
import 'package:smarttolls/utils/assets_images.dart';
import 'package:smarttolls/widgets/widgets.dart';

class SignUpStepTwoView extends StatelessWidget {
  static const String routerName = 'signUpStepTwoView';
  static const String routerPath = '/signUpStepTwoView';
  const SignUpStepTwoView({super.key});

  @override
  Widget build(BuildContext context) {
    // final SignUpProvider signUpProvider = Provider.of<SignUpProvider>(context);
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
                      icon: const Icon(Icons.arrow_back_ios)
                    ),
                  ),
                  const SizedBox(height: 12),
                  AssetsImages.logo(height: 100, width: 200),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      S.of(context).lastOneStep,
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
                  const CustomProgressIndicator(current: 2, height: 4),
                  const SizedBox(height: 24),
                  CustomField(
                    hintText: S.of(context).email,
                    keyboardType: TextInputType.emailAddress,
                    onChanged: (value) {},
                    prefixIcon: const Icon(Icons.email),
                  ),
                  const SizedBox(height: 8),
                  CustomField(
                    hintText: S.of(context).password,
                    keyboardType: TextInputType.visiblePassword,
                    onChanged: (value) {},
                    prefixIcon: const Icon(Icons.lock),
                  ),
                  const SizedBox(height: 8),
                  CustomField(
                    hintText: S.of(context).confirmPassword,
                    keyboardType: TextInputType.visiblePassword,
                    onChanged: (value) {},
                    prefixIcon: const Icon(Icons.lock),
                  ),
                  const SizedBox(height: 16),
                  CustomButton(
                    backgroundColor: AppStyle.primaryLigth,
                    onPressed: () {}, 
                    text: S.of(context).register,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}