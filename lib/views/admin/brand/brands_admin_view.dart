import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:smarttolls/generated/l10n.dart';
import 'package:smarttolls/providers/providers.dart';
import 'package:smarttolls/style/app_style.dart';
import 'package:smarttolls/widgets/widgets.dart';

class BrandsAdminView extends StatelessWidget {
  static const String routerName = 'brands';
  static const String routerPath = '/brands';

  const BrandsAdminView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Marcas de Vehículos'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Provider.of<BrandProvider>(context, listen: false).goToAddBrand(context);
            },
          ),
        ],
      ),
      body: const BrandsList(),
    );
  }
}

class BrandsList extends StatefulWidget {
  const BrandsList({super.key});

  @override
  State<BrandsList> createState() => _BrandsListState();
}

class _BrandsListState extends State<BrandsList> {
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

    if (provider.isLoading && provider.brands.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (provider.errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(provider.errorMessage!),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: provider.retryLoading,
              child: const Text('Reintentar'),
            ),
          ],
        ),
      );
    }

    if (provider.brands.isEmpty) {
      return Center(child: Text('No hay marcas registradas'));
    }

    return RefreshIndicator(
      onRefresh: () => provider.loadBrands(),
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: provider.brands.length,
        itemBuilder: (context, index) {
          final brand = provider.brands[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: BrandsCard(brand: brand),
          );
        },
      ),
    );
  }
}