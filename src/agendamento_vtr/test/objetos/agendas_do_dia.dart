import 'dart:math';

import 'package:agendamento_vtr/app/modules/agendamento/models/agenda_do_dia.dart';
import 'package:uuid/uuid.dart';

import 'agendas_do_tanque.dart';

class AgendasDoDia {
  static final int QUANTIDADE = 1500;
  static List<AgendaDoDia> agendas = List.empty(growable: true);
  static List<String> uuids = List.generate(QUANTIDADE, (index) => Uuid().v1());
  Random r = Random();
  AgendasDoDia() {
    if (agendas.isNotEmpty) return;

    AgendasDoTanque();

    for (int i = 0; i < QUANTIDADE; i++) {
      AgendaDoDia a = AgendaDoDia(uuids[i]);
      a.data = DateTime(2017).add(Duration(days: i));
      a.status = StatusAgenda.values[r.nextInt(StatusAgenda.values.length)];
      a.tanquesAgendados = r.nextInt(10) > 6
          ? List.generate(
              r.nextInt(5), (index) => AgendasDoTanque.agendas[AgendasDoTanque.agendas.length - i + index - 5].id)
          : List.empty();
      agendas.add(a);
    }
  }
}