import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:smarttolls/providers/providers.dart';
import 'package:smarttolls/views/views.dart';

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');
final GlobalKey<NavigatorState> shellNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'shell');

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
    ChangeNotifierProvider(create: (_) => HomeProvider()),
    ChangeNotifierProvider(create: (_) => LoginProvider()),
    ChangeNotifierProvider(create: (_) => SignUpProvider()),
    ChangeNotifierProvider(create: (_) => VehiclesProvider()),
    ChangeNotifierProvider(create: (_) => WalletProvider()),
  ];
}
