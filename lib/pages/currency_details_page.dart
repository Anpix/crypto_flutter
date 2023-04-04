import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/currency.dart';
import '../repositories/account_repository.dart';

class CurrencyDetailsPage extends StatefulWidget {
  const CurrencyDetailsPage({Key? key, required this.currency}) : super(key: key);

  final Currency currency;

  @override
  State<CurrencyDetailsPage> createState() => _CurrencyDetailsPage();
}

class _CurrencyDetailsPage extends State<CurrencyDetailsPage> {
  NumberFormat real = NumberFormat.currency(locale: 'pt_BR', name: 'R\$');
  final _form = GlobalKey<FormState>();
  final _value = TextEditingController();
  double ammount = 0;
  late AccountRepository accountRepository;

  reserve() async {
    final navigator = Navigator.of(context);
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    if (_form.currentState!.validate()) {
      await accountRepository.reserve(widget.currency, double.parse(_value.text));

      navigator.pop();

      scaffoldMessenger.showSnackBar(
        const SnackBar(content: Text('The money was reserved successfully!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    //readNumberFormat();
    accountRepository = context.watch<AccountRepository>();

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.currency.name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const Divider(),
            Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.network(widget.currency.icon, scale: 2.5,),
                  Container(width: 10),
                  Text(
                    real.format(widget.currency.price),
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w600,
                      letterSpacing: -1,
                      color: Colors.grey[800],
                    ),
                  )
                ],
              ),
            ),
            (ammount > 0)
                ? SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 24),
                      padding: const EdgeInsets.all(12),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(color: Colors.teal.withOpacity(0.05)),
                      child: Text(
                        '$ammount ${widget.currency.acronym}',
                        style: const TextStyle(
                          fontSize: 20,
                          color: Colors.teal,
                        ),
                      ),
                    ),
                  )
                : Container(
                    margin: const EdgeInsets.only(bottom: 71),
                  ),
            Form(
              key: _form,
              child: TextFormField(
                controller: _value,
                style: const TextStyle(fontSize: 22),
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Value',
                  prefixIcon: Icon(Icons.monetization_on_outlined),
                  suffix: Text(
                    'reais',
                    style: TextStyle(fontSize: 14),
                  ),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Inform the value';
                  } else if (double.parse(value) < 50) {
                    return 'Minimun value to reserve is R\$ 50,00';
                  } else if (double.parse(value) > accountRepository.balance) {
                    return 'Your balance value is less than the value informed';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    ammount = (value.isEmpty) ? 0 : double.parse(value) / widget.currency.price;
                  });
                },
              ),
            ),
            Container(
              alignment: Alignment.bottomCenter,
              margin: const EdgeInsets.only(top: 24),
              child: ElevatedButton(
                  onPressed: reserve,
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.check),
                      Padding(
                        padding: EdgeInsets.all(16),
                        child: Text(
                          'Reserve',
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                    ],
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
