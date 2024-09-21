import 'package:flutter/material.dart';
import 'package:smarttolls/generated/l10n.dart';
import 'package:smarttolls/style/app_style.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class VehicleTypeCard extends StatelessWidget {
  const VehicleTypeCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Slidable(
      endActionPane: ActionPane(
        motion: const DrawerMotion(),
        children: [
          SlidableAction(
            flex: 2,
            onPressed: (BuildContext context) {},
            backgroundColor: AppStyle.red,
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: 'Delete',
          ),
          SlidableAction(
            borderRadius: const BorderRadius.only(bottomRight: Radius.circular(16), topRight: Radius.circular(16)), 
            flex: 2,
            onPressed: (BuildContext context) {},
            backgroundColor: AppStyle.primary,
            foregroundColor: Colors.white,
            icon: Icons.edit,
            label: 'Edit',
          ),
        ],
      ),
      child: Container(
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
            const Icon(Icons.drive_eta, color: AppStyle.primary, size: 50),
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
      ),
    );
  }
}