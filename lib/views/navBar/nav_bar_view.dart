import 'package:flutter/material.dart';
import 'package:smarttolls/style/app_style.dart';
import 'package:smarttolls/views/views.dart';
import 'package:smarttolls/widgets/widgets.dart';

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
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            CustomIcon(icon: Icon(Icons.home, color: AppStyle.primary), index: 0, label: 'Inicio', route: HomeView.routerName),
            CustomIcon(icon: Icon(Icons.car_repair_rounded, color: AppStyle.primary), index: 1, label: 'Vehiculos', route: VehiclesView.routerName),
            CustomIcon(icon: Icon(Icons.wallet_rounded, color: AppStyle.primary), index: 2, label: 'Billetera', route: WalletListView.routerName),
            CustomIcon(icon: Icon(Icons.notifications, color: AppStyle.primary), index: 3, label: 'Notificaciones', route: NotificationView.routerName),
          ],
        ),
      ),
    );
  }
}