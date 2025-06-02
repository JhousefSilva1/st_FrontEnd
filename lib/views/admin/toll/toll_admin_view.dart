import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smarttolls/api/api.dart';
import 'package:smarttolls/generated/l10n.dart';
import 'package:smarttolls/style/app_style.dart';
import 'package:smarttolls/widgets/widgets.dart';

import '../../../providers/providers.dart';

class TollAdminView extends StatelessWidget {
  static const String routerName = 'tollAdmin';
  static const String routerPath = '/tollAdmin';
  
  const TollAdminView({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;
    
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          S.of(context).tolls,
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
            onPressed: () => showAddTollDialog(context),
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              Provider.of<TollProvider>(context, listen: false).loadAllTolls();
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
              child: const TollAdminList(),
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
                    child: Image.asset('assets/tolls_pattern.jpg', fit: BoxFit.contain),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class TollAdminList extends StatefulWidget {
  const TollAdminList({super.key});

  @override
  State<TollAdminList> createState() => _TollAdminListState();
}

class _TollAdminListState extends State<TollAdminList> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<TollProvider>(context, listen: false).loadAllTolls();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TollProvider>();
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Administración de Peajes',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppStyle.primary,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Gestiona los peajes disponibles en el sistema',
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
              hintText: 'Buscar peaje...',
              prefixIcon: Icon(Icons.search, color: Colors.grey.shade400),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
            ),
            onChanged: provider.searchTolls,
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

  Widget _buildContent(TollProvider provider) {
    if (provider.isLoading && provider.tolls.isEmpty) {
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

    if (!provider.isLoading && provider.tolls.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/nodata.png', width: 150),
            const SizedBox(height: 16),
            const Text('No hay peajes registrados'),
          ],
        ),
      );
    }

    return ListView.separated(
      itemCount: provider.tolls.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final toll = provider.tolls[index];
        return TollCard(
          toll: toll,
          onEdit: () => showEditTollDialog(context, toll),
          onDelete: () => showDeleteTollDialog(context, toll),
        );
      },
    );
  }
}

// Diálogos
void showAddTollDialog(BuildContext context) {
  final tollNameController = TextEditingController();
  final provider = Provider.of<TollProvider>(context, listen: false);
  final countryProvider = Provider.of<CountryProvider>(context, listen: false);
  final cityProvider = Provider.of<CityProvider>(context, listen: false);
  final placeProvider = Provider.of<PlaceProvider>(context, listen: false);

  String? selectedCountryId;
  String? selectedCityId;
  String? selectedPlaceId;

  showDialog(
    context: context,
    builder: (context) => StatefulBuilder(
      builder: (BuildContext context, StateSetter setState) {
        return AlertDialog(
          title: const Text('Agregar Peaje'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: tollNameController,
                  decoration: const InputDecoration(
                    labelText: 'Nombre del peaje',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                
                // Dropdown de Países
                DropdownButtonFormField<String>(
                  value: selectedCountryId,
                  hint: const Text('País'),
                  items: countryProvider.countries.map((country) {
                    return DropdownMenuItem<String>(
                      value: country.idCountry.toString(),
                      child: Text(country.countryName ?? 'N/A'),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedCountryId = value;
                      selectedCityId = null;
                      selectedPlaceId = null;
                      if (value != null) {
                        cityProvider.loadCitiesByCountry(int.parse(value));
                      }
                    });
                  },
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                
                // Dropdown de Ciudades
                DropdownButtonFormField<String>(
                  value: selectedCityId,
                  hint: const Text('Ciudad'),
                  items: cityProvider.cities.map((city) {
                    return DropdownMenuItem<String>(
                      value: city.idCity.toString(),
                      child: Text(city.cityName ?? 'N/A'),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedCityId = value;
                      selectedPlaceId = null;
                      if (value != null) {
                        placeProvider.loadPlacesByCity(int.parse(value));
                      }
                    });
                  },
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                
                // Dropdown de Lugares
                DropdownButtonFormField<String>(
                  value: selectedPlaceId,
                  hint: const Text('Lugar'),
                  items: placeProvider.places.map((place) {
                    return DropdownMenuItem<String>(
                      value: place.idPlaces.toString(),
                      child: Text(place.placeName ?? 'N/A'),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedPlaceId = value;
                    });
                  },
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (tollNameController.text.isEmpty || selectedPlaceId == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Todos los campos son requeridos')),
                  );
                  return;
                }
                
                await provider.addToll(
                  tollNameController.text, 
                  int.parse(selectedPlaceId!)
                );
                
                if (provider.errorMessage == null) {
                  Navigator.pop(context);
                }
              },
              child: const Text('Agregar'),
            ),
          ],
        );
      },
    ),
  );
}

void showEditTollDialog(BuildContext context, StTollsResponse toll) {
  final tollNameController = TextEditingController(text: toll.tollsName);
  final provider = Provider.of<TollProvider>(context, listen: false);
  final placeProvider = Provider.of<PlaceProvider>(context, listen: false);

  String? selectedPlaceId = toll.places.idPlaces?.toString();

  showDialog(
    context: context,
    builder: (context) => StatefulBuilder(
      builder: (BuildContext context, StateSetter setState) {
        return AlertDialog(
          title: const Text('Editar Peaje'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: tollNameController,
                  decoration: const InputDecoration(
                    labelText: 'Nombre del peaje',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                
                // Dropdown de Lugares
                DropdownButtonFormField<String>(
                  value: selectedPlaceId,
                  hint: const Text('Lugar'),
                  items: placeProvider.places.map((place) {
                    return DropdownMenuItem<String>(
                      value: place.idPlaces.toString(),
                      child: Text(place.placeName ?? 'N/A'),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedPlaceId = value;
                    });
                  },
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (tollNameController.text.isEmpty || selectedPlaceId == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Todos los campos son requeridos')),
                  );
                  return;
                }
                
                await provider.updateToll(
                  toll.idTolls ?? 0,
                  tollNameController.text,
                  int.parse(selectedPlaceId!)
                );
                
                if (provider.errorMessage == null) {
                  Navigator.pop(context);
                }
              },
              child: const Text('Guardar'),
            ),
          ],
        );
      },
    ),
  );
}

void showDeleteTollDialog(BuildContext context, StTollsResponse toll) {
  final provider = Provider.of<TollProvider>(context, listen: false);

  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Eliminar Peaje'),
      content: Text('¿Eliminar ${toll.tollsName}?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
          onPressed: () async {
            Navigator.pop(context);
            await provider.deleteToll(toll.idTolls ?? 0);
          },
          child: const Text('Eliminar', style: TextStyle(color: Colors.white)),
        ),
      ],
    ),
  );
}