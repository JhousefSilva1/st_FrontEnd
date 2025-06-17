import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:smarttolls/providers/Auth/sign_up_provider.dart';
import 'package:smarttolls/providers/Auth/splashView.dart';
import 'package:smarttolls/providers/customer/vehicle_customer_provider.dart';
import 'package:smarttolls/providers/operador/tolls_operador_provider.dart';
import 'package:smarttolls/providers/providers.dart';
import 'package:smarttolls/views/customer/vehicles/add_vehicle_customer_view.dart';
import 'package:smarttolls/views/views.dart';

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');
final GlobalKey<NavigatorState> shellNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'shell');
final GlobalKey<NavigatorState> adminNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'shell');

class AppRouter {
  static final router = GoRouter(
    navigatorKey: rootNavigatorKey,
    debugLogDiagnostics: kDebugMode,
    routes: [
      GoRoute(
        name: LoginView.routerName,
        path: LoginView.routerPath,
        builder: (context, state) => const LoginView(),
      ),
      ShellRoute(
        builder: (BuildContext context, GoRouterState state, Widget child) {
          return NavBarAdminView(child: child);
        },
        navigatorKey: adminNavigatorKey,
        routes: <RouteBase>[
          GoRoute(
            name: AddBrandAdminView.routerName,
            path: AddBrandAdminView.routerPath,
            builder: (context, state) => const AddBrandAdminView(),
          ),
          GoRoute(
            name: AddEmployeeAdminView.routerName,
            path: AddEmployeeAdminView.routerPath,
            builder: (context, state) => const AddEmployeeAdminView(),
          ),


          GoRoute(
            name: BrandsAdminView.routerName,
            path: BrandsAdminView.routerPath,
            builder: (context, state) => const BrandsAdminView(),
          ),
 
          GoRoute(
            name: EmployeeAdminView.routerName,
            path: EmployeeAdminView.routerPath,
            builder: (context, state) => const EmployeeAdminView(),
          ),
          GoRoute(
            name: HomeAdminView.routerName,
            path: HomeAdminView.routerPath,
            builder: (context, state) => const HomeAdminView(),
          ),
          GoRoute(
            name: LineAdminView.routerName,
            path: LineAdminView.routerPath,
            builder: (context, state) => const LineAdminView(),
          ),
          GoRoute(
            name: TollAdminView.routerName,
            path: TollAdminView.routerPath,
            builder: (context, state) => const TollAdminView(),
          ),

          GoRoute(
            path: VehicleTypeAdminView.routerPath,
            name: VehicleTypeAdminView.routerName,
            builder: (context, state) => const VehicleTypeAdminView(),
          ),

          GoRoute(
            name: FuelTypeAdminView.routerName,
            path: FuelTypeAdminView.routerPath,
            builder: (context, state) => const FuelTypeAdminView(),
            ),
          GoRoute(
            name: VehiclesColorsAdminView.routerName,
            path: VehiclesColorsAdminView.routerPath,
            builder: (context, state) => const VehiclesColorsAdminView(),
            ),
          GoRoute(
            name: GenderAdminView.routerName,
            path: GenderAdminView.routerPath,
            builder: (context, state) => const GenderAdminView(),
          ),
          GoRoute(
            name: ModelsAdminView.routerName,
            path: '/modelAdmin/:idBrand', // Nota los dos puntos antes de brandId
            builder: (context, state) {
              final brandId = int.parse(state.pathParameters['idBrand'] !);
              return ModelsAdminView(brandId: brandId); // Usa parse directamente si siempre es válido
            },
          ),
          // city
            GoRoute(
              name: CityAdminView.routerName,
              path: '/cityAdmin/:idCountry',
              builder: (context, state) {
                final countryId = int.parse(state.pathParameters['idCountry']!); // Usa parse directamente si siempre es válido
                return CityAdminView(countryId: countryId);
              },
            ),
            // place
            GoRoute(
              name: PlaceAdminView.routerName,
              path: '/placeAdmin/:idCity',
              builder: (context, state) {
                final cityId = int.parse(state.pathParameters['idCity']!); // Usa parse directamente si siempre es válido
                return PlaceAdminView(cityId: cityId);
              },
            ),

            GoRoute(
            name: CountryAdminView.routerName,
            path: CountryAdminView.routerPath,
            builder: (context, state) => const CountryAdminView(),
          ),
          GoRoute(
            name: RoadTypeAdminView.routerName,
            path: RoadTypeAdminView.routerPath,
            builder: (context, state) => const RoadTypeAdminView(),
          ),
            GoRoute(
            name: PersonTypeAdminView.routerName,
            path: PersonTypeAdminView.routerPath,
            builder: (context, state) => const PersonTypeAdminView(),
            ),
            // staff Type
            GoRoute(
            name: StaffPreviewAdminView.routerName,
            path: StaffPreviewAdminView.routerPath,
            builder: (context, state) => const StaffPreviewAdminView(),
            ),
            // persons
            GoRoute(
              name: PersonAdminView.routerName,
              path: PersonAdminView.routerPath,
              builder: (context, state) => const PersonAdminView(),
            ),
            // En tu configuración de rutas
            GoRoute(
              name: ProfileView.routerName,
              path: ProfileView.routerPath,
              builder: (context, state) => const ProfileView(),
            ),
            GoRoute(
              name: VehiclesAdminView.routerName,
              path: VehiclesAdminView.routerPath,
              builder: (context, state) => const VehiclesAdminView(),
            ),
        ]
      ),
      // cliete
      ShellRoute(
        builder: (BuildContext context, GoRouterState state, Widget child) {
          return NavBarView(child: child);
        },
        navigatorKey: shellNavigatorKey,
        routes: <RouteBase>[

          // funcionando
          GoRoute(
              name: VehiclesCustomerView.routerName,
              path: VehiclesCustomerView.routerPath,
              builder: (context, state) => const VehiclesCustomerView(),
          ),
          // profile
              GoRoute(
              name: ProfileCustomerView .routerName,
              path: ProfileCustomerView .routerPath,
              builder: (context, state) => const ProfileCustomerView (),
            ),

          GoRoute(
            name: HomeView.routerName,
            path: HomeView.routerPath,
            builder: (context, state) => const HomeView(),
          ),
          GoRoute(
            name: NotificationView.routerName,
            path: NotificationView.routerPath,
            builder: (context, state) => const NotificationView(),
          ),
          GoRoute(
            name: QrView.routerName,
            path: QrView.routerPath,
            builder: (context, state) => const QrView(),
          ),
          GoRoute(
            name: RechargeWalletView.routerName,
            path: RechargeWalletView.routerPath,
            builder: (context, state) => const RechargeWalletView(),
          ),
          GoRoute(
            name: SplashView.routerName,
            path: SplashView.routerPath,
            builder: (context, state) => const SplashView(),
          ),

          // GoRoute(
          //   name: TransactionHistoryView.routerName,
          //   path: TransactionHistoryView.routerPath,
          //   builder: (context, state) => const TransactionHistoryView(),
          // ),

          // GoRoute(
          //   name: WalletListView.routerName,
          //   path: WalletListView.routerPath,
          //   builder: (context, state) => const WalletListView(),
          // ),
          GoRoute(
            name: WalletView.routerName,
            path: WalletView.routerPath,
            builder: (context, state) => const WalletView(),
          ),
        ]
      ),
      GoRoute(
        name: SelectModeView.routerName,
        path: SelectModeView.routerPath,
        builder: (context, state) => const SelectModeView(),
      ),

      GoRoute(
        name: SignUpView.routerName,
        path: SignUpView.routerPath,
        builder: (context, state) => const SignUpView(),
      ),
      GoRoute(
        name: WelcomeView.routerName,
        path: WelcomeView.routerPath,
        builder: (context, state) => const WelcomeView(),
      ),
      // Dentro de las rutas del ShellRoute para cliente
        GoRoute(
          name: AddVehicleCustomerView.routerName,
          path: AddVehicleCustomerView.routerPath,
          builder: (context, state) => const AddVehicleCustomerView(),
        ),

      // operador
      GoRoute(
        name: HomeOperadorView.routerName,
        path: HomeOperadorView.routerPath,
        builder: (context, state) => const HomeOperadorView(),
      ),
      GoRoute(
        name: ProfileOperadorView.routerName,
        path: ProfileOperadorView.routerPath,
        builder: (context, state) => const ProfileOperadorView(),
      ),
      GoRoute(
        name: TollsOperadorView.routerName,
        path: TollsOperadorView.routerPath,
        builder: (context, state) => const TollsOperadorView(),
      ),
    ]
  );

