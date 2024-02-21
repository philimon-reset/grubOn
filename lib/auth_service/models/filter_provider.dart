import 'package:flutter/material.dart';

class FilterModel extends ChangeNotifier {
  // set up markers for pick up locations
  final List<String> _filters = [];
  List<String> get filters => _filters;

  void addFilter(String name) {
    _filters.clear();

    _filters.add(name);
    notifyListeners();
  }

  void removeFilters() {
    _filters.clear();
    notifyListeners();
  }
}
