import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/currency.dart';
import '../repositories/currency_repository.dart';

class CurrencyPage extends StatefulWidget {
  const CurrencyPage({Key? key}) : super(key: key);

  @override
  State<CurrencyPage> createState() => _CurrencyPageState();
}

class _CurrencyPageState extends State<CurrencyPage> {
  final table = CurrencyRepository.table;
  NumberFormat real = NumberFormat.currency(locale: 'pt_BR', name: 'R\$');
  List<Currency> selected = [];

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Crypto Currencies')),
      ),
      body: ListView.separated(
        itemBuilder: (BuildContext context, int currency) {
          return ListTile(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(12)),
            ),
            leading: (selected.contains(table[currency]))
              ? const CircleAvatar(
                child: Icon(Icons.check),
              )
              : SizedBox(
                width: 40,
                child: Image.asset(table[currency].icon),
              ),
            title: Text(
              table[currency].name,
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w500,
              ),
            ),
            trailing: Text(real.format(table[currency].price)),
            selected: selected.contains(table[currency]),
            selectedTileColor: Colors.indigo[50],
            onLongPress: () {
              setState(() {
                (selected.contains(table[currency]))
                  ? selected.remove(table[currency])
                  : selected.add(table[currency]);
                debugPrint('Pressionou');
              });
            },
          );
        },
        padding: const EdgeInsets.all(16),
        separatorBuilder: (_, __) => Divider(),
        itemCount: table.length,
      ),
    );
  }
}
