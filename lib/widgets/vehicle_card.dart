import 'package:flutter/material.dart';
import 'package:smarttolls/style/app_style.dart';

class VehicleCard extends StatelessWidget {
  const VehicleCard({super.key});

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
          const SizedBox(width: 8),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text('Suzuki, Dzire', style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w700)),
                Text('5617-KNK', style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w500)),
                Text('2022', style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w500)),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.payment_outlined, color: AppStyle.primary),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}