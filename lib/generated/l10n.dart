// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
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
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Account Number`
  String get accountNumber {
    return Intl.message(
      'Account Number',
      name: 'accountNumber',
      desc: '',
      args: [],
    );
  }

  /// `Add`
  String get add {
    return Intl.message(
      'Add',
      name: 'add',
      desc: '',
      args: [],
    );
  }

  /// `Add New Vehicle`
  String get addVehicles {
    return Intl.message(
      'Add New Vehicle',
      name: 'addVehicles',
      desc: '',
      args: [],
    );
  }

  /// `Add Vehicle Type`
  String get addVehicleType {
    return Intl.message(
      'Add Vehicle Type',
      name: 'addVehicleType',
      desc: '',
      args: [],
    );
  }

  /// `Administration`
  String get administration {
    return Intl.message(
      'Administration',
      name: 'administration',
      desc: '',
      args: [],
    );
  }

  /// `Smart Tolls`
  String get appName {
    return Intl.message(
      'Smart Tolls',
      name: 'appName',
      desc: '',
      args: [],
    );
  }

  /// `Back`
  String get back {
    return Intl.message(
      'Back',
      name: 'back',
      desc: '',
      args: [],
    );
  }

  /// `Brand`
  String get brand {
    return Intl.message(
      'Brand',
      name: 'brand',
      desc: '',
      args: [],
    );
  }

  /// `Chassis`
  String get chassis {
    return Intl.message(
      'Chassis',
      name: 'chassis',
      desc: '',
      args: [],
    );
  }

  /// `Circulation Square`
  String get circulationSquare {
    return Intl.message(
      'Circulation Square',
      name: 'circulationSquare',
      desc: '',
      args: [],
    );
  }

  /// `Completed Transactions`
  String get completedTransactions {
    return Intl.message(
      'Completed Transactions',
      name: 'completedTransactions',
      desc: '',
      args: [],
    );
  }

  /// `Confirm Password`
  String get confirmPassword {
    return Intl.message(
      'Confirm Password',
      name: 'confirmPassword',
      desc: '',
      args: [],
    );
  }

  /// `Country`
  String get country {
    return Intl.message(
      'Country',
      name: 'country',
      desc: '',
      args: [],
    );
  }

  /// `Create a new account in Smart Tolls`
  String get createAccount {
    return Intl.message(
      'Create a new account in Smart Tolls',
      name: 'createAccount',
      desc: '',
      args: [],
    );
  }

  /// `Customer`
  String get customer {
    return Intl.message(
      'Customer',
      name: 'customer',
      desc: '',
      args: [],
    );
  }

  /// `DNI`
  String get dni {
    return Intl.message(
      'DNI',
      name: 'dni',
      desc: '',
      args: [],
    );
  }

  /// `Don't have an account? `
  String get dontHaveAnAccount {
    return Intl.message(
      'Don\'t have an account? ',
      name: 'dontHaveAnAccount',
      desc: '',
      args: [],
    );
  }

  /// `Download`
  String get download {
    return Intl.message(
      'Download',
      name: 'download',
      desc: '',
      args: [],
    );
  }

  /// `Edit`
  String get edit {
    return Intl.message(
      'Edit',
      name: 'edit',
      desc: '',
      args: [],
    );
  }

  /// `Edit Vehicle`
  String get editVehicle {
    return Intl.message(
      'Edit Vehicle',
      name: 'editVehicle',
      desc: '',
      args: [],
    );
  }

  /// `Email`
  String get email {
    return Intl.message(
      'Email',
      name: 'email',
      desc: '',
      args: [],
    );
  }

  /// `Operator`
  String get employee {
    return Intl.message(
      'Operator',
      name: 'employee',
      desc: '',
      args: [],
    );
  }

  /// `Engine Number`
  String get engineNumber {
    return Intl.message(
      'Engine Number',
      name: 'engineNumber',
      desc: '',
      args: [],
    );
  }

  /// `Fuel`
  String get fuel {
    return Intl.message(
      'Fuel',
      name: 'fuel',
      desc: '',
      args: [],
    );
  }

  /// `Home`
  String get home {
    return Intl.message(
      'Home',
      name: 'home',
      desc: '',
      args: [],
    );
  }

  /// `Introduce amount`
  String get introduceAmount {
    return Intl.message(
      'Introduce amount',
      name: 'introduceAmount',
      desc: '',
      args: [],
    );
  }

  /// `Last Name (Father)`
  String get lastNameF {
    return Intl.message(
      'Last Name (Father)',
      name: 'lastNameF',
      desc: '',
      args: [],
    );
  }

  /// `Last Name (Mother)`
  String get lastNameM {
    return Intl.message(
      'Last Name (Mother)',
      name: 'lastNameM',
      desc: '',
      args: [],
    );
  }

  /// `Last One Step`
  String get lastOneStep {
    return Intl.message(
      'Last One Step',
      name: 'lastOneStep',
      desc: '',
      args: [],
    );
  }

  /// `Login`
  String get login {
    return Intl.message(
      'Login',
      name: 'login',
      desc: '',
      args: [],
    );
  }

  /// `Login to your account`
  String get loginToYourAccount {
    return Intl.message(
      'Login to your account',
      name: 'loginToYourAccount',
      desc: '',
      args: [],
    );
  }

  /// `Logout`
  String get logout {
    return Intl.message(
      'Logout',
      name: 'logout',
      desc: '',
      args: [],
    );
  }

  /// `Model`
  String get model {
    return Intl.message(
      'Model',
      name: 'model',
      desc: '',
      args: [],
    );
  }

  /// `Name`
  String get name {
    return Intl.message(
      'Name',
      name: 'name',
      desc: '',
      args: [],
    );
  }

  /// `Next`
  String get next {
    return Intl.message(
      'Next',
      name: 'next',
      desc: '',
      args: [],
    );
  }

  /// `Notification`
  String get notification {
    return Intl.message(
      'Notification',
      name: 'notification',
      desc: '',
      args: [],
    );
  }

  /// `Number of Doors`
  String get numberOfDoors {
    return Intl.message(
      'Number of Doors',
      name: 'numberOfDoors',
      desc: '',
      args: [],
    );
  }

  /// `Number of Passengers`
  String get numberOfPassengers {
    return Intl.message(
      'Number of Passengers',
      name: 'numberOfPassengers',
      desc: '',
      args: [],
    );
  }

  /// `Password`
  String get password {
    return Intl.message(
      'Password',
      name: 'password',
      desc: '',
      args: [],
    );
  }

  /// `Pay with QR`
  String get payWithQr {
    return Intl.message(
      'Pay with QR',
      name: 'payWithQr',
      desc: '',
      args: [],
    );
  }

  /// `Person Data`
  String get personData {
    return Intl.message(
      'Person Data',
      name: 'personData',
      desc: '',
      args: [],
    );
  }

  /// `Phone`
  String get phone {
    return Intl.message(
      'Phone',
      name: 'phone',
      desc: '',
      args: [],
    );
  }

  /// `Plate`
  String get plate {
    return Intl.message(
      'Plate',
      name: 'plate',
      desc: '',
      args: [],
    );
  }

  /// `Profile`
  String get profile {
    return Intl.message(
      'Profile',
      name: 'profile',
      desc: '',
      args: [],
    );
  }

  /// `Recharge Wallet`
  String get rechargeWallet {
    return Intl.message(
      'Recharge Wallet',
      name: 'rechargeWallet',
      desc: '',
      args: [],
    );
  }

  /// `Register`
  String get register {
    return Intl.message(
      'Register',
      name: 'register',
      desc: '',
      args: [],
    );
  }

  /// `Register Cars`
  String get registerCars {
    return Intl.message(
      'Register Cars',
      name: 'registerCars',
      desc: '',
      args: [],
    );
  }

  /// `Reports`
  String get reports {
    return Intl.message(
      'Reports',
      name: 'reports',
      desc: '',
      args: [],
    );
  }

  /// `Search`
  String get search {
    return Intl.message(
      'Search',
      name: 'search',
      desc: '',
      args: [],
    );
  }

  /// `See All`
  String get seeAll {
    return Intl.message(
      'See All',
      name: 'seeAll',
      desc: '',
      args: [],
    );
  }

  /// `Select User Type`
  String get selectUserType {
    return Intl.message(
      'Select User Type',
      name: 'selectUserType',
      desc: '',
      args: [],
    );
  }

  /// `Please, select your user`
  String get selectYourUser {
    return Intl.message(
      'Please, select your user',
      name: 'selectYourUser',
      desc: '',
      args: [],
    );
  }

  /// `Start`
  String get start {
    return Intl.message(
      'Start',
      name: 'start',
      desc: '',
      args: [],
    );
  }

  /// `Staff`
  String get staff {
    return Intl.message(
      'Staff',
      name: 'staff',
      desc: '',
      args: [],
    );
  }

  /// `Status`
  String get status {
    return Intl.message(
      'Status',
      name: 'status',
      desc: '',
      args: [],
    );
  }

  /// `Step 1`
  String get stepOne {
    return Intl.message(
      'Step 1',
      name: 'stepOne',
      desc: '',
      args: [],
    );
  }

  /// `Step 2`
  String get stepTwo {
    return Intl.message(
      'Step 2',
      name: 'stepTwo',
      desc: '',
      args: [],
    );
  }

  /// `Sign Up`
  String get signUp {
    return Intl.message(
      'Sign Up',
      name: 'signUp',
      desc: '',
      args: [],
    );
  }

  /// `Type of Document`
  String get typeOfDocument {
    return Intl.message(
      'Type of Document',
      name: 'typeOfDocument',
      desc: '',
      args: [],
    );
  }

  /// `Type of Vehicle`
  String get typeOfVehicle {
    return Intl.message(
      'Type of Vehicle',
      name: 'typeOfVehicle',
      desc: '',
      args: [],
    );
  }

  /// `Tolls`
  String get tolls {
    return Intl.message(
      'Tolls',
      name: 'tolls',
      desc: '',
      args: [],
    );
  }

  /// `Tolls Used`
  String get tollsUsed {
    return Intl.message(
      'Tolls Used',
      name: 'tollsUsed',
      desc: '',
      args: [],
    );
  }

  /// `Total Paid`
  String get totalPaid {
    return Intl.message(
      'Total Paid',
      name: 'totalPaid',
      desc: '',
      args: [],
    );
  }

  /// `Transaction History`
  String get transactionHistory {
    return Intl.message(
      'Transaction History',
      name: 'transactionHistory',
      desc: '',
      args: [],
    );
  }

  /// `Vehicle data`
  String get vehicleData {
    return Intl.message(
      'Vehicle data',
      name: 'vehicleData',
      desc: '',
      args: [],
    );
  }

  /// `Vehicles`
  String get vehicles {
    return Intl.message(
      'Vehicles',
      name: 'vehicles',
      desc: '',
      args: [],
    );
  }

  /// `Vehicle Service`
  String get vehicleService {
    return Intl.message(
      'Vehicle Service',
      name: 'vehicleService',
      desc: '',
      args: [],
    );
  }

  /// `Vehicle Type`
  String get vehicleType {
    return Intl.message(
      'Vehicle Type',
      name: 'vehicleType',
      desc: '',
      args: [],
    );
  }

  /// `Wallet`
  String get wallet {
    return Intl.message(
      'Wallet',
      name: 'wallet',
      desc: '',
      args: [],
    );
  }

  /// `Weight`
  String get weight {
    return Intl.message(
      'Weight',
      name: 'weight',
      desc: '',
      args: [],
    );
  }

  /// `Welcome!`
  String get welcome {
    return Intl.message(
      'Welcome!',
      name: 'welcome',
      desc: '',
      args: [],
    );
  }

  /// `Year`
  String get year {
    return Intl.message(
      'Year',
      name: 'year',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'es'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
