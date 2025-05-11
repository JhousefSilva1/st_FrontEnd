import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:smarttolls/generated/l10n.dart';
import 'package:smarttolls/style/app_style.dart';

import '../../../providers/providers.dart';
import '../../../utils/utils.dart';
import '../../../widgets/widgets.dart';

class GenderAdminView extends StatelessWidget {
  static const String routerName = 'genderAdminView';
  static const String routerPath = '/genderAdminView';

  const GenderAdminView({super.key});

  @override
  Widget build(BuildContext context) {
    bool isMobile = ResponsiveBreakpoints.of(context).smallerThan(TABLET);
    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBar(
          actions: [
            IconButton(
              onPressed: () => showAddGenderDialog(context),
              icon: const Icon(Icons.add_rounded, color: AppStyle.primary, size: 30),
            )
          ],
          centerTitle: true,
          text: S.of(context).gender,
        ),
        backgroundColor: AppStyle.white,
        drawer: isMobile ? const SmartTollsDrawer() : null,
        body: isMobile
            ? const SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    children: [
                      GenderAdminMobileView(),
                    ],
                  ),
                ),
              )
            : const GenderAdminTabletView(),
      ),
    );
  }
}

class GenderAdminMobileView extends StatelessWidget {
  const GenderAdminMobileView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        GenderAdminList(),
      ],
    );
  }
}

class GenderAdminTabletView extends StatelessWidget {
  const GenderAdminTabletView({super.key});

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
                  GenderAdminList(),
                ],
              ),
            ),
          )
        )
      ],
    );
  }
}

class GenderAdminList extends StatefulWidget {
  const GenderAdminList({super.key});

  @override
  State<GenderAdminList> createState() => _GenderAdminListState();
}

class _GenderAdminListState extends State<GenderAdminList> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
        Provider.of<GenderProvider>(context, listen: false).loadGenders();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<GenderProvider>();

    return Column(
      children: [
        // barra de búsqueda
        CustomField(
          hintText: S.of(context).search,
          prefixIcon: const Icon(Icons.search, color: AppStyle.primary),
          onChanged: (value) {
            provider.searchGenders(value);
          },
        ),
        const SizedBox(height: 16),

        // Estado de carga
        if (provider.isLoading && provider.gender.isEmpty)
          const Padding(
            padding: EdgeInsets.all(16),
            child: CircularProgressIndicator(),
          ),

        // Mensaje de error
        if (provider.errorMessage != null)
          Column(
            children: [
              Text(
                provider.errorMessage!,
                style: TextStyle(color: AppStyle.red, fontSize: 16),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: provider.retryLoading,
                child: Text(
                  S.of(context).retry,
                  style: const TextStyle(color: AppStyle.white),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),

        // Lista vacía 
        if (!provider.isLoading && provider.gender.isEmpty && provider.errorMessage == null)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 32),
            child: Text(
              'No hay datos disponibles',
              style: TextStyle(color: AppStyle.primary, fontSize: 16),
            ),
          ),

        // Lista de géneros
        if (provider.gender.isNotEmpty)
          ListView.separated(
            itemCount: provider.gender.length,
            itemBuilder: (context, index) {
              final genders = provider.gender[index];
              return GenderCard(gender: genders);
            },
            physics: const NeverScrollableScrollPhysics(),
            primary: false,
            shrinkWrap: true,
            separatorBuilder: (context, index) => const SizedBox(height: 16),
          ),
      ],
    );
  }
}

void showAddGenderDialog(BuildContext context) {
  final genderNameController = TextEditingController();
  final provider = Provider.of<GenderProvider>(context, listen: false);

  Utils.textFieldAlert(
    context: context,
    content: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CustomField(
          controller: genderNameController,
          hintText: S.of(context).gender,
          keyboardType: TextInputType.text,
          prefixIcon: const Icon(Icons.person, color: AppStyle.primary),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Por favor ingrese el género';
            }
            return null;
          },
        ),
        const SizedBox(height: 10),
      ],
    ),
    negativeText: S.of(context).cancel,
    positiveOnPressed: () async {
      if (genderNameController.text.isNotEmpty) {
        await provider.addGenders(genderNameController.text);
        Navigator.of(context, rootNavigator: true).pop(); // Cierra el diálogo
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Nombre es un campo requerido')),
        );
      }
    },
    positiveText: S.of(context).add,
    title: S.of(context).addGender,
  );
}
