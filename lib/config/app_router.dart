import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:smarttolls/providers/providers.dart';
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
            name: AddVehicleTypeAdminView.routerName,
            path: AddVehicleTypeAdminView.routerPath,
            builder: (context, state) => const AddVehicleTypeAdminView(),
          ),
          GoRoute(
            name: AddVehiclesAdminView.routerName,
            path: AddVehiclesAdminView.routerPath,
            builder: (context, state) => const AddVehiclesAdminView(),
          ),
          GoRoute(
            name: EditVehicleAdminView.routerName,
            path: EditVehicleAdminView.routerPath,
            builder: (context, state) => const EditVehicleAdminView(),
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
            name: TollAdminView.routerName,
            path: TollAdminView.routerPath,
            builder: (context, state) => const TollAdminView(),
          ),
          GoRoute(
            name: VehicleAdminView.routerName,
            path: VehicleAdminView.routerPath,
            builder: (context, state) => const VehicleAdminView(),
          ),
          GoRoute(
            name: VehiclesAdminView.routerName,
            path: VehiclesAdminView.routerPath,
            builder: (context, state) => const VehiclesAdminView(),
          ),
          GoRoute(
            name: VehicleTypeAdminView.routerName,
            path: VehicleTypeAdminView.routerPath,
            builder: (context, state) => const VehicleTypeAdminView(),
          ),
        ]
      ),
      ShellRoute(
        builder: (BuildContext context, GoRouterState state, Widget child) {
          return NavBarView(child: child);
        },
        navigatorKey: shellNavigatorKey,
        routes: <RouteBase>[
          GoRoute(
            name: AddVehiclesView.routerName,
            path: AddVehiclesView.routerPath,
            builder: (context, state) => const AddVehiclesView(),
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
            name: TransactionHistoryView.routerName,
            path: TransactionHistoryView.routerPath,
            builder: (context, state) => const TransactionHistoryView(),
          ),
          GoRoute(
            name: VehiclesView.routerName,
            path: VehiclesView.routerPath,
            builder: (context, state) => const VehiclesView(),
          ),
          GoRoute(
            name: WalletListView.routerName,
            path: WalletListView.routerPath,
            builder: (context, state) => const WalletListView(),
          ),
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
        name: SignUpStepTwoView.routerName,
        path: SignUpStepTwoView.routerPath,
        builder: (context, state) => const SignUpStepTwoView(),
      ),
      GoRoute(
        name: SignupView.routerName,
        path: SignupView.routerPath,
        builder: (context, state) => const SignupView(),
      ),
      GoRoute(
        name: WelcomeView.routerName,
        path: WelcomeView.routerPath,
        builder: (context, state) => const WelcomeView(),
      )
    ]
  );

  static final List<SingleChildWidget> providers = [
    ChangeNotifierProvider(create: (_) => DrawerProvider()),
    ChangeNotifierProvider(create: (_) => HomeProvider()),
    ChangeNotifierProvider(create: (_) => LoginProvider()),
    ChangeNotifierProvider(create: (_) => SelectModeProvider()),
    ChangeNotifierProvider(create: (_) => SignUpProvider()),
    ChangeNotifierProvider(create: (_) => VehicleTypeProvider()),
    ChangeNotifierProvider(create: (_) => VehiclesProvider()),
    ChangeNotifierProvider(create: (_) => WalletProvider()),
  ];
}
