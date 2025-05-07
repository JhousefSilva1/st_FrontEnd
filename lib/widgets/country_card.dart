import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:smarttolls/generated/l10n.dart';
import 'package:smarttolls/providers/providers.dart';
import 'package:smarttolls/style/app_style.dart';
import 'package:smarttolls/views/views.dart';

import '../api/api.dart';

class CountryCard extends StatelessWidget{
  final StCountryResponse countryName;

  const CountryCard({
    super.key,
    required this.countryName,
  });

  @override
  Widget build(BuildContext context){
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color:AppStyle.white, width: 1),
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
          children:[
            Expanded(
              child: GestureDetector(
                onTap: (){
                  final proviver = Provider.of<CountryProvider>(context, listen: false);
                  proviver.clearCountries();

                  // Opción 1: Usando pathParameters
                  context.pushNamed(
                    CountryAdminView.routerName,
                    pathParameters: {'idCountry': countryName.idCountry.toString()},
                  );
                },
                child: Row(
                  children: [
                    const SizedBox(width: 8),
                    const Icon(Icons.public, color: AppStyle.primary, size: 50),
                    const SizedBox(width: 16),
                    Expanded(
                      flex:2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                flex:2,
                                child:Text(S.of(context).country,
                                style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.w700)
                                 ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                flex:2,
                                child: Text(countryName.countryName ?? 'N/A',
                                style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.w700)
                                 ),
                                ),
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            Expanded(
              flex:2,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const SizedBox(width: 8,),
                  GestureDetector(
                    onTap: (){
                      // editar
                    },
                    child: const Icon(Icons.edit, color: AppStyle.primary)
                  ),
                  const SizedBox(width: 8,),
                  GestureDetector(
                    onTap: (){
                      // eliminar
                      // final provider = Provider.of<CountryProvider>(context, listen: false);
                      // provider.deleteCountries(country.idCountry.toString());
                    },
                    child: const Icon(Icons.delete, color: AppStyle.primary)
                  ),
                ],
              )
            )
          ]
        ),
      )
    );
  }
}