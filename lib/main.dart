import 'package:crypto_app/firebase_options.dart';
import 'package:crypto_app/repositories/account_repository.dart';
import 'package:crypto_app/services/auth_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'configs/app_settings.dart';
import 'configs/hive_config.dart';
import 'my_app.dart';
import 'repositories/bookmarks_repository.dart';

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
        ChangeNotifierProvider<AccountRepository>(create: (_) => AccountRepository()),
        ChangeNotifierProvider<BookmarksRepository>(create: (_) => BookmarksRepository()),
        ChangeNotifierProvider<AppSettings>(create: (_) => AppSettings()),
      ],
      child: const MyApp(),
    ),
  );
}
