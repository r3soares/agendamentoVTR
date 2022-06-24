import 'dart:math';

import 'package:agendamento_vtr/app/modules/agendamento/models/tanque_agendado.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

import 'datas.dart';
import 'empresas.dart';
import 'responsaveis.dart';
import 'tanques.dart';

class Agendados {
  static List<TanqueAgendado> agendados = List.empty(growable: true);
  Map<String, int> agendaDia = Map();
  Random r = Random();
  Agendados() {
    if (agendados.isNotEmpty) return;
    Tanques();
    Empresas();
    Responsaveis();
    Datas.geraDatas(agendaDia);
    for (int i = 0; i < Tanques.tanques.length * 2; i++) {
      int index = r.nextInt(Tanques.tanques.length);
      TanqueAgendado a = TanqueAgendado(
          id: Uuid().v1(),
          tanque: Tanques.tanques[index],
          responsavel: Responsaveis
              .responsaveis[r.nextInt(Responsaveis.responsaveis.length)]);
      a.statusConfirmacao =
          StatusConfirmacao.values[r.nextInt(StatusConfirmacao.values.length)];
      a.agenda = _recebeAgenda(a.statusConfirmacao.index);
      a.dataInicio = a.agenda == null
          ? null
          : DateFormat('dd-MM-yyyy')
              .parse(a.agenda!)
              .add(Duration(hours: r.nextInt(6) + 8));
      if (a.dataInicio != null) {
        a.dataFim = a.dataInicio!.add(const Duration(hours: 2));
      }

      a.statusCor = corRandom().value;
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
      a.obs = r.nextInt(10) > 7 ? 'Observação' : null;
      a.responsavel = Responsaveis
          .responsaveis[r.nextInt(Responsaveis.responsaveis.length)];
      a.statusPagamento =
          StatusPagamento.values[r.nextInt(StatusPagamento.values.length)];
      a.tempoVerificacao = r.nextInt(5 * 60) + 30;
      agendados.add(a);
    }
  }

  _recebeAgenda(int confirmacao) {
    var agendaIt = agendaDia.entries;
    if (confirmacao == 0) return null;
    for (int i = 0; i < agendaIt.length; i++) {
      if (agendaIt.elementAt(i).value > 3) continue;
      var data = agendaIt.elementAt(i).key;
      agendaDia[data] = agendaDia[data]! + 1;
      return data;
    }
    return null;
  }

  Color corRandom() {
    int i = r.nextInt(10);
    switch (i) {
      case 0:
        return Colors.amber;
      case 1:
        return Colors.blue;
      case 2:
        return Colors.brown;
      case 3:
        return Colors.cyan;
      case 4:
        return Colors.deepOrange;
      case 5:
        return Colors.deepPurple;
      case 6:
        return Colors.green;
      case 7:
        return Colors.grey;
      case 8:
        return Colors.indigo;
      case 9:
        return Colors.lime;
    }
    return Colors.white;
  }
}
