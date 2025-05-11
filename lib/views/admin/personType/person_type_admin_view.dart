import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:smarttolls/widgets/widgets.dart';

import '../../../generated/l10n.dart';
import '../../../providers/providers.dart';
import '../../../style/app_style.dart';
import '../../../utils/utils.dart';

class PersonTypeAdminView extends StatelessWidget{
  static const String routerName = 'personTypeAdmin';
  static const String routerPath = '/personTypeAdmin';

  const PersonTypeAdminView({super.key});

  @override
  Widget build(BuildContext context){
    bool isMobile = ResponsiveBreakpoints.of(context).smallerThan(TABLET);

    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBar(
          actions: [
            IconButton(
              onPressed: () => showAddPersonTypeDialog(context),
              icon: const Icon(Icons.add_rounded, color: AppStyle.primary, size: 30),
            )
          ],
          centerTitle: true,
          text: S.of(context).personType,
          ),
          backgroundColor: AppStyle.white,
          drawer: isMobile ? const SmartTollsDrawer() : null,
          body: isMobile
            ? const SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    children: [
                      PersonTypeAdminMobileView(),
                    ],
                  ),
                ),
              )
            : const PersonTypeAdminTabletView(),
      ),
    );
  }
}
class PersonTypeAdminMobileView extends StatelessWidget{
  const PersonTypeAdminMobileView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        PersonTypeAdminList(),
      ],
    );
  }
}

class PersonTypeAdminTabletView extends StatelessWidget{
  const PersonTypeAdminTabletView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        SmartTollsDrawer(),
        Expanded(
          flex: 2,
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  PersonTypeAdminList(),
                ],
              ),
            ),
          ),
        )
      ],
    );
  }
}
class PersonTypeAdminList extends StatefulWidget{
  const PersonTypeAdminList({super.key});

  @override
  State<PersonTypeAdminList> createState() => _PersonTypeAdminListState();
}
  class _PersonTypeAdminListState extends State<PersonTypeAdminList> {

    @override
    void initState(){
      super.initState();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Provider.of<PersonTypeProvider>(context, listen: false).loadPersonTypes();
      });
    }

    @override
    Widget build(BuildContext context){
      final provider = context.watch<PersonTypeProvider>();

      return Column(
        children: [
          CustomField(
            hintText: S.of(context).search,
            prefixIcon: const Icon(Icons.search, color: AppStyle.primary),
            onChanged: (value){
              provider.searchPersonTypes(value);
            },
          ),
          const SizedBox(height: 16),
//    Estado de carga
          if(provider.isLoading && provider.personTypes.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 32),
              child: CircularProgressIndicator(),
            ),
            // mensaje de error
            if(provider.errorMessage != null)
              Column(
                children: [
                  Text(
                    provider.errorMessage!,
                    style: const TextStyle(
                      fontSize: 16,
                      color: AppStyle.red,
                      fontWeight: FontWeight.w500,
                    ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: provider.retryLoading,
                      child: Text(S.of(context).retry,
                        style: const TextStyle(color: AppStyle.white)),
                    ),
                    const SizedBox(height: 16),
                ],
              ),
              if(!provider.isLoading && provider.personTypes.isEmpty && provider.errorMessage == null)
                 Padding(
                  padding:  EdgeInsets.symmetric(vertical: 32),
                  child: Text('No hay tipos de personas disponibles',
                    style: const TextStyle(
                      fontSize: 16,
                      color: AppStyle.red,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),

                // lista de tipos de personas
                if(provider.personTypes.isNotEmpty)
                  ListView.separated(
                    itemCount: provider.personTypes.length,
                    itemBuilder: (context, index){
                      final personType = provider.personTypes[index];
                      return PersonTypeCard(personType: personType);
                    },
                    physics: const NeverScrollableScrollPhysics(),
                    primary: false,
                    shrinkWrap: true,
                    separatorBuilder: (context, index) => const SizedBox(height: 16),
                  ),
          ],
      );
    }
  }



void showAddPersonTypeDialog(BuildContext context) {
  final personTypeController = TextEditingController();
  final provider = Provider.of<PersonTypeProvider>(context, listen: false);

    Utils.textFieldAlert(
    context: context,
    content: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CustomField(
          controller: personTypeController,
          hintText: S.of(context).vehicleType,
          keyboardType: TextInputType.text,
          prefixIcon: const Icon(Icons.car_rental),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Por favor ingrese tipo de vehiculo';
            }
            return null;
          },
        ),
        
        const SizedBox(height: 10),
      ],
    ),
    negativeText: S.of(context).cancel, 
    positiveOnPressed: () async {
      if (personTypeController.text.isNotEmpty) {
        await provider.addPersonType(
          personTypeController.text,
      

        );
        Navigator.of(context, rootNavigator: true).pop(); // Cierra solo el diálogo
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Nombre y país son campos requeridos')),
        );
      }
    },
    positiveText: S.of(context).add,
    title: S.of(context).addPersonType
  );
  

}