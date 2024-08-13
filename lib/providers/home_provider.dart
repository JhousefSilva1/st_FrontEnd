import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomeProvider extends ChangeNotifier{
  int _currentIndex = 0;
  int get currentIndex => _currentIndex;

  void changeNavBar(BuildContext context, int index, String route){
    _currentIndex = index;
    context.goNamed(route);
    notifyListeners();
  }
}