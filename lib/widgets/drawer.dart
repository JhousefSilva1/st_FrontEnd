import 'package:flutter/material.dart';
import 'package:smarttolls/generated/l10n.dart';
import 'package:smarttolls/style/app_style.dart';
import 'package:smarttolls/utils/assets_images.dart';

class SmartTollsDrawer extends StatelessWidget {
  const SmartTollsDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppStyle.white,
      surfaceTintColor: AppStyle.white,
      child: Column(
        children: [
          DrawerHeader(
            child: Column(
              children: [
                AssetsImages.logoAvatar(height: 70),
                const SizedBox(height: 8),
                const Text(
                  'Jose Pozo',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const Text(
                  'Administrador',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            )
          ),
          DrawerListTile(icon: Icons.home, onTap: () => print('1'), title: S.of(context).home),
          DrawerListTile(icon: Icons.account_circle_rounded, onTap: () => print('2'), title: S.of(context).profile),
          DrawerListTile(icon: Icons.car_repair_rounded, onTap: () => print('3'), title: S.of(context).vehicles),
          DrawerListTile(icon: Icons.supervised_user_circle_rounded, onTap: () => print('4'), title: S.of(context).staff),
          DrawerListTile(icon: Icons.business_outlined, onTap: () => print('5'), title: S.of(context).tolls),
          DrawerListTile(icon: Icons.auto_graph_rounded, onTap: () => print('6'), title: S.of(context).reports),
          const Spacer(),
          DrawerListTile(icon: Icons.logout_rounded, onTap: () => print('7'), title: S.of(context).logout),
        ],
      ),
    );
  }
}

class DrawerListTile extends StatelessWidget {
  const DrawerListTile({
    super.key,
    required this.icon,
    required this.onTap,
    required this.title
  });
  final IconData icon;
  final Function() onTap;
  final String title;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ListTile(
        leading: Icon(
          icon,
          color: AppStyle.primary,
          size: 30,
        ),
        title: Text(title, style: const TextStyle(color: AppStyle.primary, fontSize: 18, fontWeight: FontWeight.w600),),
      ),
    );
  }
}