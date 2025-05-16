import 'package:flutter/material.dart';
import 'package:smarttolls/api/api.dart';
import 'package:smarttolls/generated/l10n.dart';
import 'package:smarttolls/style/app_style.dart';

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
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Sección superior con avatar y nombre
          _buildTopSection(context),
          
          // Divisor
          const Divider(height: 1, thickness: 1),
          
          // Información con iconos
          Padding(
            padding: const EdgeInsets.all(16),
            child: _buildInfoSection(context),
          ),
          
          // Sección de ubicación
          _buildLocationSection(),
        ],
      ),
    );
  }

  Widget _buildTopSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Row(
        children: [
          // Avatar con icono
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppStyle.primary.withOpacity(0.1),
              border: Border.all(color: AppStyle.primary, width: 1.5),
            ),
            child: Icon(
              _getAvatarIcon(),
              size: 24,
              color: AppStyle.primary,
            ),
          ),
          
          const SizedBox(width: 12),
          
          // Nombre y tipo
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${person.personName ?? ''} ${person.personSurname ?? ''}'.trim(),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppStyle.primary.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    person.personType?.personType ?? 'N/A',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Botones de acción
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: Icon(Icons.edit, size: 20, color: AppStyle.primary),
                onPressed: onEdit,
              ),
              IconButton(
                icon: Icon(Icons.delete, size: 20, color: Colors.red[400]),
                onPressed: onDelete,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoSection(BuildContext context) {
    return Column(
      children: [
        _buildInfoItem(Icons.calendar_today, S.of(context).bornDate, _formatDate(person.personBirthdate)),
        const SizedBox(height: 12),
        _buildInfoItem(Icons.email, S.of(context).email, person.personEmail ?? 'N/A'),
        const SizedBox(height: 12),
        _buildInfoItem(Icons.phone, S.of(context).whatsApp, person.personWhatsappNumber ?? 'N/A'),
        const SizedBox(height: 12),
        _buildInfoItem(Icons.credit_card, S.of(context).dni, person.personDni ?? 'N/A'),
        const SizedBox(height: 12),
        _buildInfoItem(
          person.gender == 'M' ? Icons.male : Icons.female, 
          S.of(context).gender, 
          person.gender?.genderName ?? 'N/A'
        ),
      ],
    );
  }

  Widget _buildInfoItem(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: AppStyle.primary),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLocationSection() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppStyle.primary.withOpacity(0.03),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(12),
          bottomRight: Radius.circular(12),
        ),
      ),
      child: Row(
        children: [
          Icon(Icons.location_on, size: 18, color: AppStyle.primary),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              '${person.city?.cityName ?? 'N/A'}, ${person.country?.countryName ?? 'N/A'}',
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey[700],
              ),
            ),
          ),
        ],
      ),
    );
  }

  IconData _getAvatarIcon() {
    final type = person.personType?.personType?.toLowerCase() ?? '';
    if (type.contains('admin')) return Icons.admin_panel_settings;
    if (type.contains('driver')) return Icons.directions_car;
    if (type.contains('employee')) return Icons.work;
    if (type.contains('user')) return Icons.person;
    return Icons.person_outline;
  }

  String _formatDate(String? date) {
    if (date == null || date.isEmpty) return 'N/A';
    // Implementa tu lógica de formateo de fecha aquí
    return date;
  }
}