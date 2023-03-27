import 'package:crypto_app/configs/app_settings.dart';
import 'package:crypto_app/repositories/account_repository.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/position.dart';

class WalletPage extends StatefulWidget {
  const WalletPage({Key? key}) : super(key: key);

  @override
  State<WalletPage> createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> {
  int index = 0;
  double walletTotal = 0;
  double balance = 0;
  late NumberFormat real;
  late AccountRepository account;

  String chartLabel = '';
  double chartValue = 0;
  List<Position> wallet = [];

  @override
  Widget build(BuildContext context) {
    account = context.watch<AccountRepository>();
    final loc = context.read<AppSettings>().locale;
    real = NumberFormat.currency(locale: loc['locale'], name: loc['name']);
    balance = account.balance;

    setWalletTotal();

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(top: 48),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 48, bottom: 8),
              child: Text(
                'Wallet value',
                style: TextStyle(fontSize: 18),
              ),
            ),
            Text(
              real.format(walletTotal),
              style: const TextStyle(
                fontSize: 35,
                fontWeight: FontWeight.w700,
                letterSpacing: -1.5,
              ),
            ),
            loadChart(),
            loadTransactions(),
          ],
        ),
      ),
    );
  }

  setWalletTotal() {
    final walletList = account.wallet;

    setState(() {
      walletTotal = account.balance;
      for (var position in walletList) {
        walletTotal += position.currency.price * position.amount;
      }
    });
  }

  loadChart() {
    return (account.balance <= 0)
        ? SizedBox(
            width: MediaQuery.of(context).size.width,
            height: 200,
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          )
        : Stack(
            alignment: Alignment.center,
            children: [
              AspectRatio(
                aspectRatio: 1,
                child: PieChart(
                  PieChartData(
                    sectionsSpace: 5,
                    centerSpaceRadius: 110,
                    sections: loadWallet(),
                    pieTouchData: PieTouchData(
                      touchCallback: touchCallback,
                    ),
                  ),
                ),
              ),
              Column(
                children: [
                  Text(
                    chartLabel,
                    style: const TextStyle(
                      fontSize: 20,
                      color: Colors.teal,
                    ),
                  ),
                  Text(
                    real.format(chartValue),
                    style: const TextStyle(fontSize: 28),
                  ),
                ],
              )
            ],
          );
  }

  loadWallet() {
    setChartData(index);
    wallet = account.wallet;
    final listLength = wallet.length + 1;

    return List.generate(listLength, (i) {
      final isTouched = i == index;
      final isBalance = i == listLength - 1;
      final fontSize = isTouched ? 18.0 : 14.0;
      final radius = isTouched ? 60.0 : 50.0;
      final color = isTouched ? Colors.tealAccent : Colors.tealAccent[400];

      double ratio = 0;
      if (!isBalance) {
        ratio = wallet[i].currency.price * wallet[i].amount / walletTotal;
      } else {
        ratio = (account.balance > 0) ? account.balance / walletTotal : 0;
      }
      ratio *= 100;

      return PieChartSectionData(
        color: color,
        value: ratio,
        title: '${ratio.toStringAsFixed(0)}%',
        radius: radius,
        titleStyle: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      );
    });
  }

  void touchCallback(FlTouchEvent touch, PieTouchResponse? response) => setState(() {
        if (response != null) {
          index = response.touchedSection!.touchedSectionIndex;
          setChartData(index);
        }
      });

  setChartData(int index) {
    if (index < 0) return;

    if (index == wallet.length) {
      chartLabel = 'Balance';
      chartValue = account.balance;
    } else {
      chartLabel = wallet[index].currency.name;
      chartValue = wallet[index].currency.price * wallet[index].amount;
    }
  }

  loadTransactions() {
    final transactions = account.transactions;
    final date = DateFormat('dd/MM/yyy - hh:mm');
    List<Widget> widgets = [];

    for (var operation in transactions) {
      widgets.add(ListTile(
        title: Text(operation.currency.name),
        subtitle: Text(date.format(operation.operationDate)),
        trailing: Text(real.format((operation.currency.price * operation.amount))),
      ));
      widgets.add(const Divider());
    }

    return Column(children: widgets);
  }
}
