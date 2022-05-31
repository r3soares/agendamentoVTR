import 'package:agendamento_vtr/app/domain/constantes.dart';
import 'package:agendamento_vtr/app/domain/erros.dart';
import 'package:agendamento_vtr/app/modules/agendamento/controllers/agendaController.dart';
import 'package:agendamento_vtr/app/modules/agendamento/models/agenda.dart';
import 'package:agendamento_vtr/app/modules/agendamento/models/tanque_agendado.dart';
import 'package:agendamento_vtr/app/modules/agendamento/stores/store_data.dart';
import 'package:agendamento_vtr/app/repositories/repository_agenda.dart';
import 'package:agendamento_vtr/app/repositories/repository_tanque_agendado.dart';
import 'package:flutter_modular/flutter_modular.dart';

class MainStore {
  final AgendaController _controller = Modular.get<AgendaController>();

  StoreData<List<TanqueAgendado>> get storePendentes =>
      _controller.storePendentes;
  StoreData<List<TanqueAgendado>> get storeAgendados =>
      _controller.storeAgendados;
  StoreData<Agenda> get storeDiaAtualizado => _controller.storeDiaAtualizado;
  StoreData<Map<String, Agenda>> get storeAgendas => _controller.storeAgendas;
  //StoreData<Agenda> get diaSelecionado => _controller.diaSelecionado;

  final RepositoryTanqueAgendado _repoTa =
      Modular.get<RepositoryTanqueAgendado>();
  final RepositoryAgenda _repoAgenda = Modular.get<RepositoryAgenda>();

  void getAgendasOcupadas() async {
    await Future.delayed(Duration(seconds: 1));
    storeAgendas.setLoading(true);
    try {
      List<Agenda> agendas = (await _repoAgenda.findByPeriodo(
              Constants.formatoData.format(DateTime.now()),
              Constants.formatoData
                  .format((DateTime.now().add(Duration(days: 365))))))
          .model;
      Map<String, Agenda> mapAgendas = {
        for (var item in agendas) item.data: item
      };
      storeAgendas.update(mapAgendas, force: true);
    } on Falha catch (e) {
      storeAgendas.setError(e);
    } finally {
      storeAgendas.setLoading(false);
    }
  }

  void getPendentes() async {
    storePendentes.execute(() => _repoTa.findPendentes());
  }

  void getAgendados() async {
    storeAgendados.execute(() => _repoTa.findAgendados());
  }
}
