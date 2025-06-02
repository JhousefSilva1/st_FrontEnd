import 'package:flutter/material.dart';
import 'package:smarttolls/api/api.dart';

import '../generated/l10n.dart';
import '../style/app_style.dart';
class PersonsCard extends StatelessWidget {
  final StPersonResponse person;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const PersonsCard({
    super.key,
    required this.person,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: AppStyle.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            _getAvatarIcon(),
            color: AppStyle.primary,
            size: 28,
          ),
        ),
        title: Text(
          '${person.personName ?? ''} ${person.personSurname ?? ''}'.trim(),
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        subtitle: Text(
          person.personType.personType ?? 'N/A',
          style: TextStyle(color: Colors.grey.shade600),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit, color: AppStyle.yellow),
              onPressed: onEdit,
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: AppStyle.red),
              onPressed: onDelete,
            ),
          ],
        ),
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildInfoRow(Icons.calendar_today, S.of(context).bornDate, _formatDate(person.personBirthdate)),
                const SizedBox(height: 8),
                _buildInfoRow(Icons.email, S.of(context).email, person.personEmail ?? 'N/A'),
                const SizedBox(height: 8),
                _buildInfoRow(Icons.phone, S.of(context).whatsApp, person.personWhatsappNumber ?? 'N/A'),
                const SizedBox(height: 8),
                _buildInfoRow(Icons.credit_card, S.of(context).dni, person.personDni ?? 'N/A'),
                const SizedBox(height: 8),
                _buildInfoRow(
                  person.gender == 'M' ? Icons.male : Icons.female,
                  S.of(context).gender,
                  person.gender.genderName ?? 'N/A'
                ),
                const SizedBox(height: 8),
                _buildInfoRow(
                  Icons.location_on,
                  S.of(context).location,
                  '${person.city.cityName ?? 'N/A'}, ${person.country.countryName ?? 'N/A'}'
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: AppStyle.primary),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
      ],
    );
  }

  IconData _getAvatarIcon() {
    final type = person.personType.personType?.toLowerCase() ?? '';
    if (type.contains('admin')) return Icons.admin_panel_settings;
    if (type.contains('driver')) return Icons.directions_car;
    if (type.contains('employee')) return Icons.work;
    if (type.contains('user')) return Icons.person;
    return Icons.person_outline;
  }

  String _formatDate(String? date) {
    if (date == null || date.isEmpty) return 'N/A';
    return date;
  }
}