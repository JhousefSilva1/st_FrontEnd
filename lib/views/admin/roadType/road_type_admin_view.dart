import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:smarttolls/api/api.dart';
import 'package:smarttolls/generated/l10n.dart';
import 'package:smarttolls/providers/road_types_provider.dart';
import 'package:smarttolls/style/app_style.dart';
import 'package:smarttolls/utils/utils.dart';
import 'package:smarttolls/widgets/widgets.dart';

class RoadTypeAdminView extends StatelessWidget{
  static const String routerName = 'roadTypeAdmin';
  static const String routerPath = '/roadTypeAdmin';
  const RoadTypeAdminView({super.key});

  @override
  Widget build(BuildContext context){
    // final RoadTypesProvider roadTypesProvider = Provider.of<RoadTypesProvider>(context);
    bool isMobile = ResponsiveBreakpoints.of(context).smallerThan(TABLET);

    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBar(
          actions: [
            IconButton(
              onPressed: () => showAddRoadTypeDialog(context),
              icon: const Icon(Icons.add_rounded, color: AppStyle.primary, size: 30),
            )
          ],
          centerTitle: true,
          text: S.of(context).roadType,
        ),
        backgroundColor: AppStyle.white,
        drawer: isMobile ? const SmartTollsDrawer() : null,
        body: isMobile
            ? const SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    children: [
                      RoadTypeAdminMobileView(),
                    ],
                  ),
                ),
              )
            : const RoadTypeAdminTabletView(),

      ),
    );
  }
}
class RoadTypeAdminMobileView extends StatelessWidget{
  const RoadTypeAdminMobileView({super.key});

  @override
  Widget build(BuildContext context) {

    return const Column(
      children: [
        RoadTypeAdminList(),
      ],
    );
  }
}
class RoadTypeAdminTabletView extends StatelessWidget {
  const RoadTypeAdminTabletView({super.key});

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
                  RoadTypeAdminList(),
                ],
              ),
            ),
        ) ,
        ),
      ],
    );
  }
}

class RoadTypeAdminList extends StatefulWidget{
  const RoadTypeAdminList({super.key});

  @override
  State<RoadTypeAdminList> createState() => _RoadTypeAdminListState();
}

class _RoadTypeAdminListState extends State<RoadTypeAdminList> {

@override
void initState(){
  super.initState();
  WidgetsBinding.instance.addPostFrameCallback((_) {
    Provider.of<RoadTypesProvider>(context, listen: false).loadRoadTypes();
  });
}

@override
Widget build(BuildContext context){
  final provider = context.watch<RoadTypesProvider>();

  return Column(
    children: [
      CustomField(
        hintText: S.of(context).search,
        prefixIcon: const Icon(Icons.search),
        onChanged: (value) {
          provider.searchRoadTypes(value);
        },
      ),
      const SizedBox(height: 16),

      // Estado de carga
      if(provider.isLoading && provider.roadTypes.isEmpty)
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 32),
          child: CircularProgressIndicator(),
        ),

        // Mensaje de error
        if(provider.errorMessage != null)
          Column(
            children: [
              Text(
                provider.errorMessage!,
                style: const TextStyle(
                  color: Colors.red,
                  fontSize: 16),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: provider.retryLoading,
                child: const Text('Reintentar'),
              ),
              const SizedBox(height: 16),
            ],
          ),
          if(!provider.isLoading && provider.roadTypes.isEmpty && provider.errorMessage == null)
            Padding(
            padding: const EdgeInsets.symmetric(vertical:32),
              child: Text('No hay tipos de caminos disponibles',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey
              ),
              ),
            ),


            // Lista de tipos de caminos
            if(provider.roadTypes.isNotEmpty)
              ListView.separated(
                itemCount: provider.roadTypes.length,
                itemBuilder: (context, index) {
                  final RoadTypes = provider.roadTypes[index];
                  return RoadTypeCard(
                    roadTypeName: RoadTypes
                    );
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
void showAddRoadTypeDialog(BuildContext context){
  final roadTypesController = TextEditingController();
  final provider = Provider.of<RoadTypesProvider>(context, listen: false);

   Utils.textFieldAlert(
    context: context,
    content: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CustomField(
          controller: roadTypesController,
          hintText: S.of(context).addRoadType,
          keyboardType: TextInputType.text,
          prefixIcon: const Icon(Icons.car_rental),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Por favor ingrese tipo de camino';
            }
            return null;
          },
        ),
        
        const SizedBox(height: 10),
      ],
    ),
    negativeText: S.of(context).cancel, 
    positiveOnPressed: () async {
      if (roadTypesController.text.isNotEmpty) {
        await provider.addRoadType(
          roadTypesController.text,
      

        );
        Navigator.of(context, rootNavigator: true).pop(); // Cierra solo el diálogo
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Nombre y país son campos requeridos')),
        );
      }
    },
    positiveText: S.of(context).add,
    title: S.of(context).addRoadType,
  );
}

void showEditRoadTypeDialog(BuildContext context, StRoadTypeResponse roadType) {
  final roadTypesController = TextEditingController(text: roadType.roadType);
  final provider = Provider.of<RoadTypesProvider>(context, listen: false);

  Utils.textFieldAlert(
    context: context,
    content: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CustomField(
          controller: roadTypesController,
          hintText: S.of(context).editRoadType,
          keyboardType: TextInputType.text,
          prefixIcon: const Icon(Icons.car_rental),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Por favor ingrese tipo de camino';
            }
            return null;
          },
        ),
        const SizedBox(height: 10),
      ],
    ),
    negativeText: S.of(context).cancel, 
    positiveOnPressed: () async {
      if (roadTypesController.text.isNotEmpty) {
        await provider.updateRoadType(
          roadType.idRoadType!,
          roadTypesController.text,
        );
        Navigator.of(context, rootNavigator: true).pop(); // Cierra solo el diálogo
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Nombre y país son campos requeridos')),
        );
      }
    },
    positiveText: S.of(context).edit,
    title: S.of(context).editRoadType,
  );
}

void showDeleteRoadTypeDialog(BuildContext context, StRoadTypeResponse roadType) {
  final provider = Provider.of<RoadTypesProvider>(context, listen: false);

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(S.of(context).deleteRoadType),
        content: Text('${S.of(context).confirmDeleteRoadType} ${roadType.roadType}'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(S.of(context).cancel),
          ),
          TextButton(
            onPressed: () async {
              await provider.deleteRoadType(roadType.idRoadType!);
              Navigator.of(context).pop();
            },
            child: Text(S.of(context).delete),
          ),
        ],
      );
    },
  );
}