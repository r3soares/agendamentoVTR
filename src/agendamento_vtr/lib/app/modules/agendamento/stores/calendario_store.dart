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
  final tanquesAgendados = Bloc(ModelBase(null));

  CalendarioStore(this.repoAgenda, this.repoAt) : super(ModelBase(null));

  alteraDiaAtual(DateTime dia) async {
    //blocDiaAtual.execute(() => repoAgenda.findCreateAgenda(dia));
    blocDiaAtual.update(dia);
  }

  getAgendasOcupadas(String inicio, String fim) async {
    agendasOcupadas.execute(() => repoAgenda.findByPeriodo(inicio, fim));
  }

  getTanquesAgendados(List<String> ids) async {
    tanquesAgendados.execute(() => repoAt.getMany(ids));
  }

  void getAgendasTanque(List<String> agendasTanque) {}
}
