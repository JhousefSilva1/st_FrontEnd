import 'package:flutter/material.dart';
import 'package:smarttolls/api/api.dart';
import 'package:smarttolls/generated/l10n.dart';
import 'package:smarttolls/style/app_style.dart';

class RoadTypeCard extends StatelessWidget{
  final StRoadTypeResponse roadTypeName;

  const RoadTypeCard({
    super.key,
    required this.roadTypeName,
  });

  @override
  Widget build (BuildContext context){
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white, width: 1),
        borderRadius: const BorderRadius.all(Radius.circular(8)),
        color: Colors.white,
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
        child:Row(
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
                        child: Text(S.of(context).roadType, 
                          style: const TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.w700
                            )
                            ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        flex: 2,
                        child: Text(roadTypeName.roadType ?? 'N/A', 
                          style: const TextStyle(fontSize: 14.0, fontWeight: FontWeight.w500)),
                      ),
                    ],
                  )
                ],
            )
            ),
            Expanded(
              flex:1,
              child:Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: (){
                      // editar tipo de camino
                    },
                    child: const Icon(Icons.edit, color: AppStyle.red, size: 30),
                  ),
                  const SizedBox(width: 16),
                  GestureDetector(
                    onTap: (){
                      // eliminar tipo de camino
                    },
                    child: const Icon(Icons.delete, color: AppStyle.red, size: 30),
                  ),
                ],
              )
            )
          ],
        )
      )
    );
  }
}