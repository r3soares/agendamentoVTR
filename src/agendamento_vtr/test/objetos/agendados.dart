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
    for (int i = 0; i < Tanques.tanques.length * 2; i++) {
      int index = r.nextInt(Tanques.tanques.length);
      TanqueAgendado a = TanqueAgendado(id: Uuid().v1(), tanque: Tanques.tanques[index]);
      a.statusConfirmacao = StatusConfirmacao.values[r.nextInt(StatusConfirmacao.values.length)];
      a.agenda = a.statusConfirmacao.index == 0 ? null : Datas.datas[r.nextInt(Datas.datas.length)];
      // a.agendaAnterior = a.agenda == null || a.statusConfirmacao != StatusConfirmacao.Reagendado
      //     ? null
      //     : r.nextInt(10) > 9
      //         ? agendados.isNotEmpty
      //             ? agendados[r.nextInt(agendados.length)].id
      //             : null
      //         : null;
      a.bitremAgenda = r.nextInt(10) > 9
          ? agendados.isNotEmpty
              ? agendados[r.nextInt(agendados.length)].id
              : null
          : null;
      a.dataRegistro = a.tanque.dataRegistro;
      a.isNovo = r.nextInt(10) > 9;
      a.custoVerificacao = a.tanque.custo;
      a.obs = r.nextInt(10) > 7 ? 'Observação' : null;
      a.responsavel = Empresas.empresas[r.nextInt(Empresas.empresas.length)];
      a.statusPagamento = StatusPagamento.values[r.nextInt(StatusPagamento.values.length)];
      a.tempoVerificacao = r.nextInt(5 * 60) + 30;
      agendados.add(a);
    }
  }
}
