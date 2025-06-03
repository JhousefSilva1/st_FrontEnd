import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smarttolls/api/api.dart';
import 'package:smarttolls/generated/l10n.dart';
import 'package:smarttolls/providers/road_types_provider.dart';
import 'package:smarttolls/style/app_style.dart';
import 'package:smarttolls/widgets/widgets.dart';

class RoadTypeAdminView extends StatelessWidget {
  static const String routerName = 'roadTypeAdmin';
  static const String routerPath = '/roadTypeAdmin';
  
  const RoadTypeAdminView({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;
    
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          S.of(context).roadType,
          style: const TextStyle(
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
            onPressed: () => showAddRoadTypeDialog(context),
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              Provider.of<RoadTypesProvider>(context, listen: false).loadRoadTypes();
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
              child: const RoadTypeAdminList(),
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
                    child: Image.asset('assets/roads_pattern.png', fit: BoxFit.contain),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class RoadTypeAdminList extends StatefulWidget {
  const RoadTypeAdminList({super.key});

  @override
  State<RoadTypeAdminList> createState() => _RoadTypeAdminListState();
}

class _RoadTypeAdminListState extends State<RoadTypeAdminList> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<RoadTypesProvider>(context, listen: false).loadRoadTypes();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<RoadTypesProvider>();
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Administración de Tipos de Camino',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppStyle.primary,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Gestiona los tipos de camino disponibles',
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
              hintText: 'Buscar tipo de camino...',
              prefixIcon: Icon(Icons.search, color: Colors.grey.shade400),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
            ),
            onChanged: provider.searchRoadTypes,
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

  Widget _buildContent(RoadTypesProvider provider) {
    if (provider.isLoading && provider.roadTypes.isEmpty) {
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

    if (!provider.isLoading && provider.roadTypes.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/nodata.png', width: 150),
            const SizedBox(height: 16),
            const Text('No hay tipos de camino registrados'),
          ],
        ),
      );
    }

    return ListView.separated(
      itemCount: provider.roadTypes.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final roadType = provider.roadTypes[index];
        return RoadTypeCard(
          roadType: roadType,
          onEdit: () => showEditRoadTypeDialog(context, roadType),
          onDelete: () => showDeleteRoadTypeDialog(context, roadType),
        );
      },
    );
  }
}

// Diálogos refactorizados
void showAddRoadTypeDialog(BuildContext context) {
  final controller = TextEditingController();
  final provider = Provider.of<RoadTypesProvider>(context, listen: false);

  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Agregar Tipo de Camino'),
      content: TextField(
        controller: controller,
        decoration: const InputDecoration(
          labelText: 'Nombre del tipo de camino',
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
            
            await provider.addRoadType(controller.text);
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

void showEditRoadTypeDialog(BuildContext context, StRoadTypeResponse roadType) {
  final controller = TextEditingController(text: roadType.roadType);
  final provider = Provider.of<RoadTypesProvider>(context, listen: false);

  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Editar Tipo de Camino'),
      content: TextField(
        controller: controller,
        decoration: const InputDecoration(
          labelText: 'Nombre del tipo de camino',
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
            
            await provider.updateRoadType(roadType.idRoadType!, controller.text);
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

void showDeleteRoadTypeDialog(BuildContext context, StRoadTypeResponse roadType) {
  final provider = Provider.of<RoadTypesProvider>(context, listen: false);

  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Eliminar Tipo de Camino'),
      content: Text('¿Eliminar ${roadType.roadType}?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
          onPressed: () async {
            Navigator.pop(context);
            await provider.deleteRoadType(roadType.idRoadType!);
          },
          child: const Text('Eliminar', style: TextStyle(color: Colors.white)),
        ),
      ],
    ),
  );
}