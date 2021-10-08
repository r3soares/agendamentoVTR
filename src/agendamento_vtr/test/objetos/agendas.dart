import 'dart:math';
import 'package:agendamento_vtr/app/modules/agendamento/models/agenda.dart';

import 'agendados.dart';
import 'datas.dart';

class Agendas {
  static List<Agenda> agendas = List.empty(growable: true);
  //static List<String> uuids = List.generate(QUANTIDADE, (index) => Uuid().v1());
  Random r = Random();
  Agendas() {
    if (agendas.isNotEmpty) return;

    Agendados();
    Datas.geraDatas();
    for (int i = 0; i < Datas.QUANTIDADE; i++) {
      Agenda a = Agenda(Datas.datas[i]);
      a.status = StatusAgenda.values[r.nextInt(StatusAgenda.values.length)];
      a.tanquesAgendados = getTanquesAgendados(a.data);
      agendas.add(a);
    }
  }

  getTanquesAgendados(String data) {
    List<String> agendados = List.empty(growable: true);
    for (var item in Agendados.agendados) {
      if (item.agenda == data) agendados.add(item.id);
    }
    return agendados;
  }
}
