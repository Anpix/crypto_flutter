import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'configs/app_settings.dart';
import 'configs/hive_config.dart';
import 'my_app.dart';
import 'repositories/bookmarks_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await HiveConfig.start();

  runApp(
    MultiProvider(
      providers: [
        ListenableProvider<BookmarksRepository>(create: (_) => BookmarksRepository()),
        ListenableProvider<AppSettings>(create: (_) => AppSettings()),
      ],
      child: const MyApp(),
    ),
  );
}
