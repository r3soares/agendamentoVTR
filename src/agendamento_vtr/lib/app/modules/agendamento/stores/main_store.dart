import 'package:agendamento_vtr/app/modules/agendamento/controllers/agendaController.dart';
import 'package:agendamento_vtr/app/modules/agendamento/models/agenda.dart';
import 'package:agendamento_vtr/app/modules/agendamento/models/tanque_agendado.dart';
import 'package:agendamento_vtr/app/modules/agendamento/stores/store_data.dart';
import 'package:agendamento_vtr/app/repositories/repository_tanque_agendado.dart';
import 'package:flutter_modular/flutter_modular.dart';

class MainStore {
  final AgendaController _controller = Modular.get<AgendaController>();

  StoreData<List<TanqueAgendado>> get storePendentes => _controller.storePendentes;
  StoreData<Agenda> get diaAtualizado => _controller.diaAtualizado;
  //StoreData<Agenda> get diaSelecionado => _controller.diaSelecionado;

  final RepositoryTanqueAgendado _repoTa = Modular.get<RepositoryTanqueAgendado>();

  MainStore();

  Future destroy() async {
    await storePendentes.destroy();
    return _controller.destroy();
  }

  void getPendentes() async {
    storePendentes.execute(() => _repoTa.findPendentes());
  }
}
