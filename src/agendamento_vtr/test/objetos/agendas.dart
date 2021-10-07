import 'dart:math';

import 'package:agendamento_vtr/app/modules/agendamento/models/agenda.dart';
import 'package:uuid/uuid.dart';

import 'agendados.dart';

class Agendas {
  static const int QUANTIDADE = 300;
  static List<Agenda> agendas = List.empty(growable: true);
  static List<String> uuids = List.generate(QUANTIDADE, (index) => Uuid().v1());
  Random r = Random();
  Agendas() {
    if (agendas.isNotEmpty) return;

    Agendados();

    for (int i = 0; i < QUANTIDADE; i++) {
      Agenda a = Agenda(uuids[i], DateTime(2020).add(Duration(days: i + 1)));
      a.status = StatusAgenda.values[r.nextInt(StatusAgenda.values.length)];
      a.tanquesAgendados = r.nextInt(10) > 6
          ? List.generate(r.nextInt(5), (index) => Agendados.agendas[Agendados.agendas.length - i + index - 5].id)
          : List.empty();
      agendas.add(a);
    }
  }
}
