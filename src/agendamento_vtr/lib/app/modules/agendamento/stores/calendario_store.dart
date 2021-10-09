import 'package:agendamento_vtr/app/domain/erros.dart';
import 'package:agendamento_vtr/app/models/bloc.dart';
import 'package:agendamento_vtr/app/models/model_base.dart';
import 'package:agendamento_vtr/app/modules/agendamento/models/agenda.dart';
import 'package:agendamento_vtr/app/modules/agendamento/models/agenda_model.dart';
import 'package:agendamento_vtr/app/modules/agendamento/models/tanque_agendado.dart';
import 'package:agendamento_vtr/app/repositories/repository_agenda.dart';
import 'package:agendamento_vtr/app/repositories/repository_tanque_agendado.dart';
import 'package:flutter_triple/flutter_triple.dart';

class CalendarioStore extends StreamStore<Falha, ModelBase> {
  final RepositoryAgenda repoAgenda;
  final RepositoryTanqueAgendado repoAt;
  final blocDiaAtual = Bloc(ModelBase(null));

  CalendarioStore(this.repoAgenda, this.repoAt) : super(ModelBase(null));

  getAgendaDoDia(String dia, Map<String, AgendaModel> agendas) async {
    agendas.containsKey(dia)
        ? blocDiaAtual.update((ModelBase(agendas[dia]!.agenda)))
        : blocDiaAtual.execute(() => repoAgenda.getOrCreate(dia));
  }

  getAgendasOcupadasNova(String inicio, String fim) async {
    await Future.delayed(Duration(seconds: 1));
    setLoading(true);
    try {
      List<Agenda> agendas = (await repoAgenda.findByPeriodo(inicio, fim)).model;
      List<String> idsTanquesAgendados = List.empty(growable: true);
      for (var item in agendas) {
        idsTanquesAgendados.addAll(item.tanquesAgendados);
      }
      List<TanqueAgendado> tanquesAgendados = (await repoAt.getFromList(idsTanquesAgendados.toSet().toList())).model;
      Map<String, AgendaModel> agendasModel = Map();
      for (var a in agendas) {
        AgendaModel aModel = AgendaModel(
          a,
          tanquesAgendados.where((e) => a.tanquesAgendados.contains(e.id)).toList(),
        );
        agendasModel[a.data] = aModel;
      }
      update(ModelBase(agendasModel));
    } on Falha catch (e) {
      setError(e);
    } finally {
      setLoading(false);
    }
  }
}
