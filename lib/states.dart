import 'package:flutter/material.dart';

class LocationIndex extends ChangeNotifier {
  int selectedIndex = 0;

  void setIndex(int idx) {
    selectedIndex = idx;
    notifyListeners();
  }
}
