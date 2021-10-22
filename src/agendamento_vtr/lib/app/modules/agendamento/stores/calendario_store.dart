import 'package:agendamento_vtr/app/domain/constantes.dart';
import 'package:agendamento_vtr/app/domain/erros.dart';
import 'package:agendamento_vtr/app/modules/agendamento/controllers/agendaController.dart';
import 'package:agendamento_vtr/app/modules/agendamento/models/agenda.dart';
import 'package:agendamento_vtr/app/modules/agendamento/models/blocAgendaModel.dart';
import 'package:agendamento_vtr/app/modules/agendamento/stores/store_data.dart';
import 'package:agendamento_vtr/app/repositories/repository_agenda.dart';
import 'package:agendamento_vtr/app/repositories/repository_tanque_agendado.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_triple/flutter_triple.dart';

class CalendarioStore {
  final RepositoryAgenda repoAgenda;
  final RepositoryTanqueAgendado repoAt;
  final AgendaController _controller = Modular.get<AgendaController>();

  final blocDiaSelecionado = BlocAgendaModel(Agenda(Constants.formatoData.format(DateTime.now())));
  StoreData<Agenda> get storeDiaAtualizado => _controller.storeDiaAtualizado;
  StoreData<Map<String, Agenda>> get storeAgendas => _controller.storeAgendas;
  final List<Disposer> disposers = List.empty(growable: true);

  CalendarioStore(this.repoAgenda, this.repoAt) {
    //print('AgendaDodiaStore: controller ${_controller.hashCode}');
    final d1 = blocDiaSelecionado.observer(onState: _controller.notificaDiaAtualizado);
    disposers.add(d1);
  }

  Future destroy() async {
    //print('CalendarioStore: Destruindo');
    await blocDiaSelecionado.destroy();
    disposers.forEach((d) {
      d();
    });
  }

  getAgendaDoDia(String dia, Map<String, Agenda> agendas) async {
    //print('CalendarioStore: Dia Selecionado');
    try {
      agendas.containsKey(dia) ? blocDiaSelecionado.update(agendas[dia]!, force: true) : _getNovaAgenda(dia);
    } on Falha catch (e) {
      blocDiaSelecionado.setError(e);
    }
  }

  _getNovaAgenda(String dia) async {
    Agenda a = (await repoAgenda.getOrCreate(dia)).model;
    blocDiaSelecionado.update(a, force: true);
  }
}
