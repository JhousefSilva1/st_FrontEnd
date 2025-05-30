import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:smarttolls/providers/providers.dart';
import 'package:smarttolls/style/app_style.dart';
import 'package:smarttolls/widgets/widgets.dart';
import 'package:smarttolls/api/api.dart';
import 'package:smarttolls/generated/l10n.dart';

class FuelTypeAdminView extends StatelessWidget {
  static const String routerName = 'fuelTypeAdmin';
  static const String routerPath = '/fuelTypeAdmin';
  const FuelTypeAdminView({super.key});

  @override
  Widget build(BuildContext context) {
    bool isMobile = ResponsiveBreakpoints.of(context).smallerThan(TABLET);
    return Scaffold(
      backgroundColor: AppStyle.backgroundGrey,
      appBar: AppBar(
        title: Text(S.of(context).fuel,
            style: TextStyle(
                color: AppStyle.primary,
                fontWeight: FontWeight.bold,
                fontSize: isMobile ? 20 : 24)),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(Icons.add, color: AppStyle.primary, size: 28),
            onPressed: () => showAddFuelTypesDialog(context),
          ),
        ],
        iconTheme: IconThemeData(color: AppStyle.primary),
      ),
      drawer: isMobile ? const SmartTollsDrawer() : null,
      body: isMobile
            ? const SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    children: [
                      FuelTypeAdminMobileView(),
                    ],
                  ),
                ),
              )
          : Row(  // Cambiamos a Row para diseño en tablet/desktop
              children: [
                const Expanded(
                  flex: 3,  // 3 partes para el contenido principal
                  child: FuelTypeAdminTabletView(),
                ),
                Expanded(
                  flex: 2,  // 2 partes para la imagen
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border(left: BorderSide(color: Colors.grey.shade200)),
                    ),
                    child: Center(
                      child: Opacity(
                        opacity: 0.3,
                        child: Image.asset(
                          'assets/fuel_pattern.png',
                          fit: BoxFit.contain,
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

class FuelTypeAdminMobileView extends StatelessWidget {
  const FuelTypeAdminMobileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Administrar Tipos de Combustible',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppStyle.primary,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 24),
        const FuelTypeAdminList(),
        // Para móviles, puedes agregar la imagen al final si lo deseas
        Padding(
          padding: const EdgeInsets.only(top: 24),
          child: Opacity(
            opacity: 0.2,
            child: Image.asset(
  'assets/fuel_pattern.png',
  fit: BoxFit.contain,
),
          ),
        ),
      ],
    );
  }
}

class FuelTypeAdminTabletView extends StatelessWidget {
  const FuelTypeAdminTabletView({super.key});

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
                  FuelTypeAdminList(),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
class FuelTypeAdminList extends StatefulWidget {
  const FuelTypeAdminList({super.key});

  @override
  State<FuelTypeAdminList> createState() => _FuelTypeAdminListState();
}

class _FuelTypeAdminListState extends State<FuelTypeAdminList> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<FuelTypeProvider>(context, listen: false).loadFuelTypes();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<FuelTypeProvider>();

    return Column(
      children: [
        SearchBar(
          hintText: S.of(context).search,
          leading: Icon(Icons.search, color: Colors.grey.shade600),
          elevation: MaterialStateProperty.all(1),
          backgroundColor: MaterialStateProperty.all(Colors.white),
          onChanged: (value) => provider.searchFuelType(value),
        ),
        const SizedBox(height: 20),
        
        // Estado de carga
        if (provider.isLoading)
          const Center(child: CircularProgressIndicator()),

        // Mensaje de error
        if (provider.errorMessage != null)
          Column(
            children: [
              Icon(Icons.error_outline, color: AppStyle.red, size: 48),
              const SizedBox(height: 16),
              Text(
                provider.errorMessage!,
                style: const TextStyle(
                  color: AppStyle.red,
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppStyle.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () => provider.retryLoading(),
                child: Text(S.of(context).retry,
                    style: TextStyle(color: Colors.white)),
              ),
            ],
          ),

        // Lista vacía
        if (!provider.isLoading &&
            provider.fuelType.isEmpty &&
            provider.errorMessage == null)
          Column(
            children: [
              Image.asset('assets/fuel_pattern.png', width: 150, opacity: const AlwaysStoppedAnimation(0.3)),
              const SizedBox(height: 16),
              Text(
                'No hay tipos de combustible registrados',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Presiona el botón + para agregar uno nuevo',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade500,
                ),
              ),
            ],
          ),

        // Lista de tipos de combustible
        if (provider.fuelType.isNotEmpty)
          ListView.separated(
            itemCount: provider.fuelType.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final fuelType = provider.fuelType[index];
              return FuelTypeCard(fuelTypesName: fuelType);
            },
          ),
      ],
    );
  }
}


