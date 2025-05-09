import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:smarttolls/generated/l10n.dart';
import 'package:smarttolls/style/app_style.dart';
import 'package:smarttolls/utils/utils.dart';
import 'package:smarttolls/widgets/widgets.dart';

import '../../../providers/providers.dart';

class PlaceAdminView extends StatelessWidget{

  static const String routerName = 'placeAdmin';
  static const String routerPath = '/placeAdmin/:cityId';

  final int cityId;

  const PlaceAdminView({super.key, required this.cityId});

  @override
  Widget build(BuildContext context) {
    bool isMobile = ResponsiveBreakpoints.of(context).smallerThan(TABLET);
    
    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBar(
          actions:[
            IconButton(
              onPressed: () => showAddPlaceDialog(context, cityId),
              icon: const Icon(Icons.add_rounded, color: AppStyle.primary, size: 30),
            )
          ],
          centerTitle: true,
          text: S.of(context).place,
        ),
        backgroundColor: AppStyle.white,
        body: isMobile
            ? SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    children: [
                      PlaceAdminList(cityId: cityId), // Pasa el cityId aquí
                    ],
                  ),
                ),
              )
            : PlaceAdminTabletView(cityId: cityId), // Y aquí
      ),
    );
  }
}

class PlaceAdminTabletView extends StatelessWidget {
  final int cityId;

  const PlaceAdminTabletView({super.key, required this.cityId});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const SmartTollsDrawer(),
        Expanded(
          flex: 2,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  PlaceAdminList(cityId: cityId), // Pasa el cityId aquí
                ],
              ),
            ),
          )
          
          )
      ],
    );
  }
}

class PlaceAdminList extends StatefulWidget{
  final int cityId;

  const PlaceAdminList({super.key, required this.cityId});

  @override
  State<PlaceAdminList> createState() => _PlaceAdminListState();
}

class _PlaceAdminListState extends State<PlaceAdminList> {
  @override
  void initState() {
    super.initState();
    _loadPlaces();
  }

  @override
    void didUpdateWidget(PlaceAdminList oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.cityId != widget.cityId) {
      _loadPlaces();
    }
  }

    void _loadPlaces() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<PlaceProvider>(context, listen: false);
      provider.loadPlacesByCity(widget.cityId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<PlaceProvider>(context);

    return Column(
      children: [
        CustomField(
          hintText: S.of(context).search,
          prefixIcon: const Icon(Icons.search, color: AppStyle.primary),
          onChanged: (value) {
            provider.searchPlaces(value);
          },
        ),
        const SizedBox(height: 16),

        if(provider.isLoading && provider.places.isEmpty)
          const Padding(
            padding: EdgeInsets.all(16),
            child: CircularProgressIndicator(color: AppStyle.primary, strokeWidth: 2.5),
          ),

          if(provider.errorMessage != null)
          Column(
            children: [
              Text(
                provider.errorMessage!,
                style: const TextStyle(
                  fontSize: 16,
                  color: AppStyle.red,
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: provider.retryLoading,
                child: Text(S.of(context).retry,
                  style: const TextStyle(
                    fontSize: 16,
                    color: AppStyle.white,
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),

          if(!provider.isLoading && provider.places.isEmpty && provider.errorMessage == null)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 32),
              child: Text('No Hay Lugares',
                style: const TextStyle(
                  fontSize: 16,
                  color: AppStyle.primary,
                ),
              ),
            ),
          
          if(provider.places.isNotEmpty)
            ListView.separated(
              itemCount: provider.places.length,
              itemBuilder: (context, index) {
                final place = provider.places[index];
                return PlaceCard(place: place);
              },
              physics: const NeverScrollableScrollPhysics(),
              primary: false,
              shrinkWrap: true,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
            )
      ],
    );
  } 


}

void showAddPlaceDialog(BuildContext context, int cityId) {
  final placeNameController = TextEditingController();
  final provider = Provider.of<PlaceProvider>(context, listen: false);

    Utils.textFieldAlert(
    context: context,
    content: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CustomField(
          controller: placeNameController,
          hintText: S.of(context).place,
          keyboardType: TextInputType.text,
          prefixIcon: const Icon(Icons.location_city, color: AppStyle.primary),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Por favor ingrese el nombre de la ciudad';
            }
            return null;
          },
        ),
        const SizedBox(height: 10),
      ],
    ),
    negativeText: S.of(context).cancel,
    positiveOnPressed: () async {
      if (placeNameController.text.isNotEmpty) {
        await provider.addPlace(placeNameController.text, cityId);
        Navigator.of(context, rootNavigator: true).pop();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('El nombre de la ciudad es requerido')),
        );
      }
    },
    positiveText: S.of(context).add,
    title: S.of(context).addCity,
  );

}
