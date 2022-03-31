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

  String diaHoraToString() {
    return Constants.formatoDataHora.format(this);
  }

  String HoraToString() {
    return Constants.formatoHora.format(this);
  }

  String anoMesDiaToString() {
    return '${this.year}-${this.month}-${this.day}';
  }
}

extension StringCasingExtension on String {
  String toCapitalized() =>
      length > 0 ? '${this[0].toUpperCase()}${substring(1)}' : '';
  String toTitleCase() => replaceAll(RegExp(' +'), ' ')
      .split(' ')
      .map((str) => str.toCapitalized())
      .join(' ');
}
