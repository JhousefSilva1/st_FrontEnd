import 'package:flutter/material.dart';
import 'package:smarttolls/api/response/admin/st_vehicles_colors_response.dart';
import 'package:smarttolls/style/app_style.dart';

class VehiclesColorsCard extends StatelessWidget {
  final StVehiclesColorsResponse color;
  final Function() onEdit;
  final Function() onDelete;

  const VehiclesColorsCard({
    super.key,
    required this.color,
    required this.onEdit,
    required this.onDelete,
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
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: AppStyle.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            Icons.color_lens,
            color: AppStyle.primary,
            size: 28,
          ),
        ),
        title: Text(
          color.colorName ?? 'N/A',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        subtitle: color.colorDescription != null 
            ? Text(
                color.colorDescription!,
                style: TextStyle(color: Colors.grey.shade600),
              )
            : null,
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
      ),
    );
  }
}