 import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smarttolls/api/api.dart';
import 'package:smarttolls/providers/providers.dart';
import 'package:smarttolls/style/app_style.dart';
import '../../../widgets/widgets.dart';

/// Move showAddModelDialog above the ModelsAdminView class so it is in scope.
void showAddModelDialog(BuildContext context, int brandId) {
  final modelNameController = TextEditingController();
  final provider = Provider.of<ModelProvider>(context, listen: false);

  showDialog(
    context: context,
    builder: (context) => Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.add_circle_outline, color: AppStyle.primary, size: 28),
                const SizedBox(width: 12),
                const Text(
                  'Nuevo Modelo',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            TextField(
              controller: modelNameController,
              decoration: InputDecoration(
                labelText: 'Nombre del modelo',
                prefixIcon: Icon(Icons.car_repair, color: AppStyle.primary),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancelar'),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppStyle.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                  onPressed: () async {
                    if (modelNameController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('El nombre del modelo es requerido'),
                          backgroundColor: Colors.red,
                        ),
                      );
                      return;
                    }

                    await provider.addModels(modelNameController.text, brandId);

                    if (provider.errorMessage == null) {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Modelo agregado correctamente'),
                          backgroundColor: Colors.green,
                        ),
                      );
                    }
                  },
                  child: const Text(
                    'Guardar',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}

class ModelsAdminView extends StatelessWidget {
  static const String routerName = 'modelsAdmin';
  static const String routerPath = '/modelsAdmin/:brandId';
  final int brandId;

  const ModelsAdminView({super.key, required this.brandId});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Modelos de Vehículos',
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
            onPressed: () => showAddModelDialog(context, brandId),
          ),
          IconButton(
            icon: const Icon(Icons.refresh, size: 28),
            onPressed: () {
              final provider = Provider.of<ModelProvider>(context, listen: false);
              provider.loadModelsByBrand(brandId);
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
                  colors: [
                    Colors.white,
                    Colors.grey.shade50,
                  ],
                ),
              ),
              child: ModelAdminList(brandId: brandId, brandName: 'Marca'),
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
                          'Administra los modelos de vehículos',
                          style: TextStyle(
                            fontSize: 18,
                            color: AppStyle.primary,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Agrega, edita o elimina los modelos disponibles para esta marca',
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
                  ModelAdminList(brandId: brandId, brandName: 'Marca'), // Pasa el brandId y brandName aquí
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
  final String brandName; // Agrega esta propiedad

  const ModelAdminList({
    super.key, 
    required this.brandId,
    required this.brandName, // Nueva propiedad
  });

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
    final provider = Provider.of<ModelProvider>(context, listen: false);
    provider.loadModelsByBrand(widget.brandId);
  });
  }

@override
Widget build(BuildContext context) {
  final provider = context.watch<ModelProvider>();
  final isMobile = MediaQuery.of(context).size.width < 600;

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      // Encabezado
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.car_repair, color: AppStyle.primary, size: 32),
                const SizedBox(width: 12),
                Text(
                  'Modelos Disponibles',
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
              'Gestiona todos los modelos registrados para esta marca',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
      const SizedBox(height: 24),

      // Barra de búsqueda
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Container(
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
              hintText: 'Buscar modelo...',
              prefixIcon: Icon(Icons.search, color: Colors.grey.shade400),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
            ),
            onChanged: provider.searchModels,
          ),
        ),
      ),
      const SizedBox(height: 24),

      // Contenido principal
      Expanded(
        child: _buildContent(provider, isMobile),
      ),
    ],
  );
}

