import 'dart:math';

import 'package:agendamento_vtr/app/domain/erros.dart';
import 'package:agendamento_vtr/app/models/bloc.dart';
import 'package:agendamento_vtr/app/models/model_base.dart';
import 'package:agendamento_vtr/app/models/tanque.dart';
import 'package:agendamento_vtr/app/modules/agendamento/models/tanque_agendado.dart';
import 'package:agendamento_vtr/app/repositories/repository_agenda.dart';
import 'package:agendamento_vtr/app/repositories/repository_tanque.dart';
import 'package:agendamento_vtr/app/repositories/repository_tanque_agendado.dart';
import 'package:flutter_triple/flutter_triple.dart';

class AgendaDoDiaStore extends StreamStore<Falha, ModelBase> {
  final RepositoryAgenda repoAgenda;
  final RepositoryTanqueAgendado repoAt;
  final RepositoryTanque repoTanque;
  final Bloc blocTanques = Bloc('');

  AgendaDoDiaStore(this.repoAgenda, this.repoAt, this.repoTanque) : super(ModelBase(null));

  void salva(List<TanqueAgendado> lista) async {
    execute(() => repoAt.saveMany(lista));
  }

  void getTanques(List<String> lista) async {
    Map<String, Tanque> tanques = Map();
    setLoading(true);
    try {
      for (var t in lista) {
        ModelBase mb = await repoTanque.getTanque(t);
        tanques[t] = mb.model;
      }
      print(tanques.length);
      blocTanques.update(tanques);
    } on Falha catch (e) {
      setError(e);
    } finally {
      setLoading(false);
    }
  }
}
