import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:smarttolls/api/api.dart';
import 'package:smarttolls/providers/providers.dart';
import 'package:smarttolls/style/app_style.dart';
import 'package:smarttolls/widgets/menu/desktop/drawer_operador.dart';
import 'package:smarttolls/widgets/menu/mobile/drawerMobile.dart';
import 'package:smarttolls/widgets/widgets.dart';

import '../../../generated/l10n.dart';

class ProfileOperadorView extends StatelessWidget {
  static const String routerName = 'priofileOperador';
  static const String routerPath = '/profileOperador';

  const ProfileOperadorView({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveBreakpoints.of(context).smallerThan(TABLET);

    return ChangeNotifierProvider(
      create: (_) => ProfileProvider()..loadCurrentUserData(),
      child: Scaffold(
        backgroundColor: Colors.grey.shade100,
        drawer: isMobile ? const SmartTollsMobileDrawer() : null,
        appBar: isMobile
            ? AppBar(
                title: Text(
                  S.of(context).profile,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                backgroundColor: AppStyle.primary,
                iconTheme: const IconThemeData(color: Colors.white),
              )
            : null,
        body: Row(
          children: [
            if (!isMobile) const SmartTollsOperadorDrawer(),
            const Expanded(child: ProfileOperadorContent()),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
          backgroundColor: AppStyle.primary,
          child: const Icon(Icons.edit),
        ),
      ),
    );
  }
}

class ProfileOperadorContent extends StatelessWidget {
  const ProfileOperadorContent({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ProfileProvider>();
    final user = provider.currentUser;

    if (provider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (provider.errorMessage != null) {
      return Center(
        child: Text(provider.errorMessage!, style: const TextStyle(color: Colors.red)),
      );
    }

    if (user == null) {
      return Center(child: Text(S.of(context).noUserData));
    }

    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [AppStyle.primary, Color(0xFF1976D2)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(32)),
            ),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 48,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.person, size: 48, color: AppStyle.primary),
                ),
                const SizedBox(height: 12),
                Text(
                  '${user.personName ?? ''} ${user.personSurname ?? ''}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  user.personType?.personType ?? '',
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                ProfileSectionCard(
                  title: S.of(context).personalInfo,
                  icon: Icons.info,
                  children: [
                    ProfileInfoRow(label: S.of(context).dni, value: user.personDni ?? ''),
                    ProfileInfoRow(label: S.of(context).bornDate, value: _formatDate(user.personBirthdate)),
                    ProfileInfoRow(label: S.of(context).age, value: '${user.personAge ?? 'N/A'} años'),
                    ProfileInfoRow(label: S.of(context).gender, value: user.gender?.genderName ?? ''),
                  ],
                ),
                const SizedBox(height: 24),
                ProfileSectionCard(
                  title: S.of(context).contactInfo,
                  icon: Icons.contact_mail,
                  children: [
                    ProfileInfoRow(label: S.of(context).email, value: user.personEmail ?? ''),
                    ProfileInfoRow(label: S.of(context).whatsApp, value: user.personWhatsappNumber ?? ''),
                    ProfileInfoRow(label: S.of(context).address, value: user.personAddress ?? ''),
                    ProfileInfoRow(
                      label: S.of(context).location,
                      value: '${user.city?.cityName ?? ''}, ${user.country?.countryName ?? ''}',
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(String? date) {
    if (date == null || date.isEmpty) return 'N/A';
    return date;
  }
}
