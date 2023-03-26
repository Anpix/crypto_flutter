import 'package:hive/hive.dart';

import '../models/currency.dart';

class CurrencyHiveAdapter extends TypeAdapter<Currency> {
  @override
  final typeId = 0;

  @override
  Currency read(BinaryReader reader) {
    return Currency(
      icon: reader.readString(),
      name: reader.readString(),
      acronym: reader.readString(),
      price: reader.readDouble(),
    );
  }

  @override
  void write(BinaryWriter writer, Currency obj) {
    writer.writeString(obj.icon);
    writer.writeString(obj.name);
    writer.writeString(obj.acronym);
    writer.writeDouble(obj.price);
  }
}
