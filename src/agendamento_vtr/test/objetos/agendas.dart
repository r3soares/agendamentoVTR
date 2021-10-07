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
      a.tanquesAgendados = r.nextInt(10) > 6
          ? List.generate(r.nextInt(5), (index) => Agendados.agendados[Agendados.agendados.length - i + index - 5].id)
          : List.empty();
      agendas.add(a);
    }
  }
}
