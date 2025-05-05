import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:smarttolls/api/response/st_brand_response.dart';
import 'package:smarttolls/generated/l10n.dart';
import 'package:smarttolls/providers/brand_provider.dart';
import 'package:smarttolls/style/app_style.dart';
import 'package:smarttolls/views/views.dart';

import '../providers/model_provider.dart';

class BrandsCard extends StatelessWidget {
  final StBrandResponse brand;

  const BrandsCard({
    super.key,
    required this.brand,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: AppStyle.white, width: 1),
        borderRadius: const BorderRadius.all(Radius.circular(8)),
        color: AppStyle.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 4,
            spreadRadius: 1
          ),
        ]
      ),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          children: [
            // Parte clickeable (excluyendo los íconos)
            Expanded(
              child: GestureDetector(
                  onTap: () {
                    final provider = Provider.of<ModelProvider>(context, listen: false);
                    provider.clearModels();
                    
                    // Opción 1: Usando pathParameters
                    context.pushNamed(
                      ModelsAdminView.routerName,
                      pathParameters: {'brandId': brand.idBrand.toString()},
                    );
                    
                    // Opción 2: Usando extra
                    // context.pushNamed(
                    //   ModelsAdminView.routerName,
                    //   extra: {'brandId': brand.idBrand},
                    // );
                  },
                child: Row(
                  children: [
                    const SizedBox(width: 8),
                    const Icon(Icons.drive_eta, color: AppStyle.primary, size: 50),
                    const SizedBox(width: 16),
                    Expanded(
                      flex: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                flex: 2,
                                child: Text(S.of(context).brand, 
                                  style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.w700)),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                flex: 2,
                                child: Text(brand.brandName ?? 'N/A', 
                                  style: const TextStyle(fontSize: 14.0, fontWeight: FontWeight.w500)),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                flex: 2,
                                child: Text(S.of(context).origin, 
                                  style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.w700)),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                flex: 2,
                                child: Text(brand.brandManufacturingCountry ?? 'N/A', 
                                  style: const TextStyle(fontSize: 14.0, fontWeight: FontWeight.w500)),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Íconos (no clickeables en el área principal)
            Expanded(
              flex: 2,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () {
                      // Editar
                    },
                    child: const Icon(Icons.edit, color: AppStyle.primary)
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () {
                      // Eliminar
                    },
                    child: const Icon(Icons.delete, color: AppStyle.primary)
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Pantalla de detalles de la marca (ejemplo)