  static final List<SingleChildWidget> providers = [
    ChangeNotifierProvider(create: (_) => BrandProvider()),
    ChangeNotifierProvider(create: (_) => DrawerProvider()),
    ChangeNotifierProvider(create: (_) => EmployeeProvider()),
    ChangeNotifierProvider(create: (_) => HomeProvider()),
    ChangeNotifierProvider(create: (_) => LineProvider()),
    ChangeNotifierProvider(create: (_) => LoginProvider()),
    ChangeNotifierProvider(create: (_) => SelectModeProvider()),
    ChangeNotifierProvider(create: (_) => SignUpProvider()),
    ChangeNotifierProvider(create: (_) => TollProvider()),
    ChangeNotifierProvider(create: (_) => VehicleTypeProvider()),
    ChangeNotifierProvider(create: (_) => VehiclesProvider()),
    ChangeNotifierProvider(create: (_) => WalletProvider()),
    ChangeNotifierProvider(create: (_) => FuelTypeProvider()),
    ChangeNotifierProvider(create: (_) => VehiclesColorsProvider()),
    ChangeNotifierProvider(create: (_) => ModelProvider()),
    ChangeNotifierProvider(create:  (_) => CountryProvider()),
    ChangeNotifierProvider(create: (_) => CityProvider()),
    ChangeNotifierProvider(create: (_) => PlaceProvider()),
    ChangeNotifierProvider(create: (_) => RoadTypesProvider()),
    ChangeNotifierProvider(create: (_) => GenderProvider()),
    ChangeNotifierProvider(create: (_) => PersonTypeProvider()),
    ChangeNotifierProvider(create: (_) => StaffPreviewProvider()),
    ChangeNotifierProvider(create: (_) => PersonProvider()),
    ChangeNotifierProvider(create: (_) => UserProvider()),
    ChangeNotifierProvider(create: (_) => ProfileProvider()),
    ChangeNotifierProvider(create: (_) => VehiclesCustomerProvider()),
    ChangeNotifierProvider(create: (_) => TollsOperadorProvider()),

    // customers
    // ChangeNotifierProvider(create: (_) => VehicleCustomerProvider()),



  ];
}
