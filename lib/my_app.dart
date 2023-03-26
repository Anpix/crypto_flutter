import 'package:flutter/material.dart';

import 'pages/currency_page.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Crypto',
      //debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        //useMaterial3: true,
      ),
      home: const CurrencyPage(),
    );
  }
}