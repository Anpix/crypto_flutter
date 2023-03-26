import 'dart:collection';

import 'package:flutter/material.dart';

import '../models/currency.dart';

class BookmarksRepository extends ChangeNotifier {
  List<Currency> _list = [];

  UnmodifiableListView<Currency> get list => UnmodifiableListView(_list);

  saveAll(List<Currency> currencies) {
    currencies.forEach((currency) {
      if (!_list.contains(currency)) _list.add(currency);
    });
    notifyListeners();
  }

  remove(Currency currency) {
    _list.remove(currency);
    notifyListeners();
  }
}
