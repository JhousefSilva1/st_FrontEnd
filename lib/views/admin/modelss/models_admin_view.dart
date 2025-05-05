import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:smarttolls/generated/l10n.dart';
import 'package:smarttolls/providers/model_provider.dart';
import 'package:smarttolls/style/app_style.dart';
import 'package:smarttolls/widgets/custom_app_bar.dart';
import 'package:smarttolls/widgets/custom_field.dart';
import 'package:smarttolls/widgets/drawer.dart';
import 'package:smarttolls/widgets/models_card.dart';



class ModelsAdminView extends StatelessWidget{
  static const String routerName = 'modelAdmin';
  static const String routerPath = '/modelAdmin/:brandId';
  final int? brandId;
  
  const ModelsAdminView({super.key, this.brandId});

  @override
    Widget build(BuildContext context) {
    // Manejo seguro de parámetros
    final routeArgs = ModalRoute.of(context)?.settings.arguments;
    final goRouterState = GoRouterState.of(context);
    
    // Obtener brandId de todas las fuentes posibles con null safety
    int? receivedBrandId = brandId;
    
    if (receivedBrandId == null) {
      if (routeArgs is int?) {
        receivedBrandId = routeArgs;
      } else if (routeArgs is Map) {
        receivedBrandId = routeArgs['brandId'] as int?;
      }
    }

    if (receivedBrandId == null) {
      if (goRouterState.extra is int?) {
        receivedBrandId = goRouterState.extra as int?;
      } else if (goRouterState.extra is Map) {
        receivedBrandId = (goRouterState.extra as Map)['brandId'] as int?;
      }
    }

    if (receivedBrandId == null) {
      receivedBrandId = int.tryParse(goRouterState.pathParameters['brandId'] ?? '');
    }

    debugPrint('BrandId recibido: $receivedBrandId');

    final modelProvider = Provider.of<ModelProvider>(context);
    bool isMobile = ResponsiveBreakpoints.of(context).smallerThan(TABLET);
    
    if (receivedBrandId != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        modelProvider.loadModelsByBrand(receivedBrandId!);
      });
    }


    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBar(
          actions: [
            IconButton(
              onPressed: () => modelProvider.goToAddModels(context),
              icon: const Icon(Icons.add_rounded, color: AppStyle.primary, size: 30),
            )
          ],
          centerTitle: true,
          text: S.of(context).model,
        ),
        backgroundColor: AppStyle.white,
        drawer: isMobile ? const SmartTollsDrawer() : null,
        body: isMobile
              ? const SingleChildScrollView(
                child: Padding(
                  padding:  EdgeInsets.all(16),
                  child: Column(
                    children: [
                      ModelsAdminMobileView(),
                    ],
                  )
                ),
              )
              : const ModelsAdminTabletView(),
      ),
    );
  }
}

class ModelsAdminMobileView extends StatelessWidget {
  const ModelsAdminMobileView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        ModelsAdminList(),
      ],
    );
  }
}

class ModelsAdminTabletView extends StatelessWidget{
  const ModelsAdminTabletView({super.key});

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
                children:[
                  ModelsAdminList(),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
class ModelsAdminList extends StatefulWidget{
  const ModelsAdminList({super.key});

  @override
  State<ModelsAdminList> createState() => _ModelsAdminListState();
}

class _ModelsAdminListState extends State<ModelsAdminList> {
  @override
@override
  void initState() {
    super.initState();
    _loadModels();
  }

  void _loadModels() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<ModelProvider>(context, listen: false);
      final modelsView = context.findAncestorWidgetOfExactType<ModelsAdminView>();
      
      if (modelsView?.brandId != null) {
         provider.loadModelsByBrand(modelsView!.brandId!);
      } else  {
                final routeArgs = ModalRoute.of(context)?.settings.arguments;
        final brandId = routeArgs is int? ? routeArgs : 
                       (routeArgs is Map ? routeArgs['brandId'] as int? : null);
                               if (brandId != null) {
          provider.loadModelsByBrand(brandId);
        }
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadModels(); // Recarga cuando cambien los parámetros
  }

  @override
  void dispose() {
    Provider.of<ModelProvider>(context, listen: false).clearModels();
    super.dispose();
  }
  @override
  Widget build(BuildContext context){
    final provider = context.watch<ModelProvider>();

    return Column(
      children: [
        // barra de busqueda
        CustomField(
          hintText: S.of(context).search,
          prefixIcon: const Icon(Icons.search),
          onChanged: (value) {
            // implementar la lógica de búsqueda aquí
            provider.searchModels(value);  
          },
        ),
        const SizedBox(height: 16),

        // Estado de Carga
        if(provider.isLoading && provider.models.isEmpty)
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
                  color: Colors.red
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: provider.retryLoading,
                child: Text(S.of(context).retry),
              ),
              const SizedBox(height: 16),
            ],
          ),

          // lista vacia
          if(provider.isLoading && provider.models.isEmpty && provider.errorMessage == null)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 32),
              child: Text(
                'Justo ahora no hay modelos disponibles',
                style: TextStyle(
                  color: AppStyle.grey,
                  fontSize: 16,
                ),
              ),
            ),
          // lista de marcas

          if(provider.models.isNotEmpty)
            ListView.separated(
              itemCount: provider.models.length,
              itemBuilder: (context, index) {
                final model = provider.models[index];
                return ModelsCard(model: model);
              },physics: const NeverScrollableScrollPhysics(),
              primary: false,
              shrinkWrap: true,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
            ),
      ],
    );
  }

}