import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';
import 'package:http/http.dart' as http;

import '../database/db.dart';
import '../models/currency.dart';

class CurrencyRepository extends ChangeNotifier {
  List<Currency> _table = [];
  static const String _TABLE = 'currencies';
  List<Currency> get table => _table;
  late Timer interval;

  CurrencyRepository() {
    _init();
  }

  _init() async {
    await _setupTable();
    await _setupData();
    await _readTable();
    await _refresh();
  }

  _refresh() async {
    interval = Timer.periodic(const Duration(minutes: 5), (_) => checkPrices());
  }

  checkPrices() async {
    String uri = 'https://api.coinbase.com/v2/assets/search?base=BRL';
    final response = await http.get(Uri.parse(uri));

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      final List<dynamic> currencies = json['data'];
      Database db = await DB.instance.database;
      Batch batch = db.batch();

      for (var current in _table) {
        for (var value in currencies) {
          if (current.baseId == value['base_id']) {
            final currency = value['prices'];
            final price = currency['latest_price'];
            final timestamp = DateTime.parse(price['timestamp']);

            batch.update(
              _TABLE,
              {
                'price': currency['latest'],
                'timestamp': timestamp.millisecondsSinceEpoch,
                'updateHour': price['percent_change']['hour'].toString(),
                'updateDay': price['percent_change']['day'].toString(),
                'updateWeek': price['percent_change']['week'].toString(),
                'updateMonth': price['percent_change']['month'].toString(),
                'updateYear': price['percent_change']['year'].toString(),
                'updatePeriod': price['percent_change']['all'].toString(),
              },
              where: 'baseId = ?',
              whereArgs: [current.baseId],
            );
          }
        }
      }

      await batch.commit(noResult: true);
      await _readTable();
    }
  }

  Future<bool> _tableIsEmpty() async {
    Database db = await DB.instance.database;
    List result = await db.query(_TABLE);
    return result.isEmpty;
  }

  _setupTable() async {
    String sql = '''
        CREATE TABLE IF NOT EXISTS ${DB.tableCurrencies} (
          baseId TEXT PRIMARY KEY,
          acronym TEXT,
          name TEXT,
          icon TEXT,
          price TEXT,
          timestamp INTEGER,
          updateHour TEXT,
          updateDay TEXT,
          updateWeek TEXT,
          updateMonth TEXT,
          updateYear TEXT,
          updatePeriod TEXT
        );
      ''';
    Database db = await DB.instance.database;
    await db.execute(sql);
  }

  _setupData() async {
    if (await _tableIsEmpty()) {
      String uri = 'https://api.coinbase.com/v2/assets/search?base=BRL';
      final response = await http.get(Uri.parse(uri));

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        final List<dynamic> currencies = json['data'];
        Database db = await DB.instance.database;
        Batch batch = db.batch();

        for (var currency in currencies) {
          final price = currency['latest_price'];
          final timestamp = DateTime.parse(price['timestamp']);

          batch.insert(_TABLE, {
            'baseId': currency['id'],
            'acronym': currency['symbol'],
            'name': currency['name'],
            'icon': currency['image_url'],
            'price': currency['latest'],
            'timestamp': timestamp.millisecondsSinceEpoch,
            'updateHour': price['percent_change']['hour'].toString(),
            'updateDay': price['percent_change']['day'].toString(),
            'updateWeek': price['percent_change']['week'].toString(),
            'updateMonth': price['percent_change']['month'].toString(),
            'updateYear': price['percent_change']['year'].toString(),
            'updatePeriod': price['percent_change']['all'].toString(),
          });
        }

        await batch.commit(noResult: true);
      }
    }
  }

  _readTable() async {
    Database db = await DB.instance.database;
    List result = await db.query(_TABLE);

    if (result.isNotEmpty) {
      _table = result.map((row) {
        return Currency(
          baseId: row['baseId'],
          acronym: row['acronym'],
          name: row['name'],
          icon: row['icon'],
          price: double.parse(row['price']),
          timestamp: DateTime.fromMillisecondsSinceEpoch(row['timestamp']),
          updateHour: double.parse(row['updateHour']),
          updateDay: double.parse(row['updateDay']),
          updateWeek: double.parse(row['updateWeek']),
          updateMonth: double.parse(row['updateMonth']),
          updateYear: double.parse(row['updateYear']),
          updatePeriod: double.parse(row['updatePeriod']),
        );
      }).toList();
    }

    notifyListeners();
  }
}
