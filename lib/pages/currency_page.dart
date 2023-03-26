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

  dynamicAppBar() {
    if (selected.isEmpty) {
      return AppBar(
        title: const Center(child: Text('Crypto Currencies')),
      );
    } else {
      return AppBar(
        leading: IconButton(
          icon: const Icon(Icons.cancel),
          onPressed: () {
            setState(() {
              selected = [];
            });
          },
        ),
        title: Text('${selected.length} selected'),
        backgroundColor: Colors.blueGrey[50],
        elevation: 1,
        iconTheme: const IconThemeData(color: Colors.black87),
        titleTextStyle: const TextStyle(
          color: Colors.black87,
          fontSize: 20,
          fontWeight: FontWeight.bold
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: dynamicAppBar(),
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
                (selected.contains(table[currency])) ? selected.remove(table[currency]) : selected.add(table[currency]);
                debugPrint('Pressionou');
              });
            },
          );
        },
        padding: const EdgeInsets.all(16),
        separatorBuilder: (_, __) => Divider(),
        itemCount: table.length,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        icon: const Icon(Icons.star),
        label: const Text(
          'FAVORITAR',
          style: TextStyle(
            letterSpacing: 0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
