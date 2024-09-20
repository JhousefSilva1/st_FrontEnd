import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:smarttolls/generated/l10n.dart';
import 'package:smarttolls/providers/providers.dart';
import 'package:smarttolls/style/app_style.dart';
import 'package:smarttolls/utils/assets_images.dart';
import 'package:smarttolls/widgets/widgets.dart';

class SignUpStepTwoView extends StatelessWidget {
  static const String routerName = 'signUpStepTwoView';
  static const String routerPath = '/signUpStepTwoView';
  const SignUpStepTwoView({super.key});

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
                  if(isMobile) const SignUpTwoMobileView(),
                  if(!isMobile) const SignUpTwoTabletView()
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class SingUpBackButton extends StatelessWidget {
  const SingUpBackButton({super.key});

  @override
  Widget build(BuildContext context) {
    final SignUpProvider signUpProvider = Provider.of<SignUpProvider>(context);
    return Align(
      alignment: Alignment.centerLeft,
      child: IconButton(
        onPressed: () => signUpProvider.goToSignUp(context), 
        icon: const Icon(Icons.arrow_back_ios)
      ),
    );
  }
}

class SignUpTwoMobileView extends StatelessWidget {
  const SignUpTwoMobileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SingUpBackButton(),
        const SizedBox(height: 12),
        AssetsImages.logo(height: 100, width: 200),
        const SignUpTwoForm()
      ],
    );
  }
}

class SignUpTwoTabletView extends StatelessWidget {
  const SignUpTwoTabletView({super.key});

  @override
  Widget build(BuildContext context) {
    bool isDesktop = ResponsiveBreakpoints.of(context).smallerThan(DESKTOP);
    return GridView.count(
      childAspectRatio: (0.85),
      shrinkWrap: true,
      primary: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SingUpBackButton(),
            const SizedBox(height: 80),
            AssetsImages.map(height: isDesktop? MediaQuery.of(context).size.width * .2: MediaQuery.of(context).size.width * .3),
            AssetsImages.logo(height: isDesktop? MediaQuery.of(context).size.width * .1: MediaQuery.of(context).size.width * .15),
          ],
        ),
        const SignUpTwoForm()
      ],
    );
  }
}

class SignUpTwoForm extends StatelessWidget {
  const SignUpTwoForm({super.key});

  @override
  Widget build(BuildContext context) {
    final SignUpProvider signUpProvider = Provider.of<SignUpProvider>(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
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
          onPressed: () => signUpProvider.goHome(context), 
          text: S.of(context).register,
        )
      ],
    );
  }
}