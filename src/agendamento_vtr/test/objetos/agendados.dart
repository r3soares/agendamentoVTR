import 'dart:math';

import 'package:agendamento_vtr/app/modules/agendamento/models/tanque_agendado.dart';
import 'package:uuid/uuid.dart';

import 'agendas.dart';
import 'empresas.dart';
import 'tanques.dart';

class Agendados {
  static List<TanqueAgendado> agendas = List.empty(growable: true);
  Random r = Random();
  Agendados() {
    if (agendas.isNotEmpty) return;
    Tanques();
    Empresas();
    for (int i = 0; i < Tanques.tanques.length; i++) {
      TanqueAgendado a = TanqueAgendado(
          id: Uuid().v1(), tanque: Tanques.tanques[i].placa, agenda: Agendas.uuids[r.nextInt(Agendas.QUANTIDADE)]);
      a.agendaAnterior = r.nextInt(10) > 9
          ? agendas.isNotEmpty
              ? agendas[r.nextInt(agendas.length)].id
              : null
          : null;
      a.bitremAgenda = r.nextInt(10) > 9
          ? agendas.isNotEmpty
              ? agendas[r.nextInt(agendas.length)].id
              : null
          : null;
      a.custoVerificacao = Tanques.tanques[i].custo;
      a.obs = r.nextInt(10) > 7 ? 'Observação' : null;
      a.responsavel = Empresas.empresas[r.nextInt(Empresas.empresas.length)].cnpjCpf;
      a.statusConfirmacao = StatusConfirmacao.values[r.nextInt(StatusConfirmacao.values.length)];
      a.statusPagamento = StatusPagamento.values[r.nextInt(StatusPagamento.values.length)];
      a.tempoVerificacao = r.nextInt(5 * 60) + 30;
      agendas.add(a);
    }
  }
}
