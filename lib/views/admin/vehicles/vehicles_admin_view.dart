import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:smarttolls/generated/l10n.dart';
import 'package:smarttolls/providers/providers.dart';
import 'package:smarttolls/style/app_style.dart';
import '../../../widgets/widgets.dart';

class VehiclesAdminView extends StatelessWidget{
  static const String routerName = 'adminVehicles';
  static const String routerPath = '/adminVehicles';

  const VehiclesAdminView({super.key});

  @override
  Widget build(BuildContext context){
    bool isMobile = ResponsiveBreakpoints.of(context).smallerThan(TABLET);
        return SafeArea(
      child: Scaffold(
        appBar: CustomAppBar(
          centerTitle: true,
          text: S.of(context).vehicle,
        ),
        backgroundColor: AppStyle.white,
        drawer: isMobile ? const SmartTollsDrawer() : null,
        body: isMobile
            ? const SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    children: [
                      VehicleAdminMobileView(),
                    ],
                  ),
                ),
              )
            : const VehicleAdminTabletView(),
      ),
    );
  }
}
class VehicleAdminMobileView extends StatelessWidget{
  const VehicleAdminMobileView({super.key});
  @override
  Widget build(BuildContext context){
    return const Column(
      children: [
        VehicleAdminList(),
      ],
    );
  }
}

class VehicleAdminTabletView extends StatelessWidget{
  const VehicleAdminTabletView({super.key});

  @override
  Widget build(BuildContext context){
    return const  Row(
      children: [
         SmartTollsDrawer(),
        Expanded(
          flex:2,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  VehicleAdminList(),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}


class VehicleAdminList extends StatefulWidget{
  const VehicleAdminList({super.key});

  @override
  State<VehicleAdminList> createState() => _VehicleAdminListState();
}
class _VehicleAdminListState extends State<VehicleAdminList>{
  @override
  void initState(){
    super.initState();
    _loadVehicles();
  }

  void _loadVehicles(){
    WidgetsBinding.instance.addPostFrameCallback((_){
      final provider = Provider.of<VehiclesProvider>(context, listen:false);
      provider.loadAllVehicles().then((_){
        ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(provider.errorMessage!)),
          );
      });
    });
  }
    @override
  Widget build(BuildContext context){
    final provider = Provider.of<VehiclesProvider>(context);
    return Column(
      children: [
        CustomField(
          hintText: S.of(context).search,
          onChanged: (value) {
            provider.searchVehicles(value);
          },
        ),
        const SizedBox(height: 16),
        if(provider.isLoading && provider.vehicles.isEmpty)
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
            if(!provider.isLoading && provider.vehicles.isEmpty && provider.errorMessage == null)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 32),
                child: Text('No hay vehicles registrados',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w700,
                    color: AppStyle.primary.withOpacity(0.5),
                  ),
                ),
              ),
              if(provider.vehicles.isNotEmpty)
                ListView.separated(
                  itemCount: provider.vehicles.length,
                  itemBuilder: (context, index) {
                    final vehicles = provider.vehicles[index];
                    return VehiclesCard(vehicle: vehicles);
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