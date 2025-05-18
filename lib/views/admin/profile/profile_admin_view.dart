// profile_view.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smarttolls/api/response/st_person_response.dart';
import 'package:smarttolls/generated/l10n.dart';
import 'package:smarttolls/style/app_style.dart';
import 'package:smarttolls/widgets/widgets.dart';
import '../../../providers/providers.dart';

class ProfileView extends StatelessWidget {
  static const String routerName = 'profile';
  static const String routerPath = '/profile';

  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            // Para tablet (ancho mayor a 600) mostramos el drawer permanente
            if (constraints.maxWidth > 600) {
              return Row(
                children: [
                  const SmartTollsDrawer(),
                  Expanded(
                    child: _buildProfileContent(),
                  ),
                ],
              );
            }
            // Para mobile mostramos el contenido normal con posibilidad de abrir drawer
            return Scaffold(
              drawer: const SmartTollsDrawer(),
              appBar: CustomAppBar(
                centerTitle: true,
                text: S.of(context).profile,
              ),
              body: _buildProfileContent(),
            );
          },
        ),
      ),
    );
  }

  Widget _buildProfileContent() {
    return ChangeNotifierProvider(
      create: (_) => ProfileProvider()..loadCurrentUserData(),
      child: const ProfileContent(),
    );
  }
}

class ProfileContent extends StatelessWidget {
  const ProfileContent({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProfileProvider>(context);

    if (provider.isLoading && provider.currentUser == null) {
      return const Center(child: CircularProgressIndicator());
    }

    if (provider.errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(provider.errorMessage!),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: provider.retryLoading,
              child: Text(S.of(context).retry),
            ),
          ],
        ),
      );
    }

    final user = provider.currentUser;
    if (user == null) {
      return Center(child: Text(S.of(context).noUserData));
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        // Para tablet mostramos un diseño de dos columnas
        if (constraints.maxWidth > 600) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 1,
                  child: Column(
                    children: [
                      _buildProfileHeader(context, user),
                      const SizedBox(height: 32),
                      _buildPersonalInfoSection(context, user),
                    ],
                  ),
                ),
                const SizedBox(width: 24),
                Expanded(
                  flex: 1,
                  child: _buildContactInfoSection(context, user),
                ),
              ],
            ),
          );
        }
        // Para mobile mantenemos el diseño original de una columna
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              _buildProfileHeader(context, user),
              const SizedBox(height: 24),
              _buildPersonalInfoSection(context, user),
              const SizedBox(height: 24),
              _buildContactInfoSection(context, user),
            ],
          ),
        );
      },
    );
  }

  Widget _buildProfileHeader(BuildContext context, StPersonResponse user) {
    return Row(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppStyle.primary.withOpacity(0.1),
            border: Border.all(color: AppStyle.primary, width: 2),
          ),
          child: Icon(
            Icons.person,
            size: 40,
            color: AppStyle.primary,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${user.personName ?? ''} ${user.personSurname ?? ''}',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                user.personType?.personType ?? 'N/A',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPersonalInfoSection(BuildContext context, StPersonResponse user) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              S.of(context).personalInfo,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Divider(height: 24),
            _buildInfoRow(S.of(context).dni, user.personDni ?? 'N/A'),
            const SizedBox(height: 12),
            _buildInfoRow(S.of(context).bornDate, _formatDate(user.personBirthdate)),
            const SizedBox(height: 12),
            _buildInfoRow(S.of(context).age, user.personAge ?? 'N/A'),
            const SizedBox(height: 12),
            _buildInfoRow(S.of(context).gender, user.gender?.genderName ?? 'N/A'),
          ],
        ),
      ),
    );
  }

  Widget _buildContactInfoSection(BuildContext context, StPersonResponse user) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              S.of(context).contactInfo,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Divider(height: 24),
            _buildInfoRow(S.of(context).email, user.personEmail ?? 'N/A'),
            const SizedBox(height: 12),
            _buildInfoRow(S.of(context).whatsApp, user.personWhatsappNumber ?? 'N/A'),
            const SizedBox(height: 12),
            _buildInfoRow(S.of(context).address, user.personAddress ?? 'N/A'),
            const SizedBox(height: 12),
            _buildInfoRow(
              S.of(context).location, 
              '${user.city?.cityName ?? 'N/A'}, ${user.country?.countryName ?? 'N/A'}'
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 100,
          child: Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.grey[600],
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 16,
            ),
          ),
        ),
      ],
    );
  }

  String _formatDate(String? date) {
    if (date == null || date.isEmpty) return 'N/A';
    // Implementa tu lógica de formateo de fecha aquí
    return date;
  }
}