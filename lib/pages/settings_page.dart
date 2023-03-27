import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../configs/app_settings.dart';
import '../repositories/account_repository.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    final account = context.watch<AccountRepository>();
    final loc = context.watch<AppSettings>().locale;
    NumberFormat real = NumberFormat.currency(locale: loc['locale'], name: loc['name']);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Account'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            ListTile(
              title: const Text('Balance'),
              subtitle: Text(
                real.format(account.balance),
                style: const TextStyle(fontSize: 25, color: Colors.indigo),
              ),
              trailing: IconButton(
                onPressed: updateBalance,
                icon: const Icon(Icons.edit),
              ),
            ),
            const Divider(),
          ],
        ),
      ),
    );
  }

  updateBalance() async {
    final form = GlobalKey<FormState>();
    final value = TextEditingController();
    final account = context.read<AccountRepository>();

    value.text = account.balance.toString();

    AlertDialog dialog = AlertDialog(
      title: const Text('Update balance'),
      content: Form(
        key: form,
        child: TextFormField(
          controller: value,
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d*')),
          ],
          validator: (value) {
            if (value!.isEmpty) return 'Please inform the balance';
            return null;
          },
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('CANCEL')),
        TextButton(
          onPressed: () {
            if (form.currentState!.validate()) {
              account.setBalance(double.parse(value.text));
              Navigator.pop(context);
            }
          },
          child: const Text('SAVE'),
        ),
      ],
    );

    showDialog(context: context, builder: (context) => dialog);
  }
}
