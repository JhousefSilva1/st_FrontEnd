import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:smarttolls/views/views.dart';

class WalletProvider extends ChangeNotifier {
  void goToWallet(BuildContext context) {
    context.pushNamed(WalletView.routerName);
  }
}