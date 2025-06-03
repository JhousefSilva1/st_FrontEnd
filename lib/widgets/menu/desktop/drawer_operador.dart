import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smarttolls/generated/l10n.dart';
import 'package:smarttolls/style/app_style.dart';

import '../../../providers/drawer_provider.dart';
import '../../../providers/providers.dart';
import '../../../utils/assets_images.dart';

class SmartTollsOperadorDrawer extends StatelessWidget{
  const SmartTollsOperadorDrawer({super.key});

  @override
  Widget build(BuildContext context){
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
                          '${(userProvider.role ?? '').replaceFirst('ROLE_', '')} ${userProvider.personId ?? ''}',
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),

                      ],
                    );
                  },
                ),
              ],
              )
            ),
            // list of menu items
            DrawerListTile(icon: Icons.home_outlined, onTap:() => drawerProvider.goToHomeOperador(context), title: S.of(context).home),
            DrawerListTile(icon: Icons.account_circle_rounded, onTap: () => drawerProvider.goToProfileOperador(context), title: S.of(context).profile),
            DrawerListTile(icon: Icons.toll_sharp, onTap: () => drawerProvider.goToVehiclesOperador(context), title: S.of(context).tolls),
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