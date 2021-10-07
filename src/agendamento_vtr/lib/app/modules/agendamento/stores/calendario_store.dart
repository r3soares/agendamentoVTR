import 'package:agendamento_vtr/app/domain/erros.dart';
import 'package:agendamento_vtr/app/models/bloc.dart';
import 'package:agendamento_vtr/app/models/model_base.dart';
import 'package:agendamento_vtr/app/repositories/repository_agenda.dart';
import 'package:agendamento_vtr/app/repositories/repository_tanque_agendado.dart';
import 'package:flutter_triple/flutter_triple.dart';

class CalendarioStore extends StreamStore<Falha, ModelBase> {
  final RepositoryAgenda repoAgenda;
  final RepositoryTanqueAgendado repoAt;
  final blocDiaAtual = Bloc(ModelBase(null));
  final agendasOcupadas = Bloc(ModelBase(null));
  final agendasTanque = Bloc(ModelBase(null));

  CalendarioStore(this.repoAgenda, this.repoAt) : super(ModelBase(null));

  alteraDiaAtual(DateTime dia) async {
    //blocDiaAtual.execute(() => repoAgenda.findCreateAgenda(dia));
    blocDiaAtual.update(dia);
  }

  listaAgendasOcupadas(DateTime inicio, DateTime fim) async {
    agendasOcupadas.execute(() => repoAgenda.findByPeriodo(inicio, fim));
  }

  listaAgendasTanque(List<String> agendas) async {
    agendasTanque.execute(() => repoAt.findByAgendas(agendas));
  }

  void getAgendasTanque(List<String> agendasTanque) {}
}
