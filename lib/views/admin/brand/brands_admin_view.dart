import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:smarttolls/api/api.dart';
import 'package:smarttolls/generated/l10n.dart';
import 'package:smarttolls/providers/providers.dart';
import 'package:smarttolls/style/app_style.dart';
import 'package:smarttolls/utils/utils.dart';
import 'package:smarttolls/widgets/widgets.dart';

class BrandsAdminView extends StatelessWidget {
  static const String routerName = 'brandsAdmin';
  static const String routerPath = '/brandsAdmin';

  const BrandsAdminView({super.key});

  @override
  Widget build(BuildContext context) {
    bool isMobile = ResponsiveBreakpoints.of(context).smallerThan(TABLET);
    
    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBar(
          actions: [
            IconButton(
              onPressed: () => showAddBrandDialog(context),
              icon: const Icon(Icons.add_rounded, color: AppStyle.primary, size: 30),
            )
          ],
          centerTitle: true,
          text: S.of(context).brand,
        ),
        backgroundColor: AppStyle.white,
        drawer: isMobile ? const SmartTollsDrawer() : null,
        body: isMobile
            ? const SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    children: [
                      BrandsAdminMobileView(),
                    ],
                  ),
                ),
              )
            : const BrandsAdminTabletView(),
      ),
    );
  }
}

class BrandsAdminMobileView extends StatelessWidget {
  const BrandsAdminMobileView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        BrandsAdminList(),
      ],
    );
  }
}
class BrandsAdminTabletView extends StatelessWidget {
  const BrandsAdminTabletView({super.key});
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
                  BrandsAdminList(),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class BrandsAdminList extends StatefulWidget {
  const BrandsAdminList({super.key});

  @override
  State<BrandsAdminList> createState() => _BrandsAdminListState();
}

class _BrandsAdminListState extends State<BrandsAdminList> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<BrandProvider>(context, listen: false).loadBrands();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<BrandProvider>();

    return Column(
      children: [
        // Barra de búsqueda
        CustomField(
          hintText: S.of(context).search,
          prefixIcon: const Icon(Icons.search),
          onChanged: (value) {
            // Implementar búsqueda
            provider.searchBrands(value);
          },
        ),
        const SizedBox(height: 16),
        
        // Estado de carga
        if (provider.isLoading && provider.brands.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 32),
            child: CircularProgressIndicator(),
          ),
        
        // Mensaje de error
        if (provider.errorMessage != null)
          Column(
            children: [
              Text(
                provider.errorMessage!,
                style: const TextStyle(color: Colors.red),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: provider.retryLoading,
                child: Text(S.of(context).retry),
              ),
              const SizedBox(height: 16),
            ],
          ),
        
        // Lista vacía
        if (!provider.isLoading && provider.brands.isEmpty && provider.errorMessage == null)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 32),
            child: Text(
              'No hay marcas registradas',
              style: TextStyle(
                color: AppStyle.grey,
                fontSize: 16,
              ),
            ),
          ),
        
        // Lista de marcas
        if (provider.brands.isNotEmpty)
          ListView.separated(
            itemCount: provider.brands.length,
            itemBuilder: (context, index) {
              final brand = provider.brands[index];
              return BrandsCard(brand: brand);
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

void showAddBrandDialog(BuildContext context) {
  final brandNameController = TextEditingController();
  final brandDescriptionController = TextEditingController();
  final brandCountryController = TextEditingController();
  final provider = Provider.of<BrandProvider>(context, listen: false);

  Utils.textFieldAlert(
    context: context,
    content: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CustomField(
          controller: brandNameController,
          hintText: S.of(context).brand,
          keyboardType: TextInputType.text,
          prefixIcon: const Icon(Icons.drive_eta),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Por favor ingrese el nombre de la marca';
            }
            return null;
          },
        ),
        const SizedBox(height: 10),
        CustomField(
          controller: brandDescriptionController,
          hintText: S.of(context).description,
          keyboardType: TextInputType.text,
          prefixIcon: const Icon(Icons.info),
        ),
        const SizedBox(height: 10),
        CustomField(
          controller: brandCountryController,
          hintText: S.of(context).country,
          keyboardType: TextInputType.text,
          prefixIcon: const Icon(Icons.public),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Por favor ingrese el país de origen';
            }
            return null;
          },
        ),
      ],
    ),
    negativeText: S.of(context).cancel, 
    positiveOnPressed: () async {
      if (brandNameController.text.isNotEmpty && brandCountryController.text.isNotEmpty) {
        await provider.addBrand(
          brandNameController.text,
          brandDescriptionController.text,
          brandCountryController.text,
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

void showEditBrandDialog(BuildContext context, StBrandResponse brand) {
  final brandNameController = TextEditingController(text: brand.brandName);
  final brandDescriptionController = TextEditingController(text: brand.brandDescription);
  final brandCountryController = TextEditingController(text: brand.brandManufacturingCountry);
  final provider = Provider.of<BrandProvider>(context, listen: false);

  Utils.textFieldAlert(
    context: context,
    content: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CustomField(
          controller: brandNameController,
          hintText: S.of(context).brand,
          keyboardType: TextInputType.text,
          prefixIcon: const Icon(Icons.drive_eta),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Por favor ingrese el nombre de la marca';
            }
            return null;
          },
        ),
        const SizedBox(height: 10),
        CustomField(
          controller: brandDescriptionController,
          hintText: S.of(context).description,
          keyboardType: TextInputType.text,
          prefixIcon: const Icon(Icons.info),
        ),
        const SizedBox(height: 10),
        CustomField(
          controller: brandCountryController,
          hintText: S.of(context).country,
          keyboardType: TextInputType.text,
          prefixIcon: const Icon(Icons.public),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Por favor ingrese el país de origen';
            }
            return null;
          },
        ),
      ],
    ),
    negativeText: S.of(context).cancel, 
    positiveOnPressed: () async {
      if (brandNameController.text.isNotEmpty && brandCountryController.text.isNotEmpty) {
        await provider.updateBrand(
          brand.idBrand,
          brandNameController.text,
          brandDescriptionController.text,
          brandCountryController.text,
        );
        Navigator.of(context, rootNavigator: true).pop();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Nombre y país son campos requeridos')),
        );
      }
    },
    positiveText: S.of(context).update,
    title: S.of(context).editBrand,
  );
}

void showDeleteBrandDialog(BuildContext context, StBrandResponse brand) {
  final provider = Provider.of<BrandProvider>(context, listen: false);

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(S.of(context).deleteBrand),
        content: Text('${S.of(context).confirmDeleteBrand} ${brand.brandName}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(S.of(context).cancel),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              final scaffoldMessenger = ScaffoldMessenger.of(context);
              
              try {
                await provider.deleteBrand(brand.idBrand);
                scaffoldMessenger.showSnackBar(
                  SnackBar(content: Text('${brand.brandName} ${S.of(context).deletedSuccessfully}')),
                );
              } catch (e) {
                scaffoldMessenger.showSnackBar(
                  SnackBar(content: Text('Error al eliminar: ${e.toString()}')),
                );
              }
            },
            child: Text(
              S.of(context).delete,
              style: const TextStyle(color: Colors.red),
            ),
          ),
        ],
      );
    },
  );
}