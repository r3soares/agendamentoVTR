import 'dart:math';

import 'package:agendamento_vtr/app/domain/constantes.dart';

class Datas {
  static const int QUANTIDADE = 300;
  static Random r = Random();
  static List<String> datas = List.empty(growable: true);
  static String get _dataAleatoria => Constants.formatoData.format(DateTime(2019).add(Duration(days: r.nextInt(3000))));

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
