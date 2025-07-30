import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:smarttolls/api/api.dart';
import 'package:smarttolls/generated/l10n.dart';
import 'package:smarttolls/providers/providers.dart';
import 'package:smarttolls/style/app_style.dart';
import 'package:smarttolls/utils/utils.dart';
import 'package:smarttolls/widgets/widgets.dart';

import '../../views.dart';

class BrandsAdminView extends StatelessWidget {
  static const String routerName = 'brandsAdmin';
  static const String routerPath = '/brandsAdmin';

  const BrandsAdminView({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Marcas de Vehículos',
          style: TextStyle(
            color: Colors.white,
            fontSize: isMobile ? 20 : 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: AppStyle.primary,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.add, size: 28),
            onPressed: () => showAddBrandDialog(context),
          ),
        ],
      ),
      drawer: isMobile ? const SmartTollsDrawer() : null,
      body: Row(
        children: [
          if (!isMobile) const SmartTollsDrawer(),
          Expanded(
            flex: 3,
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.white,
                    Colors.grey.shade50,
                  ],
                ),
              ),
              child: const BrandsAdminList(),
            ),
          ),
          if (!isMobile)
            Expanded(
              flex: 2,
              child: Container(
                decoration: BoxDecoration(
                  color: AppStyle.primary.withOpacity(0.05),
                  border: Border(
                    left: BorderSide(
                      color: Colors.grey.shade200,
                      width: 1,
                    ),
                  ),
                ),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(40),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/brands.png',
                          fit: BoxFit.contain,
                        ),
                        const SizedBox(height: 30),
                        Text(
                          'Administra las marcas de vehículos',
                          style: TextStyle(
                            fontSize: 18,
                            color: AppStyle.primary,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Agrega, edita o elimina las marcas disponibles en el sistema',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
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
@override
  Widget build(BuildContext context) {
    final provider = context.watch<BrandProvider>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Encabezado
        Row(
          children: [
            Icon(
              Icons.directions_car_filled,
              color: AppStyle.primary,
              size: 32,
            ),
            const SizedBox(width: 12),
            Text(
              'Listado de Marcas',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppStyle.primary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          'Gestiona todas las marcas de vehículos registradas',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey.shade600,
          ),
        ),
        const SizedBox(height: 24),

        // Barra de búsqueda
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Buscar marca...',
              prefixIcon: Icon(Icons.search, color: Colors.grey.shade400),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
            ),
            onChanged: provider.searchBrands,
          ),
        ),
        const SizedBox(height: 24),

        // Estados
        if (provider.isLoading && provider.brands.isEmpty)
          Center(
            child: Column(
              children: [
                SizedBox(
                  width: 60,
                  height: 60,
                  child: CircularProgressIndicator(
                    strokeWidth: 3,
                    valueColor: AlwaysStoppedAnimation<Color>(AppStyle.primary),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Cargando marcas...',
                  style: TextStyle(
                    color: AppStyle.primary,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),

        if (provider.errorMessage != null)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.red.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.red.shade200),
            ),
            child: Row(
              children: [
                Icon(Icons.error_outline, color: Colors.red.shade600),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    provider.errorMessage!,
                    style: TextStyle(color: Colors.red.shade800),
                  ),
                ),
                TextButton(
                  onPressed: provider.retryLoading,
                  child: Text(
                    'Reintentar',
                    style: TextStyle(color: AppStyle.primary),
                  ),
                ),
              ],
            ),
          ),

if (!provider.isLoading && provider.brands.isEmpty && provider.errorMessage == null)
  SingleChildScrollView( // Añade esto
    padding: const EdgeInsets.only(bottom: 100), // Espacio adicional para el teclado
    child: Container(
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Image.asset('assets/nodata.png', width: 350),
          const SizedBox(height: 20),
          Text(
            'No hay marcas registradas',
            style: TextStyle(
              fontSize: 18,
              color: AppStyle.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Presiona el botón + para agregar una nueva marca',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    ),
  ),

        // Lista de marcas
        if (provider.brands.isNotEmpty)
          Expanded(
            child: ListView.separated(
              itemCount: provider.brands.length,
              itemBuilder: (context, index) {
                final brand = provider.brands[index];
                return _BrandListItem(brand: brand);
              },
              separatorBuilder: (context, index) => const SizedBox(height: 12),
            ),
          ),
      ],
    );
  }
}
class _BrandListItem extends StatelessWidget {
  final StBrandResponse brand;

  const _BrandListItem({required this.brand});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: AppStyle.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            Icons.directions_car,
            color: AppStyle.primary,
            size: 28,
          ),
        ),
        title: Text(
          brand.brandName ?? 'N/A',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (brand.brandDescription?.isNotEmpty ?? false)
              Text(
                brand.brandDescription!,
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 13,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(
                  Icons.flag,
                  color: AppStyle.primary,
                  size: 14,
                ),
                const SizedBox(width: 4),
                Text(
                  brand.brandManufacturingCountry ?? 'N/A',
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(Icons.edit, color: AppStyle.yellow),
              onPressed: () => showEditBrandDialog(context, brand),
            ),
            IconButton(
              icon: Icon(Icons.delete, color: AppStyle.red),
              onPressed: () => showDeleteBrandDialog(context, brand),
            ),
          ],
        ),
                  onTap: () {
                    context.goNamed(
                      ModelsAdminView.routerName,
                      pathParameters: {'idBrand': brand.idBrand.toString()},
                    );
                  },
      ),
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
                   SnackBar(content: Text('Vehículo eliminado con éxito')),
                );
              } catch (e) {
                // scaffoldMessenger.showSnackBar(
                //   SnackBar(content: Text('Error al eliminar: ${e.toString()}')),
                // );
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