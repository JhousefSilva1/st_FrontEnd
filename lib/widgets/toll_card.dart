import 'package:flutter/material.dart';
import 'package:smarttolls/api/api.dart';
import 'package:smarttolls/generated/l10n.dart';
import 'package:smarttolls/style/app_style.dart';

class TollCard extends StatelessWidget {
  final StTollsResponse toll;

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
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: Text(S.of(context).tollName,
                                  style: const TextStyle(
                                      fontSize: 16.0, fontWeight: FontWeight.w700)),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              flex: 2,
                              child: Text(toll.tollsName ?? 'N/A',
                                  style: const TextStyle(
                                      fontSize: 16.0, fontWeight: FontWeight.w700)),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: Text(S.of(context).place,
                                  style: const TextStyle(
                                      fontSize: 14.0, fontWeight: FontWeight.w500)),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              flex: 2,
                              child: Text(toll.places.placeName ?? 'N/A',
                                  style: const TextStyle(
                                      fontSize: 14.0, fontWeight: FontWeight.w500)),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: Text(S.of(context).city,
                                  style: const TextStyle(
                                      fontSize: 14.0, fontWeight: FontWeight.w500)),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              flex: 2,
                              child: Text(toll.places.city.cityName ?? 'N/A',
                                  style: const TextStyle(
                                      fontSize: 14.0, fontWeight: FontWeight.w500)),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: Text(S.of(context).country,
                                  style: const TextStyle(
                                      fontSize: 14.0, fontWeight: FontWeight.w500)),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              flex: 2,
                              child: Text(toll.places.city.country?.countryName ?? 'N/A',
                                  style: const TextStyle(
                                      fontSize: 14.0, fontWeight: FontWeight.w500)),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const SizedBox(width: 8),
                  GestureDetector(
                      onTap: () {
                        // editar
                      },
                      child: const Icon(Icons.edit, color: AppStyle.primary)
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                      onTap: () {
                        // eliminar
                      },
                      child: const Icon(Icons.delete, color: AppStyle.red)
                  ),
                ],
              )
            )
          ],
        ),
      ),
    );
  }
}