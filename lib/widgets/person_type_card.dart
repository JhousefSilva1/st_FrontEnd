import 'package:flutter/material.dart';
import 'package:smarttolls/api/api.dart';

import '../generated/l10n.dart';

class PersonTypeCard extends StatelessWidget{
  final StPersonTypeResponse personType;

  const PersonTypeCard({
    super.key,
    required this.personType,
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
                        child: Text(S.of(context).personType,
                          style: const TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        flex:2,
                        child: Text(personType.personType ?? 'N/A',
                          style: const TextStyle(
                            fontSize: 14.0,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      )
                    ],
                  )
                ]
              ),
            ),
            Expanded(
              flex: 1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children:[
                  GestureDetector(
                    onTap: () {

                    },
                    child: const Icon(Icons.edit, color: Colors.blue, size: 30),
                  ),
                  const SizedBox(width: 16),
                  GestureDetector(
                    onTap: () {

                    },
                    child: const Icon(Icons.delete, color: Colors.red, size: 30),
                  ),
                  const SizedBox(width: 8),
                ]
              ),
            )
          ],
        ),
      ),
    );
  }
}