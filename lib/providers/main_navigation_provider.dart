import 'package:flutter/material.dart';

class MainNavigationProvider extends ChangeNotifier {
  int currentPage;
  MainNavigationProvider({this.currentPage = 0});

  void setPage(int indexPage) {
    if (indexPage != currentPage) {
      currentPage = indexPage;
      notifyListeners();
    }
  }
}
