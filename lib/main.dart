import 'package:crypto/repositories/bookmarks_repository.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'my_app.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ListenableProvider<BookmarksRepository>(create: (_) => BookmarksRepository()),
      ],
      child: const MyApp(),
    ),
  );
}

