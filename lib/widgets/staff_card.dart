import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:smarttolls/api/api.dart';
import 'package:smarttolls/style/app_style.dart';

class StaffCard extends StatelessWidget {
  final StPersonResponse staff;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const StaffCard({
    super.key,
    required this.staff,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Avatar/Icon section
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: AppStyle.primary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.person,
                color: AppStyle.primary,
                size: 30,
              ),
            ),
            const SizedBox(width: 16),
            
            // Info section
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name and status
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          '${staff.personName ?? 'Nombre no disponible'} ${staff.personSurname ?? ''}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: staff.personStatus == 1 
                              ? Colors.green.withOpacity(0.2)
                              : Colors.red.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          staff.personStatus == 1 ? 'Activo' : 'Inactivo',
                          style: TextStyle(
                            color: staff.personStatus == 1 
                                ? Colors.green
                                : Colors.red,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 4),
                  
                  // Type and gender
                  Row(
                    children: [
                      _buildInfoChip(
                        icon: Icons.work,
                        text: staff.personType.personType ?? 'Sin tipo',
                      ),
                      const SizedBox(width: 8),
                      _buildInfoChip(
                        icon: Icons.person_outline,
                        text: staff.gender.genderName ?? 'Sin género',
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 8),
                  
                  // Contact info
                  _buildInfoRow(
                    icon: Icons.email,
                    text: staff.personEmail ?? 'Sin email',
                  ),
                  const SizedBox(height: 4),
                  _buildInfoRow(
                    icon: Icons.phone,
                    text: staff.personWhatsappNumber ?? 'Sin teléfono',
                  ),
                  const SizedBox(height: 4),
                  _buildInfoRow(
                    icon: Icons.credit_card,
                    text: 'DNI: ${staff.personDni ?? 'N/A'}',
                  ),
                  const SizedBox(height: 4),
                  _buildInfoRow(
                    icon: Icons.cake,
                    text: 'Edad: ${staff.personAge ?? 'N/A'}',
                  ),
                ],
              ),
            ),
            
            // Actions section
            Column(
              children: [
                IconButton(
                  icon: const Icon(Icons.edit, size: 22),
                  color: AppStyle.primary,
                  onPressed: onEdit,
                ),
                IconButton(
                  icon: const Icon(Icons.delete, size: 22),
                  color: AppStyle.red,
                  onPressed: onDelete,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow({required IconData icon, required String text}) {
    return Row(
      children: [
        Icon(
          icon,
          size: 16,
          color: AppStyle.greyDark,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 13,
              color: AppStyle.greyDark,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoChip({required IconData icon, required String text}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppStyle.greyLight.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 14,
            color: AppStyle.greyDark,
          ),
          const SizedBox(width: 4),
          Text(
            text,
            style: const TextStyle(
              fontSize: 12,
              color: AppStyle.greyDark,
            ),
          ),
        ],
      ),
    );
  }
}