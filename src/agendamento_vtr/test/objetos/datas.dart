import 'dart:math';

import 'package:agendamento_vtr/app/domain/constantes.dart';

class Datas {
  static const int QUANTIDADE = 400;
  static Random r = Random();
  static List<String> datas = List.empty(growable: true);
  static String get _dataAleatoria => Constants.formatoData
      .format(DateTime(2020).add(Duration(days: r.nextInt(2000))));

  static geraDatas() {
    if (datas.isNotEmpty) return;
    while (datas.length < QUANTIDADE) {
      var data = _dataAleatoria;
      if (!datas.contains(data)) {
        datas.add(data);
      }
    }
  }
}
