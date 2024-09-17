import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:smarttolls/style/app_style.dart';

class VehiclesCard extends StatelessWidget {
  const VehiclesCard({super.key});

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
      child: Slidable(
        startActionPane: ActionPane(
          // A motion is a widget used to control how the pane animates.
          motion: const ScrollMotion(),

          // A pane can dismiss the Slidable.
          dismissible: DismissiblePane(onDismissed: () {}),

          // All actions are defined in the children parameter.
          children: const [
            // A SlidableAction can have an icon and/or a label.
            SlidableAction(
              onPressed: null,
              backgroundColor: Color(0xFFFE4A49),
              foregroundColor: Colors.white,
              icon: Icons.delete,
              label: 'Delete',
            ),
            SlidableAction(
              onPressed: null,
              backgroundColor: Color(0xFF21B7CA),
              foregroundColor: Colors.white,
              icon: Icons.share,
              label: 'Share',
            ),
          ],
        ),

        // The end action pane is the one at the right or the bottom side.
        endActionPane: ActionPane(
          motion: const ScrollMotion(),
          children: [
            SlidableAction(
              // An action can be bigger than the others.
              flex: 2,
              onPressed: null,//controller.openEndActionPane(),
              backgroundColor: const Color(0xFF7BC043),
              foregroundColor: Colors.white,
              icon: Icons.archive,
              label: 'Archive',
            ),
            SlidableAction(
              onPressed: null,//controller.close(),
              backgroundColor: const Color(0xFF0392CF),
              foregroundColor: Colors.white,
              icon: Icons.save,
              label: 'Save',
            ),
          ],
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
                  Text('Vagoneta', style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w500)),
                  Text('Particular', style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w500)),
                  Text('La Paz', style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w500)),
                  Text('2022', style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w500)),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.check_circle_sharp, color: AppStyle.primary),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}