extension Ex on double {
  double toPrecision(int n) => double.parse(toStringAsFixed(n));
}

extension DatetimeEx on DateTime {
  DateTime diaMesAno() {
    return DateTime(this.year, this.month, this.day);
  }

  String diaMesAnoToString() {
    return '${this.day}/${this.month}/${this.year}';
  }

  String anoMesDiaToString() {
    return '${this.year}-${this.month}-${this.day}';
  }
}
