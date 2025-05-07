import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:smarttolls/generated/l10n.dart';
import 'package:smarttolls/providers/country_provider.dart';
import 'package:smarttolls/style/app_style.dart';
import 'package:smarttolls/utils/utils.dart';
import 'package:smarttolls/widgets/country_card.dart';
import 'package:smarttolls/widgets/custom_app_bar.dart';
import 'package:smarttolls/widgets/custom_field.dart';
import 'package:smarttolls/widgets/drawer.dart';

class CountryAdminView extends StatelessWidget{
  static const String routerName = 'countryAdmin';
  static const String routerPath = '/countryAdmin';

  const CountryAdminView({super.key});

  @override
  Widget build(BuildContext context){
    bool isMobile = ResponsiveBreakpoints.of(context).smallerThan(TABLET);

    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBar(
          actions: [
            IconButton(
              onPressed: () => showAddCountryDialog(context),
              icon: const Icon(Icons.add_rounded, color: AppStyle.primary, size: 30),
            )
          ],
          centerTitle: true,
          text:  S.of(context).country,
        ),
        backgroundColor: AppStyle.white,
        drawer: isMobile ? const SmartTollsDrawer() : null,
        body: isMobile
            ? const SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    CountryAdminMobileView(),
                  ],
                  ),
              ),
            )
            :const CountryAdminTabletView(),
      ),
    );
  }
}
class CountryAdminMobileView extends StatelessWidget{
  const CountryAdminMobileView({super.key});
  @override
  Widget build(BuildContext context){
    return const Column(
      children: [
        CountryAdminList(),
      ],
    );
  }
}
class CountryAdminTabletView extends StatelessWidget{
  const CountryAdminTabletView({super.key});
  @override
  Widget build(BuildContext context){
    return const Row(
      children: [
        SmartTollsDrawer(),
        Expanded(
          flex:2,
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  CountryAdminList(),
                ],
              ),
            ),
          )
        )
      ],
    );
  }
}
class CountryAdminList extends StatefulWidget{
  const CountryAdminList({super.key});

  @override
  State<CountryAdminList> createState() => _CountryAdminListState();
}

class _CountryAdminListState extends State<CountryAdminList>{
  @override
  void initState(){
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Aquí puedes llamar a tu función de carga de datos
      Provider.of<CountryProvider>(context, listen: false).loadCountries();
    });
  }

  @override
  Widget build(BuildContext context){
    final provider = context.watch<CountryProvider>();

    return Column(
      children: [
        // barra de búsqueda
        CustomField(
          hintText: S.of(context).search,
          prefixIcon: const Icon(Icons.search, color: AppStyle.primary),
          onChanged: (value) {
            // implementar la lógica de búsqueda
            provider.searchCountries(value);
          },
        ),
        const SizedBox(height: 16),
        // Estado de carga
        if(provider.isLoading && provider.countries.isEmpty)
        const Padding(
          padding: EdgeInsets.all(16),
          child: CircularProgressIndicator(),
        ),
        // Mensaje de error
        if(provider.errorMessage != null)
          Column(
            children: [
              Text(
                provider.errorMessage!,
                style: const TextStyle(color: AppStyle.red, fontSize: 16),
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
          // Lista vacia
          if(!provider.isLoading && provider.countries.isEmpty && provider.errorMessage == null)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 32),
              child: Text('No hay paises disponibles',
                style: const TextStyle(
                  color: AppStyle.primary,
                  fontSize: 16)
                  ),
            ),

            // Lista de paises
            if(provider.countries.isNotEmpty)
              ListView.separated(
                itemCount: provider.countries.length,
                itemBuilder: (context, index){
                  final country = provider.countries[index];
                  return CountryCard(countryName: country);
                },
                physics: const NeverScrollableScrollPhysics(),
                primary: false,
                shrinkWrap: true,
                separatorBuilder: (context, index) => const SizedBox(height: 12),
              ),
      ],
    );
  }
}

void showAddCountryDialog(BuildContext context){
  final countryNameController = TextEditingController();
  final provider = Provider.of<CountryProvider>(context, listen: false);

    Utils.textFieldAlert(
    context: context,
    content: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CustomField(
          controller: countryNameController,
          hintText: S.of(context).country,
          keyboardType: TextInputType.text,
          prefixIcon: const Icon(Icons.public, color: AppStyle.primary),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Por favor ingrese el nombre de la marca';
            }
            return null;
          },
        ),
        const SizedBox(height: 10),

      ],
    ),
    negativeText: S.of(context).cancel, 
    positiveOnPressed: () async {
      if (countryNameController.text.isNotEmpty) {
        await provider.addCountries(
          countryNameController.text,
        );
        Navigator.of(context, rootNavigator: true).pop(); // Cierra solo el diálogo
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Nombre y país son campos requeridos')),
        );
      }
    },
    positiveText: S.of(context).add,
    title: S.of(context).addCountry,
  );

}
