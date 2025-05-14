import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:smarttolls/providers/providers.dart';
import 'package:smarttolls/style/app_style.dart';
import 'package:smarttolls/utils/utils.dart';

import '../../../generated/l10n.dart';
import '../../../widgets/widgets.dart';

class ModelsAdminView extends StatelessWidget {
  static const String routerName = 'modelsAdmin';
  static const String routerPath = '/modelsAdmin/:brandId';
  final int brandId;

  const ModelsAdminView({super.key, required this.brandId});

  @override
  Widget build(BuildContext context) {

    bool isMobile = ResponsiveBreakpoints.of(context).smallerThan(TABLET);

    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBar(
          actions: [
            IconButton(
              onPressed: () => showAddModelDialog(context, brandId),
              icon: const Icon(Icons.add_rounded, color: AppStyle.primary, size: 30),
            )
          ],
          centerTitle: true,
          text: S.of(context).model,
        ),
        backgroundColor: AppStyle.white,
        body: isMobile
            ? SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      ModelAdminList(brandId: brandId), // Pasa el brandId aquí
                    ],
                  ),
                ),
              )
            : ModelsAdminTabletView(brandId: brandId), // Y aquí
      ),
    );  
  }
}

class ModelsAdminTabletView extends StatelessWidget {
  final int brandId;

  const ModelsAdminTabletView({super.key, required this.brandId});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const SmartTollsDrawer(),
        Expanded(
          flex:2,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  ModelAdminList(brandId: brandId), // Pasa el brandId aquí
                ],
              )
            ),
          )
        )
      ],
    );
  }
}

class ModelAdminList extends StatefulWidget{
  final int brandId;
  const ModelAdminList({super.key, required this.brandId});

  @override
  State<ModelAdminList>createState() => _ModelAdminListState();
}

class _ModelAdminListState extends State<ModelAdminList> {
  @override
  void initState(){
    super.initState();
    _loadModels();
  }
  @override
  void didUpdateWidget(ModelAdminList oldWidget){
    super.didUpdateWidget(oldWidget);
    if (oldWidget.brandId != widget.brandId) {
      _loadModels();
    }
  }

  void _loadModels(){
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Aquí puedes llamar a tu función para cargar los modelos
      // loadModels(widget.brandId);
      final provider = Provider.of<ModelProvider>(context, listen: false);
      provider.loadModelsByBrand(widget.brandId);
    });
  }

  @override
  Widget build (BuildContext context){
    final provider = context.watch<ModelProvider>();
    return Column(
      children: [
        CustomField(
          label: S.of(context).model,
          hintText: S.of(context).model,
          prefixIcon: const Icon(Icons.search, color: AppStyle.primary),  
          onChanged: (value) {
            provider.searchModels(value);
          },
        ),
        const SizedBox(height: 16),
        
        
        if(provider.isLoading && provider.models.isEmpty)
          const Padding(
            padding: EdgeInsets.all(16),
            child: CircularProgressIndicator(color: AppStyle.primary),
          ),
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
                  style: const TextStyle(color: AppStyle.white, fontSize: 16),
                ),
              )
            ],
          ),

          if(!provider.isLoading && provider.models.isEmpty && provider.errorMessage == null)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 32),
              child: Text('No hay modelos disponibles',
                style: const TextStyle(
                  color: AppStyle.primary,
                  fontSize: 16
                ),
              ),  
            ),
            if(provider.models.isNotEmpty)
              ListView.separated(
                itemCount: provider.models.length,
                itemBuilder: (context, index){
                  final model = provider.models[index];
                  return ModelsCard(model: model);
                },
                physics: const NeverScrollableScrollPhysics(),
                primary: false,
                shrinkWrap: true,
                separatorBuilder: (context, index) => const SizedBox(height: 12),
              
              )
      ],
    );
  }
}

void showAddModelDialog(BuildContext context, int brandId) {
  final modelNameController = TextEditingController();
  final provider = Provider.of<ModelProvider>(context, listen: false);  
  
  Utils.textFieldAlert(
      context: context,
    content: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CustomField(
          controller: modelNameController,
          hintText: S.of(context).model,
          keyboardType: TextInputType.text,
          prefixIcon: const Icon(Icons.car_repair_outlined, color: AppStyle.primary),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Por favor ingrese el modelo de la marca';
            }
            return null;
          },
        ),
        const SizedBox(height: 10),
      ],
    ),
    negativeText: S.of(context).cancel,
    positiveOnPressed: () async {
      if (modelNameController.text.isNotEmpty) {
        await provider.addModels(modelNameController.text, brandId);
        Navigator.of(context, rootNavigator: true).pop();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('El nombre del modelo requerido')),
        );
      }
    },
    positiveText: S.of(context).add,
    title: S.of(context).addModel,
  );
}