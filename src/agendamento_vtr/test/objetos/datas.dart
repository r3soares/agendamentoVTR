import 'dart:math';

import 'package:agendamento_vtr/app/domain/constantes.dart';

class Datas {
  static const int QUANTIDADE = 900;
  static Random r = Random();
  static List<String> datas = List.empty(growable: true);

  static geraDatas(Map agenda) {
    if (datas.isNotEmpty) return;
    for (int i = 0; i < QUANTIDADE; i++) {
      datas.add(Constants.formatoData.format(DateTime(2022).add(
        Duration(days: i),
      )));
      agenda[datas[i]] = 0;
    }
    //agenda.addAll(Map.fromIterable(datas, key: (d) => d, value: (v) => 0));
  }
}
