import 'dart:math';

import 'package:agendamento_vtr/app/modules/agendamento/models/tanque_agendado.dart';
import 'package:uuid/uuid.dart';

import 'datas.dart';
import 'empresas.dart';
import 'tanques.dart';

class Agendados {
  static List<TanqueAgendado> agendados = List.empty(growable: true);
  Random r = Random();
  Agendados() {
    if (agendados.isNotEmpty) return;
    Tanques();
    Empresas();
    Datas.geraDatas();
    for (int i = 0; i < Tanques.tanques.length; i++) {
      TanqueAgendado a = TanqueAgendado(id: Uuid().v1(), tanque: Tanques.tanques[i]);
      a.statusConfirmacao = StatusConfirmacao.values[r.nextInt(StatusConfirmacao.values.length)];
      a.agenda = a.statusConfirmacao.index == 0 ? null : Datas.datas[r.nextInt(Datas.datas.length - 1)];
      a.agendaAnterior = a.agenda == null
          ? null
          : r.nextInt(10) > 9
              ? agendados.isNotEmpty
                  ? agendados[r.nextInt(agendados.length)].id
                  : null
              : null;
      a.bitremAgenda = r.nextInt(10) > 9
          ? agendados.isNotEmpty
              ? agendados[r.nextInt(agendados.length)].id
              : null
          : null;
      a.custoVerificacao = Tanques.tanques[i].custo;
      a.obs = r.nextInt(10) > 7 ? 'Observação' : null;
      a.responsavel = Empresas.empresas[r.nextInt(Empresas.empresas.length)].cnpjCpf;
      a.statusPagamento = StatusPagamento.values[r.nextInt(StatusPagamento.values.length)];
      a.tempoVerificacao = r.nextInt(5 * 60) + 30;
      agendados.add(a);
    }
  }
}
