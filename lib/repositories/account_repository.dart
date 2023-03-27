import 'package:crypto_app/models/currency.dart';
import 'package:crypto_app/repositories/currency_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';

import '../database/db.dart';
import '../models/history.dart';
import '../models/position.dart';

class AccountRepository extends ChangeNotifier {
  late Database db;
  List<Position> _wallet = [];
  List<History> _transactions = [];
  double _balance = 0;

  get balance => _balance;
  List<Position> get wallet => _wallet;
  List<History> get transactions => _transactions;

  AccountRepository() {
    _initRepository();
  }

  _initRepository() async {
    await _getBalance();
    await _getWallet();
    await _getTransactions();
  }

  _getBalance() async {
    db = await DB.instance.database;
    List account = await db.query('account', limit: 1);
    _balance = account.first['balance'];
    notifyListeners();
  }

  setBalance(double amount) async {
    db = await DB.instance.database;
    db.update('account', {
      'balance': amount,
    });
    _balance = amount;
    notifyListeners();
  }

  reserve(Currency currency, double value) async {
    db = await DB.instance.database;
    await db.transaction((txn) async {
      //check if already reserved
      final positionCurrency = await txn.query('wallet', where: 'acronym = ?', whereArgs: [currency.acronym]);

      if (positionCurrency.isEmpty) {
        // Never reserved
        await txn.insert('wallet',
            {'acronym': currency.acronym, 'currency': currency.name, 'amount': (value / currency.price).toString()});
      } else {
        // Already reserved
        final current = double.parse(positionCurrency.first['amount'].toString());
        await txn.update(
          'wallet',
          {'amount': (current + (value / currency.price)).toString()},
          where: 'acronym = ?',
          whereArgs: [currency.acronym],
        );
      }

      // Add to history
      await txn.insert('history', {
        'acronym': currency.acronym,
        'currency': currency.name,
        'amount': (value / currency.price).toString(),
        'value': value,
        'operation_type': 'reservation',
        'operation_date': DateTime.now().millisecondsSinceEpoch,
      });

      // Update balance
      await txn.update('account', {'balance': balance - value});
    });

    await _initRepository();
    notifyListeners();
  }

  _getWallet() async {
    _wallet = [];
    List positions = await db.query('wallet');
    positions.forEach((element) {
      Currency currency = CurrencyRepository.table.firstWhere((c) => c.acronym == element['acronym']);

      _wallet.add(Position(
        currency: currency,
        amount: double.parse(element['amount']),
      ));
    });
    notifyListeners();
  }

  _getTransactions() async {
    _transactions = [];
    List operations = await db.query('history');
    operations.forEach((element) {
      Currency currency = CurrencyRepository.table.firstWhere((c) => c.acronym == element['acronym']);

      _transactions.add(
        History(
          operationDate: DateTime.fromMillisecondsSinceEpoch(element['operation_date']),
          operationType: element['operation_type'],
          currency: currency,
          value: element['value'],
          amount: double.parse(element['amount']),
        ),
      );
    });
    notifyListeners();
  }
}
