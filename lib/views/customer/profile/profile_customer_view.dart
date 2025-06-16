import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smarttolls/style/app_style.dart';
import 'package:smarttolls/generated/l10n.dart';
import 'package:smarttolls/widgets/widgets.dart';
import '../../../providers/providers.dart';


class ProfileCustomerView extends StatelessWidget {
  static const String routerName = 'profileCustomer';
  static const String routerPath = '/profileCustomer';

  const ProfileCustomerView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ProfileProvider()..loadCurrentUserData(),
      child: Scaffold(
        backgroundColor: AppStyle.backgroundModern,
        appBar: CustomAppBar(
          centerTitle: true,
          text: S.of(context).profile,
          backgroundColor: AppStyle.backgroundModern,
        ),
        body: const _ProfileContent(),
      ),
    );
  }
}

class _ProfileContent extends StatelessWidget {
  const _ProfileContent();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: const [
          _TopBackgroundWave(),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: ProfileCustomerCard(),
          ),
        ],
      ),
    );
  }
}

class _TopBackgroundWave extends StatelessWidget {
  const _TopBackgroundWave();

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: WaveClipper(),
      child: Container(
        height: 160,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppStyle.primary,
              AppStyle.primary.withOpacity(0.8),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
      ),
    );
  }
}

class WaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height - 50);

    final firstControlPoint = Offset(size.width / 4, size.height);
    final firstEndPoint = Offset(size.width / 2, size.height - 30);
    path.quadraticBezierTo(
        firstControlPoint.dx, firstControlPoint.dy, firstEndPoint.dx, firstEndPoint.dy);

    final secondControlPoint =
        Offset(size.width - (size.width / 4), size.height - 70);
    final secondEndPoint = Offset(size.width, size.height - 50);
    path.quadraticBezierTo(
        secondControlPoint.dx, secondControlPoint.dy, secondEndPoint.dx, secondEndPoint.dy);

    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
