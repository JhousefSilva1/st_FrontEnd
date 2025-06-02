import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smarttolls/api/api.dart';
import 'package:smarttolls/generated/l10n.dart';
import 'package:smarttolls/providers/city_provider.dart';
import 'package:smarttolls/style/app_style.dart';
import 'package:smarttolls/widgets/widgets.dart';

class CityAdminView extends StatelessWidget {
  static const String routerName = 'cityAdmin';
  static const String routerPath = '/cityAdmin/:countryId';
  
  final int countryId;

  const CityAdminView({super.key, required this.countryId});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;
    
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          S.of(context).city,
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
            onPressed: () => showAddCityDialog(context, countryId),
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              Provider.of<CityProvider>(context, listen: false).loadCitiesByCountry(countryId);
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
              child: CityAdminList(countryId: countryId),
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
                    child: Image.asset('assets/city_pattern.png', fit: BoxFit.contain),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class CityAdminList extends StatefulWidget {
  final int countryId;

  const CityAdminList({super.key, required this.countryId});

  @override
  State<CityAdminList> createState() => _CityAdminListState();
}

class _CityAdminListState extends State<CityAdminList> {
  @override
  void initState() {
    super.initState();
    _loadCities();
  }

  @override
  void didUpdateWidget(CityAdminList oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.countryId != widget.countryId) {
      _loadCities();
    }
  }

  void _loadCities() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<CityProvider>(context, listen: false)
          .loadCitiesByCountry(widget.countryId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CityProvider>();
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Administración de Ciudades',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppStyle.primary,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Gestiona las ciudades disponibles',
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
              hintText: 'Buscar ciudad...',
              prefixIcon: Icon(Icons.search, color: Colors.grey.shade400),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
            ),
            onChanged: provider.searchCities,
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

  Widget _buildContent(CityProvider provider) {
    if (provider.isLoading && provider.cities.isEmpty) {
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

    if (!provider.isLoading && provider.cities.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/nodata.png', width: 150),
            const SizedBox(height: 16),
            const Text('No hay ciudades registradas'),
          ],
        ),
      );
    }

    return ListView.separated(
      itemCount: provider.cities.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final city = provider.cities[index];
        return CityCard(
          city: city,
          onEdit: () => showEditCityDialog(context, city, widget.countryId),
          onDelete: () => showDeleteCityDialog(context, city),
        );
      },
    );
  }
}

// Diálogos refactorizados
void showAddCityDialog(BuildContext context, int countryId) {
  final controller = TextEditingController();
  final provider = Provider.of<CityProvider>(context, listen: false);

  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Agregar Ciudad'),
      content: TextField(
        controller: controller,
        decoration: const InputDecoration(
          labelText: 'Nombre de la ciudad',
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
            
            await provider.addCity(controller.text, countryId);
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

void showEditCityDialog(BuildContext context, StCityResponse city, int countryId) {
  final controller = TextEditingController(text: city.cityName);
  final provider = Provider.of<CityProvider>(context, listen: false);

  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Editar Ciudad'),
      content: TextField(
        controller: controller,
        decoration: const InputDecoration(
          labelText: 'Nombre de la ciudad',
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
            
            await provider.updateCity(city.idCity ?? 0, controller.text, countryId);
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

void showDeleteCityDialog(BuildContext context, StCityResponse city) {
  final provider = Provider.of<CityProvider>(context, listen: false);

  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Eliminar Ciudad'),
      content: Text('¿Eliminar ${city.cityName}?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
          onPressed: () async {
            Navigator.pop(context);
            await provider.deleteCity(city.idCity ?? 0);
          },
          child: const Text('Eliminar', style: TextStyle(color: Colors.white)),
        ),
      ],
    ),
  );
}