import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smarttolls/config/app_router.dart';

void main() => runApp(
  MultiProvider(
    providers: AppRouter.providers,
    child: const MyApp(),
  ),
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Smart Tolls',
      routerConfig: AppRouter.router,
    );
  }
}