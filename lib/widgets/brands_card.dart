import 'package:flutter/material.dart';
import 'package:smarttolls/generated/l10n.dart';
import 'package:smarttolls/style/app_style.dart';

class BrandsCard extends StatelessWidget {
  const BrandsCard({super.key});

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
            spreadRadius: 1
          ),
        ]
      ),
      child: Padding(
        padding: const EdgeInsets.all(8),
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
                        child: Text(S.of(context).brand, style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.w700)),
                      ),
                      const SizedBox(width: 16),
                      const Expanded(
                        flex: 2,
                        child: Text('Suzuki', style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w500)),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Text(S.of(context).model, style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.w700)),
                      ),
                      const SizedBox(width: 16),
                      const Expanded(
                        flex: 2,
                        child: Text('Dzire', style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w500)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () {},
                    child: const Icon(Icons.remove_red_eye_sharp, color: AppStyle.primary)
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: const Icon(Icons.edit, color: AppStyle.primary)
                  ),
                  GestureDetector(
                    onTap: () {},
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