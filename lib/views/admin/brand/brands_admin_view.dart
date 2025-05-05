import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:smarttolls/generated/l10n.dart';
import 'package:smarttolls/providers/providers.dart';
import 'package:smarttolls/style/app_style.dart';
import 'package:smarttolls/widgets/widgets.dart';

class BrandsAdminView extends StatelessWidget {
  static const String routerName = 'brandsAdmin';
  static const String routerPath = '/brandsAdmin';

  const BrandsAdminView({super.key});

  @override
  Widget build(BuildContext context) {
    final BrandProvider brandProvider = Provider.of<BrandProvider>(context);
    bool isMobile = ResponsiveBreakpoints.of(context).smallerThan(TABLET);
    
    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBar(
          actions: [
            IconButton(
              onPressed: () => brandProvider.goToAddBrand(context),
              icon: const Icon(Icons.add_rounded, color: AppStyle.primary, size: 30),
            )
          ],
          centerTitle: true,
          text: S.of(context).brand,
        ),
        backgroundColor: AppStyle.white,
        drawer: isMobile ? const SmartTollsDrawer() : null,
        body: isMobile
            ? const SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    children: [
                      BrandsAdminMobileView(),
                    ],
                  ),
                ),
              )
            : const BrandsAdminTabletView(),
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
  Widget build(BuildContext context) {
    final provider = context.watch<BrandProvider>();

    return Column(
      children: [
        // Barra de búsqueda
        CustomField(
          hintText: S.of(context).search,
          prefixIcon: const Icon(Icons.search),
          onChanged: (value) {
            // Implementar búsqueda
            provider.searchBrands(value);
          },
        ),
        const SizedBox(height: 16),
        
        // Estado de carga
        if (provider.isLoading && provider.brands.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 32),
            child: CircularProgressIndicator(),
          ),
        
        // Mensaje de error
        if (provider.errorMessage != null)
          Column(
            children: [
              Text(
                provider.errorMessage!,
                style: const TextStyle(color: Colors.red),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: provider.retryLoading,
                child: Text(S.of(context).retry),
              ),
              const SizedBox(height: 16),
            ],
          ),
        
        // Lista vacía
        if (!provider.isLoading && provider.brands.isEmpty && provider.errorMessage == null)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 32),
            child: Text(
              'No hay marcas registradas',
              style: TextStyle(
                color: AppStyle.grey,
                fontSize: 16,
              ),
            ),
          ),
        
        // Lista de marcas
        if (provider.brands.isNotEmpty)
          ListView.separated(
            itemCount: provider.brands.length,
            itemBuilder: (context, index) {
              final brand = provider.brands[index];
              return BrandsCard(brand: brand);
            },
            physics: const NeverScrollableScrollPhysics(),
            primary: false,
            shrinkWrap: true,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
          ),
      ],
    );
  }
}