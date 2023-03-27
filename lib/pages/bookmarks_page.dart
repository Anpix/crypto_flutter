import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../repositories/bookmarks_repository.dart';
import '../widgets/currency_card.dart';

class BookmarksPage extends StatefulWidget {
  const BookmarksPage({Key? key}) : super(key: key);

  @override
  State<BookmarksPage> createState() => _BookmarksPageState();
}

class _BookmarksPageState extends State<BookmarksPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bookmarked Cryptos'),
      ),
      body: Container(
        color: Colors.indigo.withOpacity(0.05),
        height: MediaQuery.of(context).size.height,
        padding: const EdgeInsets.all(12),
        child: Consumer<BookmarksRepository>(
          builder: (context, bookmarks, child) {
            return bookmarks.list.isEmpty
                ? const ListTile(
                    leading: Icon(Icons.star),
                    title: Text('No crypto bookmarked'),
                  )
                : ListView.builder(
                  itemCount: bookmarks.list.length,
                  itemBuilder: (_, index) {
                    return CurrencyCard(currency: bookmarks.list[index]);
                  },
                );
          },
        )
      ),
    );
  }
}
