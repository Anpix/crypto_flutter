class Currency {
  String baseId;
  String icon;
  String name;
  String acronym;
  double price;
  DateTime timestamp;
  double updateHour;
  double updateDay;
  double updateWeek;
  double updateMonth;
  double updateYear;
  double updatePeriod;

  Currency({
    required this.baseId,
    required this.icon,
    required this.name,
    required this.acronym,
    required this.price,
    required this.timestamp,
    required this.updateHour,
    required this.updateDay,
    required this.updateWeek,
    required this.updateMonth,
    required this.updateYear,
    required this.updatePeriod,
  });
}
