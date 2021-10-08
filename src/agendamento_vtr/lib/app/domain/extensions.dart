import 'package:agendamento_vtr/app/domain/constantes.dart';

extension Ex on double {
  double toPrecision(int n) => double.parse(toStringAsFixed(n));
}

extension DatetimeEx on DateTime {
  DateTime diaMesAno() {
    return DateTime(this.year, this.month, this.day);
  }

  String diaMesAnoToString() {
    return Constants.formatoData.format(this);
  }

  String anoMesDiaToString() {
    return '${this.year}-${this.month}-${this.day}';
  }
}
