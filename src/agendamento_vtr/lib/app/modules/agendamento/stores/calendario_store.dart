import 'package:agendamento_vtr/app/domain/constantes.dart';
import 'package:agendamento_vtr/app/domain/erros.dart';
import 'package:agendamento_vtr/app/models/bloc.dart';
import 'package:agendamento_vtr/app/models/model_base.dart';
import 'package:agendamento_vtr/app/modules/agendamento/controllers/agendaController.dart';
import 'package:agendamento_vtr/app/modules/agendamento/models/agenda.dart';
import 'package:agendamento_vtr/app/modules/agendamento/models/agenda_model.dart';
import 'package:agendamento_vtr/app/modules/agendamento/models/blocAgendaModel.dart';
import 'package:agendamento_vtr/app/modules/agendamento/models/tanque_agendado.dart';
import 'package:agendamento_vtr/app/repositories/repository_agenda.dart';
import 'package:agendamento_vtr/app/repositories/repository_tanque_agendado.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_triple/flutter_triple.dart';

class CalendarioStore extends StreamStore<Falha, ModelBase> {
  final RepositoryAgenda repoAgenda;
  final RepositoryTanqueAgendado repoAt;
  final AgendaController _controller = Modular.get<AgendaController>();
  final blocDiaSelecionado =
      BlocAgendaModel(AgendaModel(Agenda(Constants.formatoData.format(DateTime.now())), List.empty()));
  final blocDiaAtualizado =
      BlocAgendaModel(AgendaModel(Agenda(Constants.formatoData.format(DateTime.now())), List.empty()));

  CalendarioStore(this.repoAgenda, this.repoAt) : super(ModelBase(null)) {
    blocDiaSelecionado.observer(onState: _controller.notificaDiaSelecionado);
    _controller.diaAtualizado.observer(onState: (aModel) => blocDiaAtualizado.update(aModel));
  }

  getAgendaDoDia(String dia, Map<String, AgendaModel> agendas) async {
    try {
      agendas.containsKey(dia) ? blocDiaSelecionado.update(agendas[dia]!) : _getNovaAgenda(dia);
    } on Falha catch (e) {
      setError(e);
    }
  }

  _getNovaAgenda(String dia) async {
    Agenda a = (await repoAgenda.getOrCreate(dia)).model;
    List<TanqueAgendado> tanquesAgendados = (await repoAt.getFromList(a.tanquesAgendados)).model;
    blocDiaSelecionado.update(AgendaModel(a, tanquesAgendados));
  }

  getAgendasOcupadas(String inicio, String fim) async {
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
