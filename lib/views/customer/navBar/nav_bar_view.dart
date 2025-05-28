import 'package:flutter/material.dart';
import 'package:smarttolls/style/app_style.dart';
import 'package:smarttolls/views/views.dart';
import 'package:smarttolls/widgets/widgets.dart';

import '../../../generated/l10n.dart';

class NavBarView extends StatelessWidget {
  const NavBarView({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppStyle.white,
          boxShadow: [
            BoxShadow(
              color: AppStyle.black.withOpacity(0.1),
              blurRadius: 5,
              spreadRadius: 2,
            ),
          ],
        ),
        height: 72,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            CustomIcon(icon: Icon(Icons.home, color: AppStyle.primary), index: 0, label: 'Inicio', route: HomeView.routerName),
            CustomIcon(icon: Icon(Icons.account_circle_rounded, color: AppStyle.primary), index: 1, label: S.of(context).profile, route: ProfileCustomerView.routerName),
            CustomIcon(icon: Icon(Icons.car_crash_outlined, color: AppStyle.primary), index: 3, label: S.of(context).vehicle, route: VehiclesCustomerView.routerName),
            CustomIcon(icon: Icon(Icons.wallet_outlined, color: AppStyle.primary), index: 4, label: S.of(context).wallet, route: WalletView.routerName),
            // logout button
            CustomIcon(icon: Icon(Icons.logout, color: AppStyle.primary), index: 5, label: S.of(context).logout, route: WelcomeView.routerName),

          ],
        ),
      ),
    );
  }
}