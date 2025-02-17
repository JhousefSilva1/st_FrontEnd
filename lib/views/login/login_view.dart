import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:smarttolls/generated/l10n.dart';
import 'package:smarttolls/providers/providers.dart';
import 'package:smarttolls/style/app_style.dart';
import 'package:smarttolls/utils/assets_images.dart';
import 'package:smarttolls/utils/validators.dart';
import 'package:smarttolls/views/views.dart';
import 'package:smarttolls/widgets/widgets.dart';

class LoginView extends StatelessWidget {
  static const String routerName = 'login';
  static const String routerPath = '/login';
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    bool isMobile = ResponsiveBreakpoints.of(context).smallerThan(TABLET);
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if(isMobile) const LoginMobileView(),
                if(!isMobile) const LoginTabletView()
              ],
            ),
          ),
        )
      ),
    );
  }
}

class LoginMobileView extends StatelessWidget {
  const LoginMobileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(height: 80),
        AssetsImages.map(height: 100, width: 100),
        AssetsImages.logo(height: 100, width: 200),
        const SizedBox(height: 20),
        const LoginForm()
      ],
    );    
  }
}

class LoginTabletView extends StatelessWidget {
  const LoginTabletView({super.key});

  @override
  Widget build(BuildContext context) {
    bool isDesktop = ResponsiveBreakpoints.of(context).smallerThan(DESKTOP);
    return GridView.count(
      shrinkWrap: true,
      primary: true,childAspectRatio: (0.8),
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 80),
            AssetsImages.map(height: isDesktop? MediaQuery.of(context).size.width * .2: MediaQuery.of(context).size.width * .3),
            AssetsImages.logo(height: isDesktop? MediaQuery.of(context).size.width * .1: MediaQuery.of(context).size.width * .15),
          ],
        ),
        const LoginForm()
      ],
    );
  }
}

class LoginForm extends StatelessWidget {
  const LoginForm({super.key});

  @override
  Widget build(BuildContext context) {
    final LoginProvider loginProvider = Provider.of<LoginProvider>(context);
    return Form(
      key: loginProvider.formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            S.of(context).loginToYourAccount,
            style: const TextStyle(
              color: AppStyle.primary,
              fontSize: 20, 
              fontWeight: FontWeight.bold
            ),
          ),
          const SizedBox(height: 32),
          CustomField(
            hintText: S.of(context).email,
            keyboardType: TextInputType.emailAddress,
            onChanged: (value) => loginProvider.request.personEmail = value,
            prefixIcon: const Icon(Icons.email),
            validator: (value) {
              if(value.isEmpty) {
                return 'El correo electronico es requerido';
              }
              if(!isValidEmail.hasMatch(value)){
                return 'El correo electronico es invalido';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          CustomField(
            hintText: S.of(context).password,
            keyboardType: TextInputType.visiblePassword,
            obscureText: true,
            onChanged: (value) => loginProvider.request.personPassword = value,
            prefixIcon: const Icon(Icons.lock),
            validator: (value) {
              if(value.isEmpty) {
                return 'La contraseña es requerida';
              }
              return null;
            },
            // suffixIcon: GestureDetector(
            //   onTap: () => loginProvider.togglePasswordVisibility(),
            //   child: Icon(
            //     loginProvider.obscureText? Icons.visibility_off: Icons.visibility,
            //     color: AppStyle.primary,
            //   ),
            // ),
          ),
          const SizedBox(height: 16),
          CustomButton(
            onPressed: () => loginProvider.goHome(context), 
            text: S.of(context).login,
          ),
          const SizedBox(height: 16),
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
    );
  }
}