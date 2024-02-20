import 'dart:collection';

import 'package:flutter/material.dart';

class CartCountModel extends ChangeNotifier {
  /// Internal, private state of the cart.
  final List<Map> _items = [];

  /// An unmodifiable view of the items in the cart.
  UnmodifiableListView<Map> get items => UnmodifiableListView(_items);

  void add(Map item) {
    _items.add(item);
    notifyListeners();
  }

  void changeAmount(String id, int amount) {
    Map current = _items.firstWhere((element) => element["id"] == id);
    _items.removeWhere((element) => element["id"] == id);
    current["Amount"] = amount;
    _items.add(current);
    notifyListeners();
  }

  void removeItem(String id) {
    _items.removeWhere((element) => element["id"] == id);
    notifyListeners();
  }

  /// Removes all items from the cart.
  void removeAll() {
    _items.clear();
    notifyListeners();
  }
}
