import 'package:agendamento_vtr/app/domain/constantes.dart';
import 'package:agendamento_vtr/app/domain/extensions.dart';
import 'package:agendamento_vtr/app/domain/log.dart';
import 'package:agendamento_vtr/app/models/tanque.dart';
import 'package:agendamento_vtr/app/modules/agendamento/models/agenda.dart';
import 'package:agendamento_vtr/app/modules/agendamento/models/tanque_agendado.dart';
import 'package:agendamento_vtr/app/modules/agendamento/stores/store_data.dart';

class AgendaController {
  final StoreData<List<TanqueAgendado>> storePendentes =
      StoreData(List.empty());
  final StoreData<List<TanqueAgendado>> storeAgendados =
      StoreData(List.empty());
  final StoreData<Map<String, Agenda>> storeAgendas =
      StoreData<Map<String, Agenda>>(Map());
  final StoreData<Agenda> storeDiaAtualizado =
      StoreData<Agenda>(Agenda(Constants.formatoData.format(DateTime.now())));
  final StoreData<TanqueAgendado> storeTanqueAgendadoAtualizado = StoreData<
          TanqueAgendado>(
      TanqueAgendado(id: DateTime.now().diaMesAnoToString(), tanque: Tanque()));

  Future destroy() async {
    //print('AgendaController: Destruindo');
    //await diaSelecionado.destroy();
    await storeDiaAtualizado.destroy();
    await storePendentes.destroy();
    await storeAgendados.destroy();
    await storeAgendas.destroy();
  }

  void notificaPendentes(List<TanqueAgendado> pendentes) {
    Log.message(this, 'Lista de Pendentes Atualizada');
    storePendentes.update(pendentes, force: true);
  }

  void notificaAgendados(List<TanqueAgendado> agendados) {
    Log.message(this, 'Lista de Agendados Atualizada');
    storeAgendados.update(agendados, force: true);
  }

  void notificaDiaAtualizado(Agenda dia) {
    Log.message(this, 'Dia Atualizado ${dia.data}');
    storeDiaAtualizado.update(dia, force: true);
  }

  void notificaTanqueAgendadoAtualizado(TanqueAgendado tAgendado) {
    Log.message(this, 'TanqueAgendado Atualizado ${tAgendado.tanque.placa}');
    storeTanqueAgendadoAtualizado.update(tAgendado, force: true);
  }

  void notificaAgendas(Map<String, Agenda> agendas) {
    Log.message(this, 'Agendas atualizadas');
    storeAgendas.update(agendas, force: true);
  }
}
