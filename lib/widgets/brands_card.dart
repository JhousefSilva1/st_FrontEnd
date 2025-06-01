import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:smarttolls/api/response/admin/st_brand_response.dart';
import 'package:smarttolls/generated/l10n.dart';
import 'package:smarttolls/style/app_style.dart';
import 'package:smarttolls/views/views.dart';


class BrandCard extends StatelessWidget {
  final StBrandResponse brand;

  const BrandCard({super.key, required this.brand});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Logo/Icono
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: AppStyle.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Icons.directions_car, 
                  color: AppStyle.primary, size: 32),
              ),
              const SizedBox(width: 16),
              
              // Información
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      brand.brandName ?? 'N/A',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    if (brand.brandDescription?.isNotEmpty ?? false)
                      Text(
                        brand.brandDescription!,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                  ],
                ),
              ),
              
              // País y acciones
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppStyle.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.public, 
                          color: AppStyle.primary, size: 14),
                        const SizedBox(width: 4),
                        Text(
                          brand.brandManufacturingCountry ?? 'N/A',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppStyle.primary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit, 
                          color: AppStyle.yellow, size: 22),
                        onPressed: () => showEditBrandDialog(context, brand),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete_outline, 
                          color: AppStyle.red, size: 22),
                        onPressed: () => showDeleteBrandDialog(context, brand),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Pantalla de detalles de la marca (ejemplo)
