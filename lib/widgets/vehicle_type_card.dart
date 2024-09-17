import 'package:flutter/material.dart';
import 'package:smarttolls/generated/l10n.dart';
import 'package:smarttolls/style/app_style.dart';

class VehicleTypeCard extends StatelessWidget {
  const VehicleTypeCard({super.key});

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
      child: Row(
        children: [
          const SizedBox(width: 8),
          Image.asset('assets/car.jpg', height: 120, width: 120),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Text(S.of(context).vehicleType, style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.w700)),
                    ),
                    const SizedBox(width: 16),
                    const Expanded(
                      flex: 2,
                      child: Text('Automovil', style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w500)),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Text(S.of(context).numberOfDoors, style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.w700)),
                    ),
                    const SizedBox(width: 16),
                    const Expanded(
                      flex: 2,
                      child: Text('5', style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w500)),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Text(S.of(context).numberOfPassengers, style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.w700)),
                    ),
                    const SizedBox(width: 16),
                    const Expanded(
                      flex: 2,
                      child: Text('4', style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w500)),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Text(S.of(context).status, style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.w700)),
                    ),
                    const SizedBox(width: 16),
                    const Expanded(
                      flex: 2,
                      child: Text('Activo', style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w500)),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // IconButton(
          //   icon: const Icon(Icons.check_circle_sharp, color: AppStyle.primary),
          //   onPressed: () {},
          // ),
        ],
      ),
    );
  }
}