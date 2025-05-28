import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:smarttolls/api/api.dart';
import 'package:smarttolls/generated/l10n.dart';
import 'package:smarttolls/providers/providers.dart';
import 'package:smarttolls/style/app_style.dart';
import 'package:smarttolls/utils/utils.dart';
import 'package:smarttolls/widgets/widgets.dart';

class VehicleTypeAdminView extends StatelessWidget {
  static const String routerName = 'vehicleTypeAdmin';
  static const String routerPath = '/vehicleTypeAdmin';
  const VehicleTypeAdminView({super.key});

  @override
  Widget build(BuildContext context){
    // final VehicleTypeProvider vehicleTypeProvider = Provider.of<VehicleTypeProvider>(context);
    bool isMobile = ResponsiveBreakpoints.of(context).smallerThan(TABLET);
    
    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBar(
          actions: [
            IconButton(
              onPressed: () => showAddVehilceTypeDialog(context),
              icon: const Icon(Icons.add_rounded, color: AppStyle.primary, size: 30),
            )
          ],
          centerTitle: true,
          text: S.of(context).vehicleType,
        ),
        backgroundColor: AppStyle.white,
        drawer: isMobile ? const SmartTollsDrawer() : null,
        body: isMobile
            ? const SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    children: [
                      VehiclesTypeAdminMobileView(),
                    ],
                  ),
                ),
              )
            : const VehiclesTypeAdminTabletView(),
      ),
    );
  }
}
class VehiclesTypeAdminMobileView extends StatelessWidget{
  const VehiclesTypeAdminMobileView({super.key});

  @override
  Widget build(BuildContext context) {

    return const Column(
      children: [
        VehiclesTypeAdminList(),
      ],
    );
  }
}

class VehiclesTypeAdminTabletView extends StatelessWidget {
  const VehiclesTypeAdminTabletView({super.key});

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
                  VehiclesTypeAdminList(),
                ],
              ),
            ),
        ) ,
        ),
      ],
    );
  }
}
class VehiclesTypeAdminList extends StatefulWidget{
  const VehiclesTypeAdminList({super.key});

  @override
  State<VehiclesTypeAdminList> createState() => _VehiclesTypeAdminListState();
}

class _VehiclesTypeAdminListState extends State<VehiclesTypeAdminList> {

@override
void initState(){
  super.initState();
  WidgetsBinding.instance.addPostFrameCallback((_) {
    Provider.of<VehicleTypeProvider>(context, listen: false).loadVehiclesType();
  });
}

@override
Widget build(BuildContext context){
  final provider = context.watch<VehicleTypeProvider>();

  return Column(
    children: [
      CustomField(
        hintText: S.of(context).search,
        prefixIcon: const Icon(Icons.search),
        onChanged: (value) {
          provider.searchVehiclesType(value);
        },
      ),
      const SizedBox(height: 16),

      // Estado de carga
      if(provider.isLoading && provider.vehiclesType.isEmpty)
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
          if(!provider.isLoading && provider.vehiclesType.isEmpty && provider.errorMessage == null)
            Padding(
            padding: const EdgeInsets.symmetric(vertical:32),
              child: Text('No hay tipos de vehículos disponibles',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey
              ),
              ),
            ),


            // Lista de tipos de vehículos
            if(provider.vehiclesType.isNotEmpty)
              ListView.separated(
                itemCount: provider.vehiclesType.length,
                itemBuilder: (context, index) {
                  final VehiclesType = provider.vehiclesType[index];
                  return VehicleTypeCard(
                    vehiclesTypeName: VehiclesType
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
void showAddVehilceTypeDialog(BuildContext context){
  final vehiclesTypesController = TextEditingController();
  final provider = Provider.of<VehicleTypeProvider>(context, listen: false);

   Utils.textFieldAlert(
    context: context,
    content: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CustomField(
          controller: vehiclesTypesController,
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
      if (vehiclesTypesController.text.isNotEmpty) {
        await provider.addVehiclesType(
          vehiclesTypesController.text,
      

        );
        Navigator.of(context, rootNavigator: true).pop(); // Cierra solo el diálogo
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Nombre y país son campos requeridos')),
        );
      }
    },
    positiveText: S.of(context).add,
    title: S.of(context).addVehicleType,
  );
}
void showEditVehicleTypeDialog(BuildContext context, StVehiclesTypeResponse vehiclesType) {
  final vehiclesTypesController = TextEditingController(text: vehiclesType.vehiclesTypesName);
  final provider = Provider.of<VehicleTypeProvider>(context, listen: false);

  Utils.textFieldAlert(
    context: context,
    content: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CustomField(
          controller: vehiclesTypesController,
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
      if (vehiclesTypesController.text.isNotEmpty) {
        await provider.updateVehiclesType(
          vehiclesType.idVehiclesType!,
          vehiclesTypesController.text,
        );
        Navigator.of(context, rootNavigator: true).pop(); // Cierra solo el diálogo
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('El nombre del tipo de vehículo no puede estar vacío')),
        );
      }
    },
    positiveText: S.of(context).edit,
    title: S.of(context).editVehicleType,
  );
}

void showDeleteVehicleTypeDialog(BuildContext context, StVehiclesTypeResponse vehiclesType) {
  final provider = Provider.of<VehicleTypeProvider>(context, listen: false);

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(S.of(context).deleteVehicleType),
        content: Text('${S.of(context).deleteVehicleTypeConfirmation} ${vehiclesType.vehiclesTypesName ?? ''}'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(S.of(context).cancel),
          ),
          TextButton(
            onPressed: () async {
              await provider.deleteVehiclesType(vehiclesType.idVehiclesType!);
              Navigator.of(context).pop();
            },
            child: Text(S.of(context).delete),
          ),
        ],
      );
    },
  );
}