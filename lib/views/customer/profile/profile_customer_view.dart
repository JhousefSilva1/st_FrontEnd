import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smarttolls/api/response/admin/st_person_response.dart';
import 'package:smarttolls/generated/l10n.dart';
import 'package:smarttolls/style/app_style.dart';
import 'package:smarttolls/widgets/menu/mobile/drawerMobile.dart';
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
        // drawer: const SmartTollsMobileDrawer(),
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
        children: [
          _TopBackgroundWave(),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: _ProfileBody(),
          ),
        ],
      ),
    );
  }
}

class _TopBackgroundWave extends StatelessWidget {
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
    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        firstEndPoint.dx, firstEndPoint.dy);

    final secondControlPoint =
        Offset(size.width - (size.width / 4), size.height - 70);
    final secondEndPoint = Offset(size.width, size.height - 50);
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
        secondEndPoint.dx, secondEndPoint.dy);

    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class _ProfileBody extends StatelessWidget {
  const _ProfileBody();

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProfileProvider>(context);

    if (provider.isLoading && provider.currentUser == null) {
      return const _LoadingIndicator();
    }

    if (provider.errorMessage != null) {
      return _ErrorView(
        errorMessage: provider.errorMessage!,
        onRetry: provider.retryLoading,
      );
    }

    final user = provider.currentUser;
    if (user == null) {
      return _NoUserDataView();
    }

    return Column(
      children: [
        const SizedBox(height: 20),
        _UserProfileCard(user: user),
        const SizedBox(height: 24),
        _InfoSection(
          title: S.of(context).personalInfo,
          children: [
            _InfoItem(
              icon: Icons.credit_card,
              label: S.of(context).dni,
              value: user.personDni ?? 'N/A',
            ),
            _InfoItem(
              icon: Icons.cake,
              label: S.of(context).bornDate,
              value: _formatDate(user.personBirthdate),
            ),
            _InfoItem(
              icon: Icons.timeline,
              label: S.of(context).age,
              value: user.personAge ?? 'N/A',
            ),
            _InfoItem(
              icon: Icons.transgender,
              label: S.of(context).gender,
              value: user.gender?.genderName ?? 'N/A',
            ),
          ],
        ),
        const SizedBox(height: 16),
        _InfoSection(
          title: S.of(context).contactInfo,
          children: [
            _InfoItem(
              icon: Icons.email,
              label: S.of(context).email,
              value: user.personEmail ?? 'N/A',
            ),
            _InfoItem(
              icon: Icons.phone,
              label: S.of(context).whatsApp,
              value: user.personWhatsappNumber ?? 'N/A',
            ),
            _InfoItem(
              icon: Icons.home,
              label: S.of(context).address,
              value: user.personAddress ?? 'N/A',
            ),
            _InfoItem(
              icon: Icons.location_on,
              label: S.of(context).location,
              value:
                  '${user.city?.cityName ?? 'N/A'}, ${user.country?.countryName ?? 'N/A'}',
            ),
          ],
        ),
        const SizedBox(height: 40),
      ],
    );
  }
}

class _UserProfileCard extends StatelessWidget {
  final StPersonResponse user;

  const _UserProfileCard({required this.user});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      shadowColor: AppStyle.primary.withOpacity(0.2),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [
                    AppStyle.primary,
                    AppStyle.primary.withOpacity(0.7),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppStyle.primary.withOpacity(0.3),
                    blurRadius: 10,
                    spreadRadius: 2,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Center(
                child: Icon(
                  Icons.person,
                  size: 50,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              '${user.personName ?? ''} ${user.personSurname ?? ''}',
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 6,
              ),
              decoration: BoxDecoration(
                color: AppStyle.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                user.personType?.personType ?? 'N/A',
                style: TextStyle(
                  fontSize: 14,
                  color: AppStyle.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoSection extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _InfoSection({
    required this.title,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppStyle.primary,
              ),
            ),
            const SizedBox(height: 16),
            ...children,
          ],
        ),
      ),
    );
  }
}

class _InfoItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoItem({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppStyle.primary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: 20,
              color: AppStyle.primary,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _LoadingIndicator extends StatelessWidget {
  const _LoadingIndicator();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(AppStyle.primary),
              strokeWidth: 3,
            ),
            const SizedBox(height: 16),
            Text(
              S.of(context).loadingProfile,
              style: TextStyle(
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String errorMessage;
  final VoidCallback onRetry;

  const _ErrorView({
    required this.errorMessage,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 48,
              color: Colors.red[400],
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                errorMessage,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[700],
                ),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: onRetry,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppStyle.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
              child: Text(
                S.of(context).retry,
                style: const TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NoUserDataView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.person_off,
              size: 48,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              S.of(context).noUserData,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

String _formatDate(String? date) {
  if (date == null || date.isEmpty) return 'N/A';
  return date;
}