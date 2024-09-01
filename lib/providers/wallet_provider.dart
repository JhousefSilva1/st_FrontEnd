import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:smarttolls/views/views.dart';

class WalletProvider extends ChangeNotifier {
  int _itemSelectOpt = 6;
  int get itemSelectOpt => _itemSelectOpt;
  
  void goToQr(BuildContext context) {
    context.pushNamed(QrView.routerName);
  }

  void goToRechargeWallet(BuildContext context) {
    context.pushNamed(RechargeWalletView.routerName);
  }
  
  void goToTransactionHistory(BuildContext context) {
    context.pushNamed(TransactionHistoryView.routerName);
  }

  void goToWallet(BuildContext context) {
    context.pushNamed(WalletView.routerName);
  }

  setItemSelectOpt(int itemSelectOpt) {
    _itemSelectOpt = itemSelectOpt;
    notifyListeners();
  }
}