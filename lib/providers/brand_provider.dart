import 'package:flutter/material.dart';
import 'package:smarttolls/api/api.dart';
import 'package:smarttolls/generated/l10n.dart';
import 'package:smarttolls/utils/utils.dart';
import 'package:smarttolls/widgets/custom_field.dart';


class BrandProvider extends ChangeNotifier {
  List<StBrandResponse> _allBrands = []; // Lista completa
  List<StBrandResponse> _brands = []; // Lista filtrada
  bool _isLoading = false;
  String? _errorMessage = '';
  String? _selectedBrand = '';
  String? _newModelName;

  List<StBrandResponse> get brands => _brands;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String? get selectedBrand => _selectedBrand;
  String? get newModelName => _newModelName;

  // Método para buscar marcas
  void searchBrands(String query) {
    if (query.isEmpty) {
      _brands = List.from(_allBrands);
    } else {
      _brands = _allBrands.where((brand) => 
        brand.brandName?.toLowerCase().contains(query.toLowerCase()) ?? false
      ).toList();
    }
    notifyListeners();
  }

  // cargar marcas desde la API
  Future<void> loadBrands() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await SmartTollsApi().getAllBrands();
      
      if (response.isSuccess() && response.dataList != null) {
        _allBrands = response.dataList!;
        _brands = List.from(_allBrands);
      } else {
        _errorMessage = response.message ?? 'Error al cargar las marcas';
      }
    } catch (e) {
      _errorMessage = 'Error de conexión: ${e.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  // Agregar nueva marca
  Future<void> addBrand(String brandName) async {
    _isLoading = true;
    notifyListeners();

    try {
      // Aquí deberías implementar el método para agregar una nueva marca
      // final response = await SmartTollsApi().addBrand(brandName);
      // if (response.isSuccess()) {
      //   await loadBrands(); // Recargar la lista
      // }
    } catch (e) {
      _errorMessage = 'Error al agregar marca: ${e.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  // Mostrar diálogo para agregar marca
  void goToAddBrand(BuildContext context) {
    final brandNameController = TextEditingController();

    Utils.textFieldAlert(
      context: context,
      content: CustomField(
        controller: brandNameController,
        hintText: S.of(context).brand,
        keyboardType: TextInputType.text,
        onChanged: (value) {},
        prefixIcon: const Icon(Icons.drive_eta),
      ), 
      negativeText: S.of(context).cancel, 
      positiveOnPressed: () {
        if (brandNameController.text.isNotEmpty) {
          addBrand(brandNameController.text);
          Navigator.pop(context);
        }
      }, 
      positiveText: S.of(context).add,
      title: S.of(context).addBrand,
    );
  }



  // Método para recargar datos
  void retryLoading() {
    _errorMessage = null;
    loadBrands();
  }
}