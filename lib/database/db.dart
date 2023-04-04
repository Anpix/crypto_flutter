import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DB {
  DB._();

  static final DB instance = DB._();
  static Database? _database;

  static String tableAccount = 'account';
  static String tableWallet = 'wallet';
  static String tableHistory = 'history';
  static String tableCurrencies = 'currencies';

  get database async {
    if (_database != null) return _database;

    return await _initDatabase();
  }

  _initDatabase() async {
    return await openDatabase(
      join(await getDatabasesPath(), 'crypto.db'),
      version: 1,
      onCreate: _onCreate,
    );
  }

  _onCreate(db, version) async {
    await db.execute(_account);
    await db.execute(_wallet);
    await db.execute(_history);
    //await db.execute(_currencies);
    await db.insert(tableAccount, {'balance': 0});
  }

  String get _account => '''
    CREATE TABLE $tableAccount (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      balance REAL
    );
  ''';

  String get _wallet => '''
    CREATE TABLE $tableWallet (
      acronym TEXT PRIMARY KEY,
      currency TEXT,
      amount TEXT
    );
  ''';

  String get _history => '''
    CREATE TABLE $tableHistory (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      operation_date INT,
      operation_type TEXT,
      currency TEXT,
      acronym TEXT,
      value REAL,
      amount TEXT
    );
  ''';
}
