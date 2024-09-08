import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:smarttolls/generated/l10n.dart';
import 'package:smarttolls/providers/providers.dart';
import 'package:smarttolls/style/app_style.dart';
import 'package:smarttolls/utils/assets_images.dart';
import 'package:smarttolls/widgets/widgets.dart';

class WelcomeView extends StatelessWidget {
  static const String routerName = 'welcome';
  static const String routerPath = '/';
  const WelcomeView({super.key});

  @override
  Widget build(BuildContext context) {
    bool isMobile = ResponsiveBreakpoints.of(context).smallerThan(TABLET);
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if(isMobile) const WelcomeMobileView(),
                if(!isMobile) const WelcomeTabletView(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class WelcomeMobileView extends StatelessWidget {
  const WelcomeMobileView({super.key});

  @override
  Widget build(BuildContext context) {
    final LoginProvider loginProvider = Provider.of<LoginProvider>(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AssetsImages.map(height: 200, width: 200),
        AssetsImages.logo(height: 100, width: 200),
        const SizedBox(height: 20),
        CustomButton(
          onPressed: () => loginProvider.login(context),  
          text: S.of(context).login,
        ),
        const SizedBox(height: 20),
        CustomButton(
          backgroundColor: AppStyle.primaryLigth,
          borderColor: AppStyle.primaryLigth,
          onPressed: () => loginProvider.signup(context),  
          text: S.of(context).signUp,
        ),
      ],
    );
  }
}

class WelcomeTabletView extends StatelessWidget {
  const WelcomeTabletView({super.key});

  @override
  Widget build(BuildContext context) {
    final LoginProvider loginProvider = Provider.of<LoginProvider>(context);
    bool isDesktop = ResponsiveBreakpoints.of(context).smallerThan(DESKTOP);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(
          children: [
            AssetsImages.map(height: 250, width: 250),
            AssetsImages.logo(height: 125, width: 250),
          ],
        ),
        SizedBox(width: isDesktop? MediaQuery.of(context).size.width * .05: MediaQuery.of(context).size.width * .1),
        Column(
          children: [
            AssetsImages.logoAvatar(height: isDesktop? MediaQuery.of(context).size.width * .2: MediaQuery.of(context).size.width * .3),
            const SizedBox(height: 60),
            CustomButton(
              width: isDesktop? MediaQuery.of(context).size.width * .2: MediaQuery.of(context).size.width * .3,
              onPressed: () => loginProvider.login(context),  
              text: S.of(context).login,
            ),
            const SizedBox(height: 20),
            CustomButton(
              width: isDesktop? MediaQuery.of(context).size.width * .2: MediaQuery.of(context).size.width * .3,
              backgroundColor: AppStyle.primaryLigth,
              borderColor: AppStyle.primaryLigth,
              onPressed: () => loginProvider.signup(context),  
              text: S.of(context).signUp,
            ),
          ],
        )
      ],
    );
  }
}