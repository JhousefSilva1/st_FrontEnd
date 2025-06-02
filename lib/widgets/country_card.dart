import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:smarttolls/api/api.dart';
import 'package:smarttolls/generated/l10n.dart';
import 'package:smarttolls/style/app_style.dart';
import 'package:smarttolls/views/views.dart';

class CountryCard extends StatelessWidget {
  final StCountryResponse country;
  final Function() onEdit;
  final Function() onDelete;

  const CountryCard({
    super.key,
    required this.country,
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
            Icons.public,
            color: AppStyle.primary,
            size: 28,
          ),
        ),
        title: Text(
          country.countryName ?? 'N/A',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
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
        onTap: () {
          context.goNamed(
            CityAdminView.routerName,
            pathParameters: {'idCountry': country.idCountry.toString()},
          );
        },
      ),
    );
  }
}