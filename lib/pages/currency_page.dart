import 'package:flutter/material.dart';

import '../repositories/currency_repository.dart';

class CurrencyPage extends StatelessWidget {
  const CurrencyPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final table = CurrencyRepository.table;

    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Crypto Currencies')),
      ),
      body: ListView.separated(
        itemBuilder: (BuildContext context, int currency) {
          return ListTile(
            leading: Image.asset(table[currency].icon),
            title: Text(table[currency].name),
            trailing: Text(table[currency].price.toString()),
          );
        },
        padding: EdgeInsets.all(16),
        separatorBuilder: (_, __) => Divider(),
        itemCount: table.length,
      ),
    );
  }
}