// Los diálogos (showAddFuelTypesDialog, showEditFuelTypeDialog, showDeleteFuelTypeDialog)
// pueden mantenerse igual que en tu código original
void showAddFuelTypesDialog(BuildContext context) {
  final fuelTypeFuelController = TextEditingController();
  final provider = Provider.of<FuelTypeProvider>(context, listen: false);
  
  showDialog(
    context: context,
    builder: (context) {
      return SingleChildScrollView( // Añade esto
        child: AlertDialog(
          contentPadding: const EdgeInsets.all(16),
          insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          content: Column(
            mainAxisSize: MainAxisSize.min, // Importante
            children: [
              Text(S.of(context).addFuelType, 
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              CustomField(
                controller: fuelTypeFuelController,
                hintText: S.of(context).fuelType,
                keyboardType: TextInputType.text,
                prefixIcon: const Icon(Icons.gas_meter),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese el tipo de combustible';
                  }
                  return null;
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(S.of(context).cancel),
            ),
            TextButton(
              onPressed: () async {
                if (fuelTypeFuelController.text.isNotEmpty) {
                  await provider.addFuelType(fuelTypeFuelController.text);
                  Navigator.of(context).pop();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('El tipo de combustible no puede estar vacío')),
                  );
                }
              },
              child: Text(S.of(context).add),
            ),
          ],
        ),
      );
    },
  );
}

void showEditFuelTypeDialog(BuildContext context, StFuelTypesResponse fuelType) {
  final fuelTypeFuelController = TextEditingController(text: fuelType.fuelTypeName);
  final provider = Provider.of<FuelTypeProvider>(context, listen: false);

  showDialog(
    context: context,
    builder: (context) {
      return SingleChildScrollView( // Añade esto
        child: AlertDialog(
          contentPadding: const EdgeInsets.all(16),
          insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          content: Column(
            mainAxisSize: MainAxisSize.min, // Importante
            children: [
              Text(S.of(context).editFuelType, 
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              CustomField(
                controller: fuelTypeFuelController,
                hintText: S.of(context).fuelType,
                keyboardType: TextInputType.text,
                prefixIcon: const Icon(Icons.gas_meter),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese el tipo de combustible';
                  }
                  return null;
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(S.of(context).cancel),
            ),
            TextButton(
              onPressed: () async {
                if (fuelTypeFuelController.text.isNotEmpty) {
                  await provider.updateFuelType(
                    fuelType.idFuelType,
                    fuelTypeFuelController.text,
                  );
                  Navigator.of(context).pop();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('El tipo de combustible no puede estar vacío')),
                  );
                }
              },
              child: Text(S.of(context).update),
            ),
          ],
        ),
      );
    },
  );
}
void showDeleteFuelTypeDialog(BuildContext context, StFuelTypesResponse fuelType) {
  final provider = Provider.of<FuelTypeProvider>(context, listen: false);

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(S.of(context).deleteFuelType),
        content: Text('${S.of(context).confirmDeleteFuelType} ${fuelType.fuelTypeName}?'),
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
                await provider.deleteFuelType(fuelType.idFuelType);
                scaffoldMessenger.showSnackBar(
                  SnackBar(content: Text('${fuelType.fuelTypeName} ${S.of(context).deletedSuccessfully}')),
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