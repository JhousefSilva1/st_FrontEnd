import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:smarttolls/api/api.dart';
import 'package:smarttolls/views/views.dart';

import '../generated/l10n.dart';

class StaffPreviewCard extends StatelessWidget{
  final StPersonTypeResponse staffType;

  const StaffPreviewCard({
    super.key,
    required this.staffType,
  });

  @override
  Widget build(BuildContext context){
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white, width: 1),
        borderRadius: const BorderRadius.all(Radius.circular(8)),
        color: Colors.white,
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
        child:Row(
          children: [
            Expanded(
              child: Row(
                children:[
                  Expanded(
                    child: GestureDetector(
                      // onTap: (){
                      //   context.goNamed(
                      //     PersonAdminView.routerName,
                      //     pathParameters: {'idPersonType': staffType.idPersonType.toString()},


                      //   );
                      // },
                      child: Row(
                        children: [
                          const SizedBox(width: 8),
                          const Icon(Icons.person, color: Colors.blue, size: 50),
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
                                      child: Text(
                                        S.of(context).personType,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(staffType.personType ?? 'No name'),
                              ],
                            ),
                          ),
                        ],
                      ),
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
                  GestureDetector(
                    onTap: (){
                      // edit
                    },
                    child: const Icon(Icons.edit, color: Colors.blue, size: 30),
                  ),
                  const SizedBox(width: 16),
                  GestureDetector(
                    onTap: (){
                      // delete
                    },
                    child: const Icon(Icons.delete, color: Colors.red, size: 30),
                  ),
                  const SizedBox(width: 8),
                ],
              )
            )
          ],
        )
      ),
    );
  }
}