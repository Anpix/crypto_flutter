import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'configs/app_settings.dart';
import 'configs/hive_config.dart';
import 'firebase_options.dart';
import 'my_app.dart';
import 'repositories/account_repository.dart';
import 'repositories/bookmarks_repository.dart';
import 'repositories/currency_repository.dart';
import 'services/auth_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await HiveConfig.start();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthService>(create: (_) => AuthService()),
        ChangeNotifierProvider<CurrencyRepository>(create: (_) => CurrencyRepository()),
        ChangeNotifierProvider<AccountRepository>(create: (_) => AccountRepository(
          currencyRepository: _.read<CurrencyRepository>(),
        )),
        ChangeNotifierProvider<BookmarksRepository>(create: (_) => BookmarksRepository(
          auth: _.read<AuthService>(),
          currencyRepository: _.read<CurrencyRepository>(),
        )),
        ChangeNotifierProvider<AppSettings>(create: (_) => AppSettings()),
      ],
      child: const MyApp(),
    ),
  );
}
