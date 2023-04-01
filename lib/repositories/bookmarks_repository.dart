import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto_app/database/db_firestore.dart';
import 'package:crypto_app/repositories/currency_repository.dart';
import 'package:crypto_app/services/auth_service.dart';
import 'package:flutter/material.dart';

import '../models/currency.dart';

class BookmarksRepository extends ChangeNotifier {
  final List<Currency> _list = [];
  late FirebaseFirestore db;
  late AuthService auth;

  BookmarksRepository({required this.auth}) {
    _startRepository();
  }

  UnmodifiableListView<Currency> get list => UnmodifiableListView(_list);

  _startRepository() async {
    await _startFirestore();
    await _readBookmarks();
  }

  _startFirestore() async {
    db = DBFirestore.get();
  }

  _readBookmarks() async {
    if (auth.user != null && _list.isEmpty) {
      final snapshot = await db.collection('users/${auth.user!.uid}/bookmarks/').get();

      for (var doc in snapshot.docs) {
        Currency currency = CurrencyRepository.table.firstWhere((currency) => currency.acronym == doc.get('acronym'));
        _list.add(currency);
        notifyListeners();
      }
    }
  }

  saveAll(List<Currency> currencies) async {
    for (var currency in currencies) {
      if (!_list.any((atual) => atual.acronym == currency.acronym)) {
        _list.add(currency);
        await db.collection('users/${auth.user!.uid}/bookmarks').doc(currency.acronym).set({
          'currency': currency.name,
          'acronym': currency.acronym,
          'price': currency.price,
        });
      }
    }
    notifyListeners();
  }

  remove(Currency currency) async {
    await db.collection('users/${auth.user!.uid}/bookmarks').doc(currency.acronym).delete();

    _list.remove(currency);
    notifyListeners();
  }
}
