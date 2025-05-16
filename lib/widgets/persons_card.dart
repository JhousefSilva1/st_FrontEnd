import 'package:flutter/material.dart';
import 'package:smarttolls/api/api.dart';
import 'package:smarttolls/generated/l10n.dart';
import 'package:smarttolls/style/app_style.dart';
import 'package:smarttolls/widgets/widgets.dart';

class PersonsCard extends StatelessWidget{
  final StPersonResponse person;

  const PersonsCard({
    super.key,
    required this.person,
  });

  @override
  Widget build (BuildContext context){
    return Container(
      decoration: BoxDecoration(
        border:Border.all(color: AppStyle.white, width: 1),
        borderRadius: const BorderRadius.all(Radius.circular(8)),
        color: AppStyle.white,
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
                children: [
                  const SizedBox(width: 8),
                  const Icon(Icons.person, color: AppStyle.primary, size: 50),
                  const SizedBox(width: 16),
                  Expanded(
                    flex:2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children:[
                        Row(
                          children: [
                            Expanded(
                              flex:2,
                              child: Text(S.of(context).personName,
                                  style: const TextStyle(
                                    fontSize: 16.0, fontWeight: FontWeight.w700)),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                flex:2,
                                child: Text(person.personName ?? 'N/A',
                                    style: const TextStyle(
                                      fontSize: 16.0, fontWeight: FontWeight.w700)),
                              )
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              flex:2,
                              child: Text(S.of(context).personSurname,
                                  style: const TextStyle(
                                    fontSize: 16.0, fontWeight: FontWeight.w700)),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                flex:2,
                                child: Text(person.personSurname ?? 'N/A',
                                    style: const TextStyle(
                                      fontSize: 16.0, fontWeight: FontWeight.w700)),
                              )
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              flex:2,
                              child: Text(S.of(context).bornDate,
                                  style: const TextStyle(
                                    fontSize: 16.0, fontWeight: FontWeight.w700)),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                flex:2,
                                child: Text(person.personBirthdate ?? 'N/A',
                                    style: const TextStyle(
                                      fontSize: 16.0, fontWeight: FontWeight.w700)),
                              )
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              flex:2,
                              child: Text(S.of(context).email,
                                  style: const TextStyle(
                                    fontSize: 16.0, fontWeight: FontWeight.w700)),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                flex:2,
                                child: Text(person.personEmail ?? 'N/A',
                                    style: const TextStyle(
                                      fontSize: 16.0, fontWeight: FontWeight.w700)),
                              )
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              flex:2,
                              child: Text(S.of(context).whatsApp,
                                  style: const TextStyle(
                                    fontSize: 16.0, fontWeight: FontWeight.w700)),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                flex:2,
                                child: Text(person.personWhatsappNumber ?? 'N/A',
                                    style: const TextStyle(
                                      fontSize: 16.0, fontWeight: FontWeight.w700)),
                              )
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              flex:2,
                              child: Text(S.of(context).dni,
                                  style: const TextStyle(
                                    fontSize: 16.0, fontWeight: FontWeight.w700)),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                flex:2,
                                child: Text(person.personDni ?? 'N/A',
                                    style: const TextStyle(
                                      fontSize: 16.0, fontWeight: FontWeight.w700)),
                              )
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              flex:2,
                              child: Text(S.of(context).address,
                                  style: const TextStyle(
                                    fontSize: 16.0, fontWeight: FontWeight.w700)),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                flex:2,
                                child: Text(person.personAddress ?? 'N/A',
                                    style: const TextStyle(
                                      fontSize: 16.0, fontWeight: FontWeight.w700)),
                              )
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              flex:2,
                              child: Text(S.of(context).age,
                                  style: const TextStyle(
                                    fontSize: 16.0, fontWeight: FontWeight.w700)),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                flex:2,
                                child: Text(person.personAge ?? 'N/A',
                                    style: const TextStyle(
                                      fontSize: 16.0, fontWeight: FontWeight.w700)),
                              )
                          ],
                        ),
                        const SizedBox(height: 8),
                          Row(
                            children: [
                              Expanded(
                                flex:2,
                                child: Text(S.of(context).gender,
                                    style: const TextStyle(
                                      fontSize: 16.0, fontWeight: FontWeight.w700)),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  flex:2,
                                  child: Text(person.gender.genderName ?? 'N/A',
                                      style: const TextStyle(
                                        fontSize: 16.0, fontWeight: FontWeight.w700)),
                                )
                            ],
                          ),
                        const SizedBox(height: 8),
                          Row(
                            children: [
                              Expanded(
                                flex:2,
                                child: Text(S.of(context).personType,
                                    style: const TextStyle(
                                      fontSize: 16.0, fontWeight: FontWeight.w700)),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  flex:2,
                                  child: Text(person.personType.personType ?? 'N/A',
                                      style: const TextStyle(
                                        fontSize: 16.0, fontWeight: FontWeight.w700)),
                                )
                            ],
                          ),
                        const SizedBox(height: 8),
                          Row(
                            children: [
                              Expanded(
                                flex:2,
                                child: Text(S.of(context).country,
                                    style: const TextStyle(
                                      fontSize: 16.0, fontWeight: FontWeight.w700)),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  flex:2,
                                  child: Text(person.country.countryName ?? 'N/A',
                                      style: const TextStyle(
                                        fontSize: 16.0, fontWeight: FontWeight.w700)),
                                )
                            ],
                          ),
                        const SizedBox(height: 8),
                          Row(
                            children: [
                              Expanded(
                                flex:2,
                                child: Text(S.of(context).city,
                                    style: const TextStyle(
                                      fontSize: 16.0, fontWeight: FontWeight.w700)),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  flex:2,
                                  child: Text(person.city.cityName ?? 'N/A',
                                      style: const TextStyle(
                                        fontSize: 16.0, fontWeight: FontWeight.w700)),
                                )
                            ],
                          ),
                      ]
                    ),
                  )
                ],
              )
            ),
            Expanded(
              flex:2,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: (){

                    },
                    child: const Icon(Icons.edit, color: AppStyle.primary, size: 30),
                  ),
                  const SizedBox(width: 16),
                  GestureDetector(
                    onTap: (){

                    },
                    child: const Icon(Icons.delete, color: AppStyle.primary, size: 30),
                  ),
                ],
              ),
            )
          ],
        ),
      )
    );
  }

}