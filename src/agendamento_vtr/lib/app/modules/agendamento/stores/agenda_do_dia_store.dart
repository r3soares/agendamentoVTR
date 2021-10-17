import 'package:agendamento_vtr/app/domain/constantes.dart';
import 'package:agendamento_vtr/app/domain/erros.dart';
import 'package:agendamento_vtr/app/models/model_base.dart';
import 'package:agendamento_vtr/app/modules/agendamento/controllers/agendaController.dart';
import 'package:agendamento_vtr/app/modules/agendamento/models/agenda.dart';
import 'package:agendamento_vtr/app/modules/agendamento/models/blocAgendaModel.dart';
import 'package:agendamento_vtr/app/modules/agendamento/models/tanque_agendado.dart';
import 'package:agendamento_vtr/app/repositories/repository_agenda.dart';
import 'package:agendamento_vtr/app/repositories/repository_tanque_agendado.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_triple/flutter_triple.dart';

class AgendaDoDiaStore extends StreamStore<Falha, ModelBase> {
  final RepositoryAgenda repoAgenda;
  final RepositoryTanqueAgendado repoAt;
  final AgendaController _controller = Modular.get<AgendaController>();
  //final Bloc blocTanques = Bloc('');
  final BlocAgendaModel blocDiaSelecionado = BlocAgendaModel(Agenda(Constants.formatoData.format(DateTime.now())));
  final List<Disposer> disposers = List.empty(growable: true);

  AgendaDoDiaStore(this.repoAgenda, this.repoAt) : super(ModelBase(null)) {
    //print('AgendaDoDiaStore: controller ${_controller.hashCode}');
    final d1 = _controller.diaSelecionado.observer(
        onState: (aModel) => {
              print('AgendaDoDiaStore: Dia Selecionado ${aModel.data}'),
              blocDiaSelecionado.update(aModel),
            });
    disposers.add(d1);
  }

  @override
  Future destroy() {
    //print('AgendaDoDiaStore: Destruindo');
    blocDiaSelecionado.destroy();
    //blocTanques.destroy();
    disposers.forEach((d) {
      d();
    });
    return super.destroy();
  }

  void salva(List<TanqueAgendado> lista) async {
    execute(() => repoAt.saveMany(lista));
  }

  Agenda get agendaDoDia => _controller.diaSelecionado.lastState.state;
  //List<TanqueAgendado> get agendados => _controller.diaSelecionado.lastState.state.tanquesAgendados;

  // void getTanques(List<String> lista) async {
  //   Map<String, Tanque> tanques = Map();
  //   setLoading(true);
  //   try {
  //     for (var t in lista) {
  //       ModelBase mb = await repoTanque.getTanque(t);
  //       tanques[t] = mb.model;
  //     }
  //     blocTanques.update(tanques);
  //   } on Falha catch (e) {
  //     setError(e);
  //   } finally {
  //     setLoading(false);
  //   }
  // }
}