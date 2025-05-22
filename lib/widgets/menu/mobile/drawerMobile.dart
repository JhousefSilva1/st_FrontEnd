import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smarttolls/generated/l10n.dart';
import 'package:smarttolls/style/app_style.dart';
import 'package:smarttolls/utils/assets_images.dart';

import '../../../providers/providers.dart';

class SmartTollsMobileDrawer extends StatelessWidget{
  const SmartTollsMobileDrawer({super.key});

  @override
    Widget build(BuildContext context) {
    final DrawerProvider drawerProvider = Provider.of<DrawerProvider>(context);
    return Drawer(
      backgroundColor: AppStyle.white,
      surfaceTintColor: AppStyle.white,
      child: SingleChildScrollView(
        child: Column(
          children: [
            DrawerHeader(
              child: Column(
              children: [
                AssetsImages.logoAvatar(height: 70),
                const SizedBox(height: 8),
                Consumer<UserProvider>(
                  builder: (context, userProvider, child) {
                    return Column(
                      children: [
                        Text(
                          '${userProvider.name ?? ''} ${userProvider.lastName ?? ''}',
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        Text(
                         '${userProvider.role ?? ''} ${userProvider.personId ?? ''}',
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ],
                    );
                  },
                ),
              ],
              )
            ),
            DrawerListTile(icon: Icons.home, onTap: () => drawerProvider.goToHomeAdmin(context), title: S.of(context).home),
            DrawerListTile(icon: Icons.account_circle_rounded, onTap: () => drawerProvider.goToProfile(context), title: S.of(context).profile),
            DrawerListTile(icon: Icons.car_crash, onTap: () => drawerProvider.goToVehiclesCustomer(context), title: S.of(context).myVehicles),
            DrawerListTile(icon: Icons.wallet_outlined, onTap: (){}, title: S.of(context).wallet),
            DrawerListTile(icon: Icons.logout_rounded, onTap: () {}, title: S.of(context).logout),
          ],
        ),
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