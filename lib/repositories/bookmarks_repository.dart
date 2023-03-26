import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../adapters/currency_hive_adapter.dart';
import '../models/currency.dart';

class BookmarksRepository extends ChangeNotifier {
  List<Currency> _list = [];
  late LazyBox box;

  BookmarksRepository() {
    _startRepository();
  }

  UnmodifiableListView<Currency> get list => UnmodifiableListView(_list);

  _startRepository() async {
    await _openBox();
    await _readBookmarks();
  }

  _openBox() async {
    Hive.registerAdapter(CurrencyHiveAdapter());
    box = await Hive.openLazyBox<Currency>('bookmarks');
  }

  _readBookmarks() {
    box.keys.forEach((currency) async {
      Currency c = await box.get(currency);
      _list.add(c);
      notifyListeners();
    });
  }

  saveAll(List<Currency> currencies) {
    currencies.forEach((currency) {
      if (!_list.any((atual) => atual.acronym == currency.acronym)) {
        _list.add(currency);
        box.put(currency.acronym, currency);
      }
    });
    notifyListeners();
  }

  remove(Currency currency) {
    _list.remove(currency);
    box.delete(currency.acronym);
    notifyListeners();
  }
}
