import 'package:crypto_app/models/currency.dart';

class History {
  DateTime operationDate;
  String operationType;
  Currency currency;
  double value;
  double amount;

  History({
    required this.operationDate,
    required this.operationType,
    required this.currency,
    required this.value,
    required this.amount,
  });
}
