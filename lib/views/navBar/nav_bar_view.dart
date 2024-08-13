import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smarttolls/providers/providers.dart';
import 'package:smarttolls/style/app_style.dart';
import 'package:smarttolls/views/views.dart';

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
            CustomIcon(icon: Icon(Icons.wallet_rounded, color: AppStyle.primary), index: 2, label: 'Billetera', route: HomeView.routerName),
            CustomIcon(icon: Icon(Icons.notifications, color: AppStyle.primary), index: 3, label: 'Notificaciones', route: HomeView.routerName),
          ],
        ),
      ),
    );
  }
}

class CustomIcon extends StatelessWidget {
  const CustomIcon({super.key, required this.icon, required this.index, required this.label, required this.route});
  final Widget icon;
  final int index;
  final String label;
  final String route;

  @override
  Widget build(BuildContext context) {
    final homeProvider = Provider.of<HomeProvider>(context);
    return GestureDetector(
      onTap: () => homeProvider.changeNavBar(context, index, route),
      child: Container(
        decoration: BoxDecoration(
          color: homeProvider.currentIndex == index ? AppStyle.primary.withOpacity(0.3): Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 2, vertical: 6),
        padding: const EdgeInsets.all(6),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            icon,
            Text(label,
              style: const TextStyle(
                color: AppStyle.primary,
                fontSize: 12,
                fontWeight: FontWeight.w400
              ),
            )
          ],
        )
      ),
    );
  }
}