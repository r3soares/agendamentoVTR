import 'package:agendamento_vtr/app/domain/constantes.dart';
import 'package:agendamento_vtr/app/domain/erros.dart';
import 'package:agendamento_vtr/app/models/bloc.dart';
import 'package:agendamento_vtr/app/models/model_base.dart';
import 'package:agendamento_vtr/app/models/tanque.dart';
import 'package:agendamento_vtr/app/modules/agendamento/controllers/agendaController.dart';
import 'package:agendamento_vtr/app/modules/agendamento/models/agenda.dart';
import 'package:agendamento_vtr/app/modules/agendamento/models/agenda_model.dart';
import 'package:agendamento_vtr/app/modules/agendamento/models/blocAgendaModel.dart';
import 'package:agendamento_vtr/app/modules/agendamento/models/tanque_agendado.dart';
import 'package:agendamento_vtr/app/repositories/repository_agenda.dart';
import 'package:agendamento_vtr/app/repositories/repository_tanque.dart';
import 'package:agendamento_vtr/app/repositories/repository_tanque_agendado.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_triple/flutter_triple.dart';

class AgendaDoDiaStore extends StreamStore<Falha, ModelBase> {
  final RepositoryAgenda repoAgenda;
  final RepositoryTanqueAgendado repoAt;
  final RepositoryTanque repoTanque;
  final AgendaController _controller = Modular.get<AgendaController>();
  final Bloc blocTanques = Bloc('');
  final BlocAgendaModel blocDiaSelecionado =
      BlocAgendaModel(AgendaModel(Agenda(Constants.formatoData.format(DateTime.now())), List.empty()));

  AgendaDoDiaStore(this.repoAgenda, this.repoAt, this.repoTanque) : super(ModelBase(null)) {
    _controller.diaSelecionado.observer(onState: (aModel) => blocDiaSelecionado.update(aModel));
  }

  void salva(List<TanqueAgendado> lista) async {
    execute(() => repoAt.saveMany(lista));
  }

  Agenda get agendaDoDia => _controller.diaSelecionado.state.agenda;
  List<TanqueAgendado> get agendados => _controller.diaSelecionado.state.agendados;

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
