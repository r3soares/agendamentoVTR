import 'package:agendamento_vtr/app/domain/erros.dart';
import 'package:agendamento_vtr/app/models/bloc.dart';
import 'package:agendamento_vtr/app/models/model_base.dart';
import 'package:agendamento_vtr/app/repositories/repository_agenda.dart';
import 'package:agendamento_vtr/app/repositories/repository_agenda_tanque.dart';
import 'package:flutter_triple/flutter_triple.dart';

class CalendarioStore extends StreamStore<Falha, ModelBase> {
  final RepositoryAgenda repoAgenda;
  final RepositoryAgendaTanque repoAt;
  final blocDiaAtual = Bloc(ModelBase(null));
  final agendasOcupadas = Bloc(ModelBase(null));
  final agendasTanque = Bloc(ModelBase(null));

  CalendarioStore(this.repoAgenda, this.repoAt) : super(ModelBase(null));

  alteraDiaAtual(DateTime dia) async {
    blocDiaAtual.execute(() => repoAgenda.findCreateAgenda(dia));
  }

  listaAgendasOcupadas(DateTime inicio, DateTime fim) async {
    agendasOcupadas.execute(() => repoAgenda.findAgendas(inicio, fim));
  }

  listaAgendasTanque(List<String> agendas) async {
    agendasTanque.execute(() => repoAt.findAgendasTanqueByAgendas(agendas));
  }
}
