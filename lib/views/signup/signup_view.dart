import 'package:flutter/material.dart';
import 'package:smarttolls/utils/assets_images.dart';

class SignupView extends StatelessWidget {
  static const String routerName = 'signup';
  static const String routerPath = '/signup';
  const SignupView({super.key});

  @override
  Widget build(BuildContext context) {
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
              ],
            ),
          ),
        )
      ),
    );
  }
}