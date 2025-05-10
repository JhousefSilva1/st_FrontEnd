import 'package:flutter/material.dart';
import 'package:smarttolls/api/api.dart';
import 'package:smarttolls/generated/l10n.dart';
import 'package:smarttolls/style/app_style.dart';

class TollCard extends StatelessWidget {
  final StTollResponse toll;

  const TollCard({
    super.key,
    required this.toll,
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
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          children: [
            Expanded(
              child: Row(
                children: [
                  const SizedBox(width: 8),
                  const Icon(Icons.route, color: AppStyle.primary, size: 50),
                  const SizedBox(width: 16),
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Nombre del peaje
                        _buildInfoRow(context, S.of(context).toll, toll.tollsName ?? 'N/A'),
                        // Lugar
                        _buildInfoRow(context, S.of(context).place, toll.places.placeName ?? 'N/A'),
                        // Ciudad
                        _buildInfoRow(context, S.of(context).city, toll.places.city.cityName ?? 'N/A'),
                        // País
                        _buildInfoRow(context, S.of(context).country, toll.places.city.country.countryName ?? 'N/A'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () {
                      // Editar
                    },
                    child: const Icon(Icons.edit, color: AppStyle.primary),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () {
                      // Eliminar
                    },
                    child: const Icon(Icons.delete, color: AppStyle.red),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}