Widget _buildContent(ModelProvider provider, bool isMobile) {
  if (provider.isLoading && provider.models.isEmpty) {
    return const Center(child: CircularProgressIndicator());
  }

  if (provider.errorMessage != null) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(provider.errorMessage!),
          ElevatedButton(
            onPressed: provider.retryLoading,
            child: const Text('Reintentar'),
          ),
        ],
      ),
    );
  }

  if (!provider.isLoading && provider.models.isEmpty && provider.errorMessage == null) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('assets/no_models.jpg', width: isMobile ? 250 : 350),
          const SizedBox(height: 20),
          Text(
            'No hay modelos registrados',
            style: TextStyle(
              fontSize: 18,
              color: AppStyle.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  return ListView.builder(
    padding: const EdgeInsets.symmetric(horizontal: 16),
    itemCount: provider.models.length,
    itemBuilder: (context, index) {
      final model = provider.models[index];
      return Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: ModelCard(
          model: model,
          brandName: provider.currentBrandName ?? 'Marca',
          onEdit: () => showEditModelDialog(context, model),
          onDelete: () => showDeleteModelDialog(context, model),
        ),
      );
    },
  );
}

  Widget _buildLoadingState(double maxHeight) {
    return SizedBox(
      height: maxHeight * 0.7,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
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
              'Cargando modelos...',
              style: TextStyle(
                color: AppStyle.primary,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(ModelProvider provider, double maxHeight) {
    return SizedBox(
      height: maxHeight * 0.7,
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(16),
          margin: const EdgeInsets.symmetric(horizontal: 24),
          decoration: BoxDecoration(
            color: Colors.red.shade50,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.red.shade200),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.error_outline, color: Colors.red.shade600, size: 48),
              const SizedBox(height: 16),
              Text(
                provider.errorMessage!,
                style: TextStyle(
                  color: Colors.red.shade800,
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: provider.retryLoading,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppStyle.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Reintentar',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(bool isMobile, double maxHeight) {
    return SizedBox(
      height: maxHeight * 0.7,
      child: Center(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(24),
            margin: const EdgeInsets.symmetric(horizontal: 24),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  'assets/nodata.png', 
                  width: isMobile ? 250 : 350,
                ),
                const SizedBox(height: 20),
                Text(
                  'No hay modelos registrados',
                  style: TextStyle(
                    fontSize: 18,
                    color: AppStyle.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Presiona el botón + para agregar un nuevo modelo',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

Widget _buildModelsList(List<StVehiclesModelsResponse> models) {
  return ListView.separated(
    physics: const NeverScrollableScrollPhysics(),
    shrinkWrap: true,
    itemCount: models.length,
    itemBuilder: (context, index) {
      final model = models[index];
      return ModelCard(
        model: model,
        brandName: widget.brandName, // Usa el brandName correcto del widget
        onEdit: () => showEditModelDialog(context, model),
        onDelete: () => showDeleteModelDialog(context, model),
      );
    },
    separatorBuilder: (context, index) => const SizedBox(height: 12),
  );
}

void showAddModelDialog(BuildContext context, int brandId) {
  final modelNameController = TextEditingController();
  final provider = Provider.of<ModelProvider>(context, listen: false);

  showDialog(
    context: context,
    builder: (context) => Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.add_circle_outline, color: AppStyle.primary, size: 28),
                const SizedBox(width: 12),
                const Text(
                  'Nuevo Modelo',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            TextField(
              controller: modelNameController,
              decoration: InputDecoration(
                labelText: 'Nombre del modelo',
                prefixIcon: Icon(Icons.car_repair, color: AppStyle.primary),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancelar'),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppStyle.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                  onPressed: () async {
                    if (modelNameController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('El nombre del modelo es requerido'),
                          backgroundColor: Colors.red,
                        ),
                      );
                      return;
                    }

                    await provider.addModels(modelNameController.text, brandId);

                    if (provider.errorMessage == null) {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Modelo agregado correctamente'),
                          backgroundColor: Colors.green,
                        ),
                      );
                    }
                  },
                  child: const Text(
                    'Guardar',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}
}
void showEditModelDialog(BuildContext context, StVehiclesModelsResponse model) {
  // Elimina el parámetro brandId si no es necesario
  final modelNameController = TextEditingController(text: model.modelName);
  final provider = Provider.of<ModelProvider>(context, listen: false);

  showDialog(
    context: context,
    builder: (context) => Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.edit, color: AppStyle.primary, size: 28),
                const SizedBox(width: 12),
                Text(
                  'Editar ${model.modelName}',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            TextField(
              controller: modelNameController,
              decoration: InputDecoration(
                labelText: 'Nombre del modelo',
                prefixIcon: Icon(Icons.car_repair, color: AppStyle.primary),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancelar'),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppStyle.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                  onPressed: () async {
                    if (modelNameController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('El nombre del modelo es requerido'),
                          backgroundColor: Colors.red,
                        ),
                      );
                      return;
                    }

                    // Lógica para actualizar el modelo
                    // await provider.updateModel(model.id!, modelNameController.text, brandId);

                    if (provider.errorMessage == null) {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Modelo actualizado correctamente'),
                          backgroundColor: Colors.green,
                        ),
                      );
                    }
                  },
                  child: const Text(
                    'Guardar',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}

void showDeleteModelDialog(BuildContext context, StVehiclesModelsResponse model) {
  final provider = Provider.of<ModelProvider>(context, listen: false);

  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      title: Row(
        children: [
          Icon(Icons.warning, color: AppStyle.yellow),
          const SizedBox(width: 12),
          Text('Eliminar ${model.modelName}'),
        ],
      ),
      content: const Text('¿Estás seguro que deseas eliminar este modelo? Esta acción no se puede deshacer.'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppStyle.red,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          onPressed: () async {
            Navigator.pop(context);
            
            // Lógica para eliminar el modelo
            // await provider.deleteModel(model.id!);
            
            if (provider.errorMessage == null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${model.modelName} eliminado correctamente'),
                  backgroundColor: Colors.green,
                ),
              );
            }
          },
          child: const Text('Eliminar', style: TextStyle(color: Colors.white)),
        ),
      ],
    ),
  );
}

