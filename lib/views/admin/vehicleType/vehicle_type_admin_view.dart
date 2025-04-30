import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:smarttolls/generated/l10n.dart';
import 'package:smarttolls/providers/providers.dart';
import 'package:smarttolls/style/app_style.dart';
import 'package:smarttolls/widgets/widgets.dart';

class VehicleTypeAdminView extends StatelessWidget {
  static const String routerName = 'vehicleTypeAdmin';
  static const String routerPath = '/vehicleTypeAdmin';
  const VehicleTypeAdminView({super.key});

  @override
  Widget build(BuildContext context){
    final VehicleTypeProvider vehicleTypeProvider = Provider.of<VehicleTypeProvider>(context);
    bool isMobile = ResponsiveBreakpoints.of(context).smallerThan(TABLET);
    
    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBar(
          actions: [
            IconButton(
              onPressed: () => vehicleTypeProvider.goToAddVehiclesType(context),
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