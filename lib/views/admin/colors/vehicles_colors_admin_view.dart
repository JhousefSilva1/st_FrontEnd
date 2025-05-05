import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:smarttolls/generated/l10n.dart';
import 'package:smarttolls/providers/vehicles_colors_provider.dart';
import 'package:smarttolls/style/app_style.dart';
import 'package:smarttolls/utils/utils.dart';
import 'package:smarttolls/widgets/widgets.dart';

class VehiclesColorsAdminView extends StatelessWidget{
  static const String routerName = 'vehiclesColorsAdmin';
  static const String routerPath = '/vehiclesColorsAdmin';
  const VehiclesColorsAdminView({super.key});

  @override
  Widget build(BuildContext context) {
    final VehiclesColorsProvider vehiclesColorsProvider = Provider.of<VehiclesColorsProvider>(context);
    bool isMobile = ResponsiveBreakpoints.of(context).smallerThan(TABLET);
    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBar(
          actions:[
            IconButton(
              onPressed: () => showAddColorDialog(context),
              icon: const Icon(Icons.add_rounded, color: Colors.blue, size: 30),
            )
          ],
          centerTitle: true,
          text: S.of(context).color
        ),
        backgroundColor: Colors.white,
        drawer: isMobile ? const SmartTollsDrawer() : null,
        body: isMobile
            ? const SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    children: [
                      VehiclesColorsAdminMobileView(),
                    ],
                  ),
                ),
              )
            : const VehiclesColorsAdminTabletView(),
      ),
        );
  }
}

class VehiclesColorsAdminMobileView extends StatelessWidget{
  const VehiclesColorsAdminMobileView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        VehiclesColorsAdminList(),
      ],
    );
  }
}

class VehiclesColorsAdminTabletView extends StatelessWidget{
  const VehiclesColorsAdminTabletView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      children:[
        SmartTollsDrawer(),
        Expanded(
          flex: 2,
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  VehiclesColorsAdminList(),
                ],
              ),
            )
          )

          ),
        
      ],
    );
  }
}

class VehiclesColorsAdminList extends StatefulWidget{
  const VehiclesColorsAdminList({super.key});

  @override
  State<VehiclesColorsAdminList> createState() => _VehiclesColorsAdminListState();
}

class _VehiclesColorsAdminListState extends State<VehiclesColorsAdminList> {
  
  @override
  void initState(){
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<VehiclesColorsProvider>(context, listen: false).loadVehiclesColors();
    });    
  }

  @override
  Widget build (BuildContext context){
    final provider = context.watch<VehiclesColorsProvider>();

    return Column(
      children: [
        CustomField(
          hintText: S.of(context).search,
          prefixIcon: const Icon(Icons.search_off_rounded),
          onChanged: (value) {
            provider.searchColors(value);
          },
        ),
        const SizedBox(height: 16),

        // estadod de carga
        if (provider.errorMessage != null)
          Column(
            children: [
              Text(
                 provider.errorMessage!,
                 style: const TextStyle(
                  color: AppStyle.red,
                  fontSize: 16,
                  fontWeight: FontWeight.bold
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed:() =>provider.retryLoading(),
                child: Text(S.of(context).retry),
              ),
              const SizedBox(height: 16),
            ],
          ),
          if(!provider.isLoading && provider.colors.isEmpty && provider.errorMessage == null)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 32),
              child: Text(
                'No hay colores de vehiculos disponibles',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppStyle.primary,
                ),
              ),
            ),

            //Lista de colores de vehiculos
            if(provider.colors.isNotEmpty)
              ListView.separated(
                itemCount: provider.colors.length,
                itemBuilder: (context, index) {
                  final vehiclesColors = provider.colors[index];
                  return VehiclesColorsCard(
                    vehiclesColorsName: vehiclesColors
                    
                  );
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

void showAddColorDialog(BuildContext context){
  final colorNameController = TextEditingController();
  final colorDescriptionController = TextEditingController();
  final provider = Provider.of<VehiclesColorsProvider>(context, listen: false);

 Utils.textFieldAlert(
    context: context,
    content: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CustomField(
          controller: colorNameController,
          hintText: S.of(context).color,
          keyboardType: TextInputType.text,
          prefixIcon: const Icon(Icons.color_lens),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Por favor ingrese el nombre de la marca';
            }
            return null;
          },
        ),
        const SizedBox(height: 10),
        CustomField(
          controller: colorDescriptionController,
          hintText: S.of(context).description,
          keyboardType: TextInputType.text,
          prefixIcon: const Icon(Icons.info),
        ),
        const SizedBox(height: 10),
      ],
    ),
    negativeText: S.of(context).cancel, 
    positiveOnPressed: () async {
      if (colorNameController.text.isNotEmpty && colorDescriptionController.text.isNotEmpty) {
        await provider.addColor(
          colorNameController.text,
          colorDescriptionController.text,

        );
        Navigator.of(context, rootNavigator: true).pop(); // Cierra solo el diálogo
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Nombre y país son campos requeridos')),
        );
      }
    },
    positiveText: S.of(context).add,
    title: S.of(context).addBrand,
  );
}