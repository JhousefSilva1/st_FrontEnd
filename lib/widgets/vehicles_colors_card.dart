import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:smarttolls/api/response/st_vehicles_colors_response.dart';
import 'package:smarttolls/providers/vehicles_colors_provider.dart';

import '../generated/l10n.dart';

class VehiclesColorsCard extends StatelessWidget {
  final StVehiclesColorsResponse vehiclesColorsName;

  const VehiclesColorsCard({
    super.key,
    required this.vehiclesColorsName,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white, width: 1),
        borderRadius: const BorderRadius.all(Radius.circular(8)),
        color:Colors.white,
        boxShadow:[
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
          children:[
            const SizedBox(width: 8),
            const Icon(Icons.color_lens, color: Colors.blue, size: 50),
            const SizedBox(width: 16),
            Expanded(
              flex: 2,
              child:Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children:[
                  Row(
                    children: [
                      Expanded(
                        flex:2,
                        child: Text(S.of(context).vehicleColor,
                          style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.w700)),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        flex:2,
                        child: Text(vehiclesColorsName.colorName ?? 'N/A',
                          style: const TextStyle(fontSize: 14.0, fontWeight: FontWeight.w500)),
                      ),
                      const SizedBox(width: 16),
                    ],
                  ),
                ] ,
              )
            ),
            Expanded(
              flex:2,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap:(){
                      // ver detalles del color
                      final provider = Provider.of<VehiclesColorsProvider>(context, listen: false);
                      provider.goToAddColors(context);
                    },
                    child: const Icon(Icons.add, color: Colors.blue, size: 30),
                  ),
                  GestureDetector(
                    onTap: (){
                      // editar
                    },child: const Icon(Icons.edit, color: Colors.red, size: 30),
                  ),
                  const SizedBox(width: 16),
                  GestureDetector(
                    onTap: (){
                      // delete
                    },child: const Icon(Icons.delete, color: Colors.red, size: 30),
                  ),
                  const SizedBox(width: 16),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}