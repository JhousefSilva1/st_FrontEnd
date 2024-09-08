import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';
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
    bool isMobile = ResponsiveBreakpoints.of(context).smallerThan(TABLET);
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
                  if(isMobile) const SignUpMobileView(),
                  if(!isMobile) const SignUpTabletView(),
                ],
              ),
            ),
          ),
        )
      ),
    );
  }
}

class SignUpMobileView extends StatelessWidget {
  const SignUpMobileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const BackButton(),
        const SizedBox(height: 12),
        AssetsImages.logo(height: 100, width: 200),
        const SignUpForm()
      ],
    );
  }
}

class BackButton extends StatelessWidget {
  const BackButton({super.key});

  @override
  Widget build(BuildContext context) {
    final SignUpProvider signUpProvider = Provider.of<SignUpProvider>(context);
    return Align(
      alignment: Alignment.centerLeft,
      child: IconButton(
        onPressed: () => signUpProvider.goToWelcome(context), 
        icon: const Icon(Icons.arrow_back_ios, color: AppStyle.primary)
      ),
    );
  }
}

class SignUpTabletView extends StatelessWidget {
  const SignUpTabletView({super.key});

  @override
  Widget build(BuildContext context) {
    bool isDesktop = ResponsiveBreakpoints.of(context).smallerThan(DESKTOP);
    return GridView.count(
      shrinkWrap: true,
      primary: true,childAspectRatio: (0.7),
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const BackButton(),
            const SizedBox(height: 80),
            AssetsImages.map(height: isDesktop? MediaQuery.of(context).size.width * .2: MediaQuery.of(context).size.width * .3),
            AssetsImages.logo(height: isDesktop? MediaQuery.of(context).size.width * .1: MediaQuery.of(context).size.width * .15),
          ],
        ),
        const SignUpForm()
      ],
    );
  }
}

class SignUpForm extends StatelessWidget {
  const SignUpForm({super.key});

  @override
  Widget build(BuildContext context) {
    final SignUpProvider signUpProvider = Provider.of<SignUpProvider>(context);
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
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
          CustomField(
            hintText: S.of(context).lastNameF,
            keyboardType: TextInputType.name,
            onChanged: (value) {},
            prefixIcon: const Icon(Icons.person),
          ),
          const SizedBox(height: 8),
          CustomField(
            hintText: S.of(context).lastNameM,
            keyboardType: TextInputType.name,
            onChanged: (value) {},
            prefixIcon: const Icon(Icons.person),
          ),
          const SizedBox(height: 8),
          CustomField(
            hintText: S.of(context).name,
            keyboardType: TextInputType.name,
            prefixIcon: const Icon(Icons.person),
          ),
          const SizedBox(height: 8),
          CustomField(
            hintText: S.of(context).dni,
            keyboardType: TextInputType.text,
            onChanged: (value) {},
            prefixIcon: const Icon(Icons.credit_card),
          ),
          const SizedBox(height: 8),
          CustomField(
            hintText: S.of(context).phone,
            keyboardType: TextInputType.text,
            onChanged: (value) {},
            prefixIcon: const Icon(Icons.phone),
          ),
          const SizedBox(height: 8),
          CustomButton(
            backgroundColor: AppStyle.primaryLigth,
            onPressed: () => signUpProvider.goToSignUpStepTwo(context), 
            text: S.of(context).next,
          )
        ],
      ),
    );
  }
}