import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:smarttolls/providers/login_provider.dart';
import 'package:smarttolls/views/login/login_view.dart';
import 'package:smarttolls/views/signup/signup_view.dart';
import 'package:smarttolls/views/welcome/welcome_view.dart';

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');

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
    ChangeNotifierProvider(create: (_) => LoginProvider()),
  ];
}
