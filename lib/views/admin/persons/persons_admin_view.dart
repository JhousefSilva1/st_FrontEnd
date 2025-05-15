import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:smarttolls/generated/l10n.dart';
import 'package:smarttolls/providers/person_provider.dart';
import 'package:smarttolls/style/app_style.dart';
import 'package:smarttolls/widgets/persons_card.dart';

import '../../../widgets/widgets.dart';

class PersonAdminView extends StatelessWidget{
  static const String routerName = 'adminPersons';
  static const String routerPath = '/adminPersons';

  const PersonAdminView({super.key});

  @override
  Widget build(BuildContext context){
    bool isMobile = ResponsiveBreakpoints.of(context).smallerThan(TABLET);

    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBar(
          actions: [
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                // Navigator.pushNamed(context, '/addPerson');
              },
            ),
          ],
          centerTitle: true,
          text: S.of(context).personData,
        ),
        backgroundColor: AppStyle.white,
        body: isMobile
            ? SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children:[
                      PersonAdminList(),
                    ]
                  ),
                )
            )
            : PersonAdminTabletView(),
      ),
    );
  }
}

class PersonAdminTabletView extends StatelessWidget{
  const PersonAdminTabletView({super.key});

  @override
  Widget build(BuildContext context){
    return const  Row(
      children: [
        const SmartTollsDrawer(),
        Expanded(
          flex:2,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  PersonAdminList(),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class PersonAdminList extends StatefulWidget{
  const PersonAdminList({super.key});

  @override
  State<PersonAdminList> createState() => _PersonAdminListState();
}

class _PersonAdminListState extends State<PersonAdminList>{
  @override
  void initState(){
    super.initState();
    _loadPersons();
  }
  void _loadPersons(){
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<PersonProvider>(context, listen: false);
      provider.loadAllPersons().then((_) {
        if (provider.errorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(provider.errorMessage!)),
          );
        }
      });
    });
  }

  @override
  Widget build(BuildContext context){
    final provider = Provider.of<PersonProvider>(context);
    return Column(
      children: [
        CustomField(
          hintText: S.of(context).search,
          onChanged: (value) {
            provider.searchPersons(value);
          },
        ),
        const SizedBox(height: 16),
        if(provider.isLoading && provider.persons.isEmpty)
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: CircularProgressIndicator(
              color: AppStyle.primary,
              strokeWidth: 2,
            ),
          ),
          if(provider.errorMessage != null)
            Column(
              children: [
                Text(
                  provider.errorMessage!,
                  style: const TextStyle(color: AppStyle.red),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: provider.retryLoading,
                  child: Text(S.of(context).retry,
                  style: const TextStyle(
                    color: AppStyle.white,
                    fontSize: 16.0,
                    fontWeight: FontWeight.w700,
                  ),
                ),    
                ),
                const SizedBox(height: 16),
              ],
            ),
            if(!provider.isLoading && provider.persons.isEmpty && provider.errorMessage == null)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 32),
                child: Text('No hay personas registradas',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w700,
                    color: AppStyle.primary.withOpacity(0.5),
                  ),
                ),
              ),
              if(provider.persons.isNotEmpty)
                ListView.separated(
                  itemCount: provider.persons.length,
                  itemBuilder: (context, index) {
                    final person = provider.persons[index];
                    return PersonsCard(person: person);
                  },
                  physics: const NeverScrollableScrollPhysics(),
                  primary: false,
                  shrinkWrap: true,
                  separatorBuilder: (context, index) => const SizedBox(height: 16),
                )
      ],
    );
  }
}