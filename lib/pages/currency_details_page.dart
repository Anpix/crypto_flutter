import 'package:flutter/material.dart';

import '../models/currency.dart';

class CurrencyDetailsPage extends StatefulWidget {
  CurrencyDetailsPage({Key? key, required this.currency}) : super(key: key);

  Currency currency;

  @override
  _CurrencyDetailsPage createState() => _CurrencyDetailsPage();
}

class _CurrencyDetailsPage extends State<CurrencyDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.currency.name),
      ),
      body: Column(
        children: [
          const Divider(),
          Row(
            children: [
              SizedBox(
                width: 50,
                child: Image.asset(widget.currency.icon),
              )
          ],
          )
        ],
      ),
    );
  }
}
