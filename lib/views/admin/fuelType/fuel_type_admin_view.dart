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
    final isMobile = MediaQuery.of(context).size.width < 600;
    
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Tipos de Combustible',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: AppStyle.primary,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => showAddFuelTypeDialog(context),
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              Provider.of<FuelTypeProvider>(context, listen: false).loadFuelTypes();
            },
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
                  colors: [Colors.white, Colors.grey.shade50],
                ),
              ),
              child: const FuelTypeAdminList(),
            ),
          ),
          if (!isMobile)
            Expanded(
              flex: 2,
              child: Container(
              decoration: BoxDecoration(
                color: AppStyle.primary.withOpacity(0.05),
                border: Border(left: BorderSide(color: Colors.grey.shade200)),
              ),
              child: Center(
                child: Opacity(
                  opacity: 0.2,
                  child: Image.asset('assets/fuel_pattern.png', fit: BoxFit.contain),
                ),
              ),
            ),
          )
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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Administración de Combustibles',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppStyle.primary,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Gestiona los tipos de combustible disponibles',
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
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Buscar combustible...',
              prefixIcon: Icon(Icons.search, color: Colors.grey.shade400),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
            ),
            onChanged: provider.searchFuelTypes,
          ),
        ),
        const SizedBox(height: 24),
        
        // Contenido principal
        Expanded(
          child: _buildContent(provider),
        ),
      ],
    );
  }

  Widget _buildContent(FuelTypeProvider provider) {
    if (provider.isLoading && provider.fuelTypes.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (provider.errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(provider.errorMessage!),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: provider.retryLoading,
              child: const Text('Reintentar'),
            ),
          ],
        ),
      );
    }

    if (!provider.isLoading && provider.fuelTypes.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/nodata.png', width: 150),
            const SizedBox(height: 16),
            const Text('No hay combustibles registrados'),
          ],
        ),
      );
    }

    return ListView.separated(
      itemCount: provider.fuelTypes.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final fuelType = provider.fuelTypes[index];
        return FuelTypeCard(
          fuelType: fuelType,
          onEdit: () => showEditFuelTypeDialog(context, fuelType),
          onDelete: () => showDeleteFuelTypeDialog(context, fuelType),
        );
      },
    );
  }
}


// Los diálogos (showAddFuelTypesDialog, showEditFuelTypeDialog, showDeleteFuelTypeDialog)
// pueden mantenerse igual que en tu código original
void showAddFuelTypeDialog(BuildContext context) {
  final controller = TextEditingController();
  final provider = Provider.of<FuelTypeProvider>(context, listen: false);

  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Agregar Combustible'),
      content: TextField(
        controller: controller,
        decoration: const InputDecoration(
          labelText: 'Nombre del combustible',
          border: OutlineInputBorder(),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: () async {
            if (controller.text.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('El nombre es requerido')),
              );
              return;
            }
            
            await provider.addFuelType(controller.text);
            if (provider.errorMessage == null) {
              Navigator.pop(context);
            }
          },
          child: const Text('Agregar'),
        ),
      ],
    ),
  );
}

void showEditFuelTypeDialog(BuildContext context, StFuelTypesResponse fuelType) {
  final controller = TextEditingController(text: fuelType.fuelTypeName);
  final provider = Provider.of<FuelTypeProvider>(context, listen: false);

  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Editar Combustible'),
      content: TextField(
        controller: controller,
        decoration: const InputDecoration(
          labelText: 'Nombre del combustible',
          border: OutlineInputBorder(),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: () async {
            if (controller.text.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('El nombre es requerido')),
              );
              return;
            }
            
            await provider.updateFuelType(fuelType.idFuelType, controller.text);
            if (provider.errorMessage == null) {
              Navigator.pop(context);
            }
          },
          child: const Text('Guardar'),
        ),
      ],
    ),
  );
}

void showDeleteFuelTypeDialog(BuildContext context, StFuelTypesResponse fuelType) {
  final provider = Provider.of<FuelTypeProvider>(context, listen: false);

  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Eliminar Combustible'),
      content: Text('¿Eliminar ${fuelType.fuelTypeName}?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
          onPressed: () async {
            Navigator.pop(context);
            await provider.deleteFuelType(fuelType.idFuelType);
          },
          child: const Text('Eliminar', style: TextStyle(color: Colors.white)),
        ),
      ],
    ),
  );
}