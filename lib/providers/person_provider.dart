import 'package:flutter/material.dart';
import 'package:smarttolls/api/api.dart';

class PersonProvider extends ChangeNotifier{
  List<StPersonResponse> _allPersons=[];
  List<StPersonResponse> _persons=[];
  bool _isLoading = false;
  String? _errorMessage = '';
  String? _newPersonName ;
  String? _newPersonSurname;
  String? _newPersonWhatsappNumber;
  String? _newPersonPassword;
  String? _newPersonDni;
  String? _newPersonBirthdate;
  String? _newPersonEmail;
  String? _newPersonAddress;
  String? _newPersonAge;
  int ? _selectedGender;
  int ? _selectedPersonType;
  int ? _selectedCityId;
  int ? _selectedCountryId;

  List<StPersonResponse> get persons => _persons;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String? get newPersonName => _newPersonName;
  String? get newPersonSurname => _newPersonSurname;
  String? get newPersonWhatsappNumber => _newPersonWhatsappNumber;
  String? get newPersonPassword => _newPersonPassword;
  String? get newPersonDni => _newPersonDni;
  String? get newPersonBirthdate => _newPersonBirthdate;
  String? get newPersonEmail => _newPersonEmail;
  String? get newPersonAddress => _newPersonAddress;
  String? get newPersonAge => _newPersonAge;
  int? get selectedGender => _selectedGender;
  int? get selectedPersonType => _selectedPersonType;
  int? get selectedCityId => _selectedCityId;
  int? get selectedCountryId => _selectedCountryId;


  void searchPersons(String query){
    if(query.isEmpty){
      _persons = List.from(_allPersons);
    } else {
      _persons = _allPersons.where((person) =>
          person.personName?.toLowerCase().contains(query.toLowerCase()) ?? false).toList();
    }
      notifyListeners();
  }

  // Future<void>loadAllPerons() async{
  //   _isLoading = true;
  //   _errorMessage = null;
  //   notifyListeners();

  //   try{
  //     final response = await SmartTollsApi().getAllPersons();

  //     if(response.isSuccess() && response.dataList != null){
  //       _allPersons = response.dataList!;
  //       _persons = List.from(_allPersons);
  //     } else {
  //       _errorMessage = response.message ?? 'Error al cargar las personas';
  //       _allPersons = [];
  //       _persons = [];
  //     }
  //   } catch(e){
  //     _errorMessage = 'Error de conexión: ${e.toString()}';
  //   } finally {
  //     _isLoading = false;
  //     notifyListeners();
  //   }
  // }
Future<void> loadAllPersons() async {
  _isLoading = true;
  _errorMessage = null;
  notifyListeners();

  try {
    final response = await SmartTollsApi().getAllPersons();
    debugPrint('API Response: ${response.status} - ${response.message}');

    if (response.isSuccess()) {
      if (response.data != null) {
        _allPersons = [response.data!];
      } else if (response.dataList != null && response.dataList!.isNotEmpty) {
        _allPersons = response.dataList!;
      } else {
        _errorMessage = 'No se encontraron personas';
      }
      _persons = List.from(_allPersons);
    } else {
      _errorMessage = response.message ?? 'Error al cargar las personas';
    }
  } catch (e, stackTrace) {
    debugPrint('Error en loadAllPersons: $e');
    debugPrint('Stack trace: $stackTrace');
    _errorMessage = 'Error: ${e.toString()}';
  } finally {
    _isLoading = false;
    notifyListeners();
  }
}

  void updateSelectedIds(int? selectedGender, int? selectedPersonType, int? selectedCityId, int? selectedCountryId){
    _selectedGender = selectedGender;
    _selectedPersonType = selectedPersonType;
    _selectedCityId = selectedCityId;
    _selectedCountryId = selectedCountryId;
    notifyListeners();
  }

  void retryLoading(){
    _errorMessage = null;
    notifyListeners();
    loadAllPersons();
  }
}