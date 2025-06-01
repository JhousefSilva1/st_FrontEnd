import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smarttolls/api/api.dart';
import 'package:smarttolls/providers/providers.dart';
import 'package:smarttolls/style/app_style.dart';
import 'package:smarttolls/widgets/widgets.dart';

class VehicleTypeAdminView extends StatelessWidget {
  static const String routerName = 'vehicleTypeAdmin';
  static const String routerPath = '/vehicleTypeAdmin';

  const VehicleTypeAdminView({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;
    
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Tipos de Vehículos',
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
            onPressed: () => showAddVehicleTypeDialog(context),
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              Provider.of<VehicleTypeProvider>(context, listen: false).loadVehicleTypes();
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
              child: const VehiclesTypeAdminList(),
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
                    child: Image.asset('assets/vehicles_pattern.png', fit: BoxFit.contain),
                  ),
                ),
              ),
            ),
        ],
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
    Provider.of<VehicleTypeProvider>(context, listen: false).loadVehicleTypes();
  });
}

  Widget build(BuildContext context) {
    final provider = context.watch<VehicleTypeProvider>();
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Administración de Tipos de Vehículos',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppStyle.primary,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Gestiona los tipos de vehículos disponibles',
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
              hintText: 'Buscar tipo de vehículo...',
              prefixIcon: Icon(Icons.search, color: Colors.grey.shade400),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
            ),
            onChanged: provider.searchVehicleTypes,
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

  Widget _buildContent(VehicleTypeProvider provider) {
    if (provider.isLoading && provider.vehicleTypes.isEmpty) {
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

    if (!provider.isLoading && provider.vehicleTypes.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/no_data.png', width: 150),
            const SizedBox(height: 16),
            const Text('No hay tipos de vehículos registrados'),
          ],
        ),
      );
    }

    return ListView.separated(
      itemCount: provider.vehicleTypes.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final vehicleType = provider.vehicleTypes[index];
        return VehicleTypeCard(
          vehicleType: vehicleType,
          onEdit: () => showEditVehicleTypeDialog(context, vehicleType),
          onDelete: () => showDeleteVehicleTypeDialog(context, vehicleType),
        );
      },
    );
  }
}
void showAddVehicleTypeDialog(BuildContext context) {
  final controller = TextEditingController();
  final provider = Provider.of<VehicleTypeProvider>(context, listen: false);

  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Agregar Tipo de Vehículo'),
      content: TextField(
        controller: controller,
        decoration: const InputDecoration(
          labelText: 'Nombre del tipo de vehículo',
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
            
            await provider.addVehicleType(controller.text);
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

void showEditVehicleTypeDialog(BuildContext context, StVehiclesTypeResponse vehicleType) {
  final controller = TextEditingController(text: vehicleType.vehiclesTypesName);
  final provider = Provider.of<VehicleTypeProvider>(context, listen: false);

  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Editar Tipo de Vehículo'),
      content: TextField(
        controller: controller,
        decoration: const InputDecoration(
          labelText: 'Nombre del tipo de vehículo',
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
            
            await provider.updateVehicleType(vehicleType.idVehiclesType, controller.text);
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

void showDeleteVehicleTypeDialog(BuildContext context, StVehiclesTypeResponse vehicleType) {
  final provider = Provider.of<VehicleTypeProvider>(context, listen: false);

  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Eliminar Tipo de Vehículo'),
      content: Text('¿Eliminar ${vehicleType.vehiclesTypesName}?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
          onPressed: () async {
            Navigator.pop(context);
            await provider.deleteVehicleType(vehicleType.idVehiclesType);
          },
          child: const Text('Eliminar', style: TextStyle(color: Colors.white)),
        ),
      ],
    ),
  );
}