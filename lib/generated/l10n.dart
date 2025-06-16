// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';




class S {
  S();
  static S? _current;




  static S get current {
    assert(_current != null, 'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }




  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();




  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false) ? locale.languageCode : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;
      return instance;
    });
  }




  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null, 'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }




  static S? maybeOf(BuildContext context) => Localizations.of<S>(context, S);


// Strings organizadas alfabéticamente
  String get accountNumber => Intl.message('Número de Cuenta', name: 'accountNumber');
  String get add => Intl.message('Agregar', name: 'add');
  String get addBrand => Intl.message('Agregar Marca', name: 'addBrand');
  String get addCity => Intl.message('ciudad', name: 'addCity');
  String get addColor => Intl.message('color', name: 'addColor');
  String get addCountry => Intl.message('Agregar País', name: 'addCountry');
  String get addEmployee => Intl.message('Agregar Empleado', name: 'addEmployee');
  String get addFuelType => Intl.message('Agregar Tipo de Combustible', name: 'addFuelType');
  String get addGender => Intl.message('Agregar Género', name: 'addGender');
  String get addLine => Intl.message('Agregar Línea', name: 'addLine');
  String get addModel => Intl.message('Agregar Modelo', name: 'addModel');
  String get addPersonType => Intl.message('Agregar Tipo de Persona', name: 'addPersonType');
  String get addPlace => Intl.message('lugar', name: 'addPlace');
  String get addRoadType => Intl.message('tipo de vía', name: 'addRoadType');
  String get addToll => Intl.message('Agregar Peaje', name: 'addToll');
  String get addVehicle => Intl.message('agregar Vehículo', name: 'addVehicle');
  String get addVehicleType => Intl.message('Agregar Tipo de Vehículo', name: 'addVehicleType');
  String get addVehicles => Intl.message('Agregar Vehículo Nuevo', name: 'addVehicles');
  String get address => Intl.message('Dirección', name: 'address');
  String get administration => Intl.message('Administración', name: 'administration');
  String get age => Intl.message('Edad', name: 'age');
  String get appName => Intl.message('Peajes Inteligentes', name: 'appName');
  String get back => Intl.message('Atrás', name: 'back');
  String get balance => Intl.message('saldo', name: 'balance');
  String get birthdate => Intl.message('Fecha de Nacimiento', name: 'birthdate');
  String get bornDate => Intl.message('Fecha de Nacimiento', name: 'bornDate');
  String get brand => Intl.message('Marca', name: 'brand');
  String get cancel => Intl.message('Cancelar', name: 'cancel');
  String get charge => Intl.message('cargar', name: 'charge');
  String get chassis => Intl.message('Chasis', name: 'chassis');
  String get chassisNumber => Intl.message('númeroDeChasis', name: 'chassisNumber');
  String get city => Intl.message('ciudad', name: 'city');
  String get circulationSquare => Intl.message('Plaza de Circulación', name: 'circulationSquare');
  String get color => Intl.message('color', name: 'color');
  String get colorNameRequired => Intl.message('nombreDeColorRequerido', name: 'colorNameRequired');
  String get colorManagement => Intl.message('Gestión de Colores', name: 'colorManagement');
  String get comingSoon => Intl.message('próximamente', name: 'comingSoon');
  String get confirmDeleteBrand => Intl.message('¿Está seguro de eliminar esta marca?', name: 'confirmDeleteBrand');
  String get confirmDeleteColor => Intl.message('¿Está seguro de eliminar este color?', name: 'confirmDeleteColor');
  String get confirmDeleteFuelType => Intl.message('¿Está seguro de eliminar este tipo de combustible?', name: 'confirmDeleteFuelType');
  String get confirmDeleteRoadType => Intl.message('¿Está seguro de eliminar este tipo de vía?', name: 'confirmDeleteRoadType');
  String get confirmPassword => Intl.message('Confirmar Contraseña', name: 'confirmPassword');
  String get contactInfo => Intl.message('informaciónDeContacto', name: 'contactInfo');
  String get continueText => Intl.message('Continuar', name: 'continueText');
  String get cost => Intl.message('Costo', name: 'cost');
  String get country => Intl.message('País', name: 'country');
  String get createAccount => Intl.message('Crear nueva cuenta en Peajes Inteligentes', name: 'createAccount');
  String get currentBalance => Intl.message('saldoActual', name: 'currentBalance');
  String get customer => Intl.message('Cliente', name: 'customer');
  String get delete => Intl.message('Eliminar', name: 'delete');
  String get deleteBrand => Intl.message('Eliminar Marca', name: 'deleteBrand');
  String get deleteColor => Intl.message('Eliminar Color', name: 'deleteColor');
  String get deleteFuelType => Intl.message('Eliminar Tipo de Combustible', name: 'deleteFuelType');
  String get deleteRoadType => Intl.message('Eliminar Tipo de Vía', name: 'deleteRoadType');
  String get deleteVehicleType => Intl.message('Eliminar Tipo de Vehículo', name: 'deleteVehicleType');
  String get deleteVehicleTypeConfirmation  => Intl.message('¿Está seguro de eliminar el tipo de vehículo');
  String get deletedSuccessfully => Intl.message('Eliminado exitosamente', name: 'deletedSuccessfully');
  String get description => Intl.message('Descripción', name: 'description');
  String get dni => Intl.message('DNI', name: 'dni');
  String get dontHaveAnAccount => Intl.message('¿No tiene una cuenta? ', name: 'dontHaveAnAccount');
  String get download => Intl.message('Descargar', name: 'download');
  String get edit => Intl.message('Editar', name: 'edit');
  String get editBrand => Intl.message('Editar Marca', name: 'editBrand');
  String get editColors => Intl.message('Editar Colores', name: 'editColors');
  String get editFuelType => Intl.message('Editar Tipo de Combustible', name: 'editFuelType');
  String get editRoadType => Intl.message('Editar Tipo de Vía', name: 'editRoadType');
  String get editVehicle => Intl.message('Editar Vehículo', name: 'editVehicle');
  String get editVehicleType => Intl.message('Editar Tipo de Vehículo', name: 'editVehicleType');
  String get email => Intl.message('Correo Electrónico', name: 'email');
  String get emailIsInvalid => Intl.message('El correo electrónico no es válido', name: 'emailIsInvalid');
  String get emailIsRequired => Intl.message('El correo electrónico es requerido', name: 'emailIsRequired');
  String get employee => Intl.message('Operador', name: 'employee');
  String get engineNumber => Intl.message('Número de Motor', name: 'engineNumber');
  String get enterLicensePlate => Intl.message('ingresePlaca', name: 'enterLicensePlate');
  String get finalSection => Intl.message('Sección Final', name: 'finalSection');
  String get foundVehicles => Intl.message('vehículosEncontrados', name: 'foundVehicles');
  String get frequentTolls => Intl.message('peajesFrecuentes', name: 'frequentTolls');
  String get fuel => Intl.message('Combustible', name: 'fuel');
  String get fuelType => Intl.message('Tipo de Combustible', name: 'addFuelType');
  String get gender => Intl.message('Género', name: 'gender');
  String get home => Intl.message('Inicio', name: 'home');
  String get initialSection => Intl.message('Sección Inicial', name: 'initialSection');
  String get insufficientBalance => Intl.message('saldoInsuficiente', name: 'insufficientBalance');
  String get introduceAmount => Intl.message('Introduzca monto', name: 'introduceAmount');
  String get last30Days => Intl.message('últimos30Días', name: 'last30Days');
  String get lastOneStep => Intl.message('Último Paso', name: 'lastOneStep');
  String get licensePlate => Intl.message('placa', name: 'licensePlate');
  String get line => Intl.message('Línea', name: 'line');
  String get lines => Intl.message('Líneas', name: 'lines');
  String get locality => Intl.message('Localidad', name: 'locality');
  String get loadingProfile => Intl.message('Cargando Perfil', name: 'loadingProfile');
  String get location => Intl.message('ubicación', name: 'location');
  String get login => Intl.message('Iniciar Sesión', name: 'login');
  String get loginToYourAccount => Intl.message('Inicie sesión en su cuenta', name: 'loginToYourAccount');
  String get logout => Intl.message('Cerrar Sesión', name: 'logout');
  String get manageAvailableColors => Intl.message('Gestionar Colores Disponibles', name: 'manageAvailableColors');
  String get managePersons => Intl.message('Gestión de Personas', name: 'People Management');
  String get manufacturingYear => Intl.message('añoDeFabricación', name: 'manufacturingYear');
  String get model => Intl.message('Modelo', name: 'model');
  String get mostUsed => Intl.message('másUsados', name: 'mostUsed');
  String get myVehicles => Intl.message('MisVehículos', name: 'myVehicles');
  String get name => Intl.message('Nombre', name: 'name');
  String get next => Intl.message('Siguiente', name: 'next');
  String get noTransactionsFound => Intl.message('noSeEncontraronTransacciones', name: 'noTransactionsFound');
  String get noUserData => Intl.message('sinDatosDeUsuario', name: 'noUserData');
  String get noVehicleSelected => Intl.message('ningúnVehículoSeleccionado', name: 'noVehicleSelected');
  String get noVehiclesFound => Intl.message('noSeEncontraronVehículos', name: 'noVehiclesFound');
  String get noColorsAvailable => Intl.message('noHayColoresDisponibles', name: 'noColorsAvailable');
  String get notification => Intl.message('Notificación', name: 'notification');
  String get origin => Intl.message('Origen', name: 'origin');
  String get password => Intl.message('Contraseña', name: 'password');
  String get passwordIsRequired => Intl.message('contraseñaRequerida', name: 'passwordIsRequired');
  String get passwordTooShort => Intl.message('contraseñaDemasiadoCorta', name: 'passwordTooShort');
  String get passwordsDontMatch => Intl.message('lasContraseñasNoCoinciden', name: 'passwordsDontMatch');
  String get pay => Intl.message('pagar', name: 'pay');
  String get payWithQr => Intl.message('Pagar con QR', name: 'payWithQr');
  String get personData => Intl.message('Datos de Persona', name: 'personData');
  String get personName => Intl.message('Nombre de Persona', name: 'personName');
  String get personSurname => Intl.message('Apellido de Persona', name: 'personSurname');
  String get personType => Intl.message('tipoDePersona', name: 'personType');
  String get personalInfo => Intl.message('informaciónPersonal', name: 'personalInfo');
  String get phone => Intl.message('Teléfono', name: 'phone');
  String get place => Intl.message('lugar', name: 'place');
  String get plate => Intl.message('Placa', name: 'plate');
  String get pleaseConfirmPassword => Intl.message('porFavorConfirmeContraseña', name: 'pleaseConfirmPassword');
  String get pleaseEnterAddress => Intl.message('porFavorIngreseDirección', name: 'pleaseEnterAddress');
  String get pleaseEnterAge => Intl.message('porFavorIngreseEdad', name: 'pleaseEnterAge');
  String get pleaseEnterDni => Intl.message('porFavorIngreseDNI', name: 'pleaseEnterDni');
  String get pleaseEnterEmail => Intl.message('porFavorIngreseCorreo', name: 'pleaseEnterEmail');
  String get pleaseEnterName => Intl.message('porFavorIngreseNombre', name: 'pleaseEnterName');
  String get pleaseEnterPassword => Intl.message('porFavorIngreseContraseña', name: 'pleaseEnterPassword');
  String get pleaseEnterSurname => Intl.message('porFavorIngreseApellido', name: 'pleaseEnterSurname');
  String get pleaseEnterValidAge => Intl.message('porFavorIngreseEdadVálida', name: 'pleaseEnterValidAge');
  String get pleaseEnterValidEmail => Intl.message('porFavorIngreseCorreoVálido', name: 'pleaseEnterValidEmail');
  String get pleaseEnterWhatsappNumber => Intl.message('porFavorIngreseNúmeroWhatsApp', name: 'pleaseEnterWhatsAppNumber');
  String get pleaseSelectBirthdate => Intl.message('porFavorSeleccioneFechaNacimiento', name: 'pleaseSelectBirthdate');
  String get pleaseSelectCity => Intl.message('porFavorSeleccioneCiudad', name: 'pleaseSelectCity');
  String get pleaseSelectCountry => Intl.message('porFavorSeleccionePaís', name: 'pleaseSelectCountry');
  String get pleaseSelectCountryFirst => Intl.message('porFavorSeleccionePaísPrimero', name: 'pleaseSelectCountryFirst');
  String get pleaseSelectGender => Intl.message('porFavorSeleccioneGénero', name: 'pleaseSelectGender');
  String get pleaseSelectPersonType => Intl.message('porFavorSeleccioneTipoDePersona', name: 'pleaseSelectPersonType');
  String get profile => Intl.message('Perfil', name: 'profile');
  String get recentActivity => Intl.message('actividadReciente', name: 'recentActivity');
  String get recentTransactions => Intl.message('transaccionesRecientes', name: 'recentTransactions');
  String get recharge => Intl.message('Recargar', name: 'recharge');
  String get rechargeWallet => Intl.message('Recargar Billetera', name: 'rechargeWallet');
  String get registeredVehicles => Intl.message('vehículosRegistrados', name: 'registeredVehicles');
  String get register => Intl.message('Registrar', name: 'register');
  String get registerCars => Intl.message('Registrar Autos', name: 'registerCars');
  String get registrationSuccessful => Intl.message('registroExitoso', name: 'registrationSuccessful');
  String get reports => Intl.message('Reportes', name: 'reports');
  String get retry => Intl.message('reintentar', name: 'retry');
  String get roadType => Intl.message('tipo de vía', name: 'roadType');
  String get scanQrToPay => Intl.message('escanearQrParaPagar', name: 'scanQrToPay');
  String get search => Intl.message('Buscar', name: 'search');
  String get searchColors => Intl.message('Buscar Colores', name: 'searchColors');
  String get seeAll => Intl.message('Ver Todos', name: 'seeAll');
  String get selectToll => Intl.message('seleccionarPeaje', name: 'selectToll');
  String get selectUserType => Intl.message('Seleccionar Tipo de Usuario', name: 'selectUserType');
  String get selectYourUser => Intl.message('Por favor, seleccione su usuario', name: 'selectYourUser');
  String get signUp => Intl.message('Registrarse', name: 'signUp');
  String get start => Intl.message('Iniciar', name: 'start');
  String get staff => Intl.message('Personal', name: 'staff');
  String get status => Intl.message('Estado', name: 'status');
  String get stepOne => Intl.message('Paso 1', name: 'stepOne');
  String get stepTwo => Intl.message('Paso 2', name: 'stepTwo');
  String get success => Intl.message('éxito', name: 'success');
  String get surname => Intl.message('apellido', name: 'surname');
  String get tollCharge => Intl.message('cargoPorPeaje', name: 'tollCharge');
  String get tollData => Intl.message('Datos de peaje', name: 'tollData');
  String get tollName => Intl.message('Nombre de Peaje', name: 'tollName');
  String get tolls => Intl.message('Peajes', name: 'tolls');
  String get tollsOperator => Intl.message('operadorDePeajes', name: 'tollsOperator');
  String get tollsUsed => Intl.message('Peajes Utilizados', name: 'tollsUsed');
  String get totalPaid => Intl.message('Total Pagado', name: 'totalPaid');
  String get transactionHistory => Intl.message('Historial de Transacciones', name: 'transactionHistory');
  String get typeOfDocument => Intl.message('Tipo de Documento', name: 'typeOfDocument');
  String get typeOfRoad => Intl.message('Tipo de Vía', name: 'typeOfRoad');
  String get typeOfVehicle => Intl.message('Tipo de Vehículo', name: 'typeOfVehicle');
  String get update => Intl.message('actualizar', name: 'update');
  String get vehicle => Intl.message('Vehículo', name: 'vehicle');
  String get vehicleData => Intl.message('Datos del vehículo', name: 'vehicleData');
  String get vehicleInfo => Intl.message('informaciónDelVehículo', name: 'vehicleInfo');
  String get vehicleService => Intl.message('Servicio de Vehículo', name: 'vehicleService');
  String get vehicleType => Intl.message('Tipo de Vehículo', name: 'vehicleType');
  String get vehicles => Intl.message('Vehículos', name: 'vehicles');
  String vehiclesCount(Object count) => Intl.message('vehículosCount', name: 'vehiclesCount', args: [count]);
  String get wallet => Intl.message('Billetera', name: 'wallet');
  String get walletBalance => Intl.message('saldoDeBilletera', name: 'walletBalance');
  String get welcome => Intl.message('¡Bienvenido!', name: 'welcome');
  String get welcomeMessage => Intl.message('mensajeDeBienvenida', name: 'welcomeMessage');
  String get whatsApp => Intl.message('WhatsApp', name: 'whatsapp');
  String get whatsappNumber => Intl.message('númeroWhatsApp', name: 'whatsappNumber');
  String get weight => Intl.message('Peso', name: 'weight');
  String get workstation => Intl.message('Puesto de Trabajo', name: 'workstation');
  String get year => Intl.message('Año', name: 'year');
}


class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();
  List<Locale> get supportedLocales => const [Locale('es')];
  @override bool isSupported(Locale locale) => ['es'].contains(locale.languageCode);
  @override Future<S> load(Locale locale) => S.load(locale);
  @override bool shouldReload(AppLocalizationDelegate old) => false;
}





