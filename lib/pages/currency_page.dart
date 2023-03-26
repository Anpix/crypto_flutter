import 'package:crypto/configs/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/currency.dart';
import '../repositories/bookmarks_repository.dart';
import '../repositories/currency_repository.dart';
import 'currency_details_page.dart';

class CurrencyPage extends StatefulWidget {
  const CurrencyPage({Key? key}) : super(key: key);

  @override
  State<CurrencyPage> createState() => _CurrencyPageState();
}

class _CurrencyPageState extends State<CurrencyPage> {
  final table = CurrencyRepository.table;
  late NumberFormat real;
  late Map<String, String> loc;
  List<Currency> selected = [];
  late BookmarksRepository bookmarks;

  readNumberFormat() {
    loc = context.watch<AppSettings>().locale;
    real = NumberFormat.currency(locale: loc['locale'], name: loc['name']);
  }

  changeLanguageButton() {
    final locale = loc['locale'] == 'pt_BR' ? 'en_US' : 'pt_BR';
    final name = loc['locale'] == 'pt_BR' ? '\$' : 'R\$';

    return PopupMenuButton(
      icon: const Icon(Icons.language),
      itemBuilder: (context) => [
        PopupMenuItem(
            child: ListTile(
          leading: const Icon(Icons.swap_vert),
          title: Text('Use $locale'),
          onTap: () {
            context.read<AppSettings>().setLocale(locale, name);
            Navigator.pop(context);
          },
        ))
      ],
    );
  }

  dynamicAppBar() {
    if (selected.isEmpty) {
      return AppBar(
        title: const Center(child: Text('Crypto Currencies')),
        actions: [
          changeLanguageButton(),
        ],
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
        titleTextStyle: const TextStyle(color: Colors.black87, fontSize: 20, fontWeight: FontWeight.bold),
      );
    }
  }

  showDetails(Currency currency) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => CurrencyDetailsPage(currency: currency),
        ));
  }

  clearSelected() {
    setState(() {
      selected = [];
    });
  }

  onPressed() {
    bookmarks.saveAll(selected);
    clearSelected();
  }

  onLongPress(Currency currency) {
    setState(() {
      (selected.contains(currency)) ? selected.remove(currency) : selected.add(currency);
    });
  }

  @override
  Widget build(BuildContext context) {
    //bookmarks = Provider.of<BookmarksRepository>(context);
    bookmarks = context.watch<BookmarksRepository>();
    readNumberFormat();

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
            title: Row(
              children: [
                Text(
                  table[currency].name,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                if (bookmarks.list.contains(table[currency]))
                  const Icon(
                    Icons.star,
                    color: Colors.amber,
                    size: 15,
                  ),
              ],
            ),
            trailing: Text(
              real.format(table[currency].price),
              style: const TextStyle(fontSize: 15),
            ),
            selected: selected.contains(table[currency]),
            selectedTileColor: Colors.indigo[50],
            onLongPress: () => onLongPress(table[currency]),
            onTap: () => showDetails(table[currency]),
          );
        },
        padding: const EdgeInsets.all(16),
        separatorBuilder: (_, __) => const Divider(),
        itemCount: table.length,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: selected.isNotEmpty
          ? FloatingActionButton.extended(
              onPressed: onPressed,
              icon: const Icon(Icons.star),
              label: const Text(
                'FAVORITAR',
                style: TextStyle(
                  letterSpacing: 0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          : null,
    );
  }
}
