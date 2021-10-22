import 'package:agendamento_vtr/app/domain/constantes.dart';
import 'package:agendamento_vtr/app/domain/erros.dart';
import 'package:agendamento_vtr/app/models/model_base.dart';
import 'package:agendamento_vtr/app/modules/agendamento/controllers/agendaController.dart';
import 'package:agendamento_vtr/app/modules/agendamento/models/agenda.dart';
import 'package:agendamento_vtr/app/modules/agendamento/models/blocAgendaModel.dart';
import 'package:agendamento_vtr/app/modules/agendamento/stores/store_data.dart';
import 'package:agendamento_vtr/app/repositories/repository_agenda.dart';
import 'package:agendamento_vtr/app/repositories/repository_tanque_agendado.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_triple/flutter_triple.dart';

class CalendarioStore extends StreamStore<Falha, ModelBase> {
  final RepositoryAgenda repoAgenda;
  final RepositoryTanqueAgendado repoAt;
  final AgendaController _controller = Modular.get<AgendaController>();

  final blocDiaSelecionado = BlocAgendaModel(Agenda(Constants.formatoData.format(DateTime.now())));
  StoreData<Agenda> get storeDiaAtualizado => _controller.storeDiaAtualizado;
  final List<Disposer> disposers = List.empty(growable: true);

  CalendarioStore(this.repoAgenda, this.repoAt) : super(ModelBase(null)) {
    //print('AgendaDodiaStore: controller ${_controller.hashCode}');
    final d1 = blocDiaSelecionado.observer(onState: _controller.notificaDiaAtualizado);
    disposers.add(d1);
  }

  @override
  Future destroy() {
    //print('CalendarioStore: Destruindo');
    blocDiaSelecionado.destroy();
    disposers.forEach((d) {
      d();
    });
    Modular.dispose<AgendaController>();
    return super.destroy();
  }

  getAgendaDoDia(String dia, Map<String, Agenda> agendas) async {
    //print('CalendarioStore: Dia Selecionado');
    try {
      agendas.containsKey(dia) ? blocDiaSelecionado.update(agendas[dia]!, force: true) : _getNovaAgenda(dia);
    } on Falha catch (e) {
      setError(e);
    }
  }

  _getNovaAgenda(String dia) async {
    Agenda a = (await repoAgenda.getOrCreate(dia)).model;
    blocDiaSelecionado.update(a, force: true);
  }

  getAgendasOcupadas(String inicio, String fim) async {
    await Future.delayed(Duration(seconds: 1));
    setLoading(true);
    try {
      List<Agenda> agendas = (await repoAgenda.findByPeriodo(inicio, fim)).model;
      update(ModelBase({for (var item in agendas) item.data: item}), force: true);
    } on Falha catch (e) {
      setError(e);
    } finally {
      setLoading(false);
    }
  }
}
