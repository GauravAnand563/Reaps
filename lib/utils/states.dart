import 'package:flutter/material.dart';

class LocationIndex extends ChangeNotifier {
  int selectedIndex = 0;

  void setIndex(int idx) {
    selectedIndex = idx;
    notifyListeners();
  }
}

class IntervalChooserState extends ChangeNotifier {
  int selectedInterval = 0;

  void setInterval(int idx) {
    selectedInterval = idx;
    notifyListeners();
  }
}
