import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:smarttolls/providers/providers.dart';
import 'package:smarttolls/style/app_style.dart';
import 'package:smarttolls/utils/utils.dart';
import 'package:smarttolls/widgets/widgets.dart';

import '../../../generated/l10n.dart';

class FuelTypeAdminView extends StatelessWidget{
  static const String routerName = 'fuelTypeAdmin';
  static const String routerPath = '/fuelTypeAdmin';
  const FuelTypeAdminView({super.key});

  @override
  Widget build(BuildContext context) {
    final FuelTypeProvider fuelTypeProvider = Provider.of<FuelTypeProvider>(context);
    bool isMobile = ResponsiveBreakpoints.of(context).smallerThan(TABLET);
    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBar(
          actions: [
            IconButton(
              onPressed: () => showAddFuelTypesDialog(context),
              icon: const Icon(Icons.add_rounded, color: AppStyle.primary, size: 30),
            )
          ],
          centerTitle: true,
          text: S.of(context).fuel
        ),
        backgroundColor: AppStyle.white,
        drawer: isMobile ? const SmartTollsDrawer() : null,
        body: isMobile
            ? const SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    children: [
                      FuelTypeAdminMobileView(),
                    ],
                  ),
                ),
              )
            : const FuelTypeAdminTabletView(),
      ),
    );
  }
}
  class FuelTypeAdminMobileView extends StatelessWidget{
    const FuelTypeAdminMobileView({super.key});

    @override
    Widget build(BuildContext context) {
      return const Column(
        children: [
          FuelTypeAdminList(),
        ],
      );
    }
  }
class FuelTypeAdminTabletView extends StatelessWidget{
  const FuelTypeAdminTabletView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      children:[
        SmartTollsDrawer(),
        Expanded(
          flex:2,
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  FuelTypeAdminList(),
                ],
              ),
            )
          )
           )
      ]
    );
  }
}

class FuelTypeAdminList extends StatefulWidget{
  const FuelTypeAdminList({super.key});

  @override
  State<FuelTypeAdminList> createState() => _FuelTypeAdminListState();
}

class _FuelTypeAdminListState extends State<FuelTypeAdminList> {

  @override

  void initState(){
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<FuelTypeProvider>(context, listen: false).loadFuelTypes();
    });
    
  }

  @override
  Widget build (BuildContext context){
    final provider = context.watch<FuelTypeProvider>();

    return Column(
      children: [
        CustomField(
          hintText: S.of(context).search,
          prefixIcon: const Icon(Icons.search_rounded),
          onChanged: ( value){
            provider.searchFuelType(value);
          } ,
        ),
        const SizedBox(height: 16),

        // estado de carga
        if(provider.errorMessage != null)
          Column(
            children: [
              Text(
                provider.errorMessage!,
                style: const TextStyle(
                  color: AppStyle.red,
                  fontSize: 16,
                  fontWeight: FontWeight.w500
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => provider.retryLoading(),
                child: Text(S.of(context).retry),
              ),
              const SizedBox(height: 16),
            ],
          ),
          if(!provider.isLoading && provider.fuelType.isEmpty && provider.errorMessage == null)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 32),
              child: Text('No hay tipos de combustible disponibles', 
              style: TextStyle(
                fontSize: 16, 
                fontWeight: 
                FontWeight.w500,
                color: Colors.grey
                )
                ),
            ),

            // Lista de tipos de combustible
            if(provider.fuelType.isNotEmpty)
              ListView.separated(
                itemCount: provider.fuelType.length,
                itemBuilder: (context, index) {
                  final fuelType = provider.fuelType[index];
                  return FuelTypeCard(
                      fuelTypesName: fuelType,
                  ) ;
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


void showAddFuelTypesDialog(BuildContext context){
  final fuelTypeFuelController = TextEditingController();
  final provider = Provider.of<FuelTypeProvider>(context, listen: false);

   Utils.textFieldAlert(
    context: context,
    content: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CustomField(
          controller: fuelTypeFuelController,
          hintText: S.of(context).gasType,
          keyboardType: TextInputType.text,
          prefixIcon: const Icon(Icons.gas_meter),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Por favor ingrese el tipo de combustible';
            }
            return null;
          },
        ),
        const SizedBox(height: 10),
      ],
    ),
    negativeText: S.of(context).cancel, 
    positiveOnPressed: () async {
      if (fuelTypeFuelController.text.isNotEmpty ) {
        await provider.addFuelType(
          fuelTypeFuelController.text,
        );
        Navigator.of(context, rootNavigator: true).pop(); // Cierra solo el diálogo
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('El tipo de combustible no puede estar vacío')),
        );
      }
    },
    positiveText: S.of(context).add,
    title: S.of(context).addFuelType,
  );

}