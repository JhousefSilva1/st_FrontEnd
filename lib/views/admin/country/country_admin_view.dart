import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smarttolls/api/api.dart';
import 'package:smarttolls/generated/l10n.dart';
import 'package:smarttolls/providers/country_provider.dart';
import 'package:smarttolls/style/app_style.dart';
import 'package:smarttolls/widgets/widgets.dart';

class CountryAdminView extends StatelessWidget {
  static const String routerName = 'countryAdmin';
  static const String routerPath = '/countryAdmin';
  
  const CountryAdminView({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;
    
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          S.of(context).country,
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
            onPressed: () => showAddCountryDialog(context),
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              Provider.of<CountryProvider>(context, listen: false).loadCountries();
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
              child: const CountryAdminList(),
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
                    child: Image.asset('assets/country_pattern.png', fit: BoxFit.contain),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class CountryAdminList extends StatefulWidget {
  const CountryAdminList({super.key});

  @override
  State<CountryAdminList> createState() => _CountryAdminListState();
}

class _CountryAdminListState extends State<CountryAdminList> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<CountryProvider>(context, listen: false).loadCountries();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CountryProvider>();
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Administración de Países',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppStyle.primary,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Gestiona los países disponibles',
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
              hintText: 'Buscar país...',
              prefixIcon: Icon(Icons.search, color: Colors.grey.shade400),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
            ),
            onChanged: provider.searchCountries,
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

  Widget _buildContent(CountryProvider provider) {
    if (provider.isLoading && provider.countries.isEmpty) {
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

    if (!provider.isLoading && provider.countries.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/nodata.png', width: 150),
            const SizedBox(height: 16),
            const Text('No hay países registrados'),
          ],
        ),
      );
    }

    return ListView.separated(
      itemCount: provider.countries.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final country = provider.countries[index];
        return CountryCard(
          country: country,
          onEdit: () => showEditCountryDialog(context, country),
          onDelete: () => showDeleteCountryDialog(context, country),
        );
      },
    );
  }
}

// Diálogos refactorizados
void showAddCountryDialog(BuildContext context) {
  final controller = TextEditingController();
  final provider = Provider.of<CountryProvider>(context, listen: false);

  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Agregar País'),
      content: TextField(
        controller: controller,
        decoration: const InputDecoration(
          labelText: 'Nombre del país',
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
            
            await provider.addCountry(controller.text);
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

void showEditCountryDialog(BuildContext context, StCountryResponse country) {
  final controller = TextEditingController(text: country.countryName);
  final provider = Provider.of<CountryProvider>(context, listen: false);

  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Editar País'),
      content: TextField(
        controller: controller,
        decoration: const InputDecoration(
          labelText: 'Nombre del país',
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
            
            await provider.updateCountry(country.idCountry ?? 0, controller.text);
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

void showDeleteCountryDialog(BuildContext context, StCountryResponse country) {
  final provider = Provider.of<CountryProvider>(context, listen: false);

  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Eliminar País'),
      content: Text('¿Eliminar ${country.countryName}?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
          onPressed: () async {
            Navigator.pop(context);
            await provider.deleteCountry(country.idCountry ?? 0);
          },
          child: const Text('Eliminar', style: TextStyle(color: Colors.white)),
        ),
      ],
    ),
  );
}