import 'package:intl/intl.dart';

abstract class Constants {
  static DateFormat get formatoData => DateFormat('dd-MM-yyyy');
  static DateFormat get formatoDiaDaSemana => DateFormat('EEEE dd/MM/yy', 'pt_BR');
}
