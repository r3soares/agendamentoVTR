import 'package:agendamento_vtr/app/domain/constantes.dart';
import 'package:agendamento_vtr/app/domain/erros.dart';
import 'package:agendamento_vtr/app/modules/agendamento/models/agenda.dart';
import 'package:agendamento_vtr/app/modules/agendamento/models/agenda_model.dart';
import 'package:agendamento_vtr/app/modules/agendamento/models/blocAgendaModel.dart';
import 'package:flutter_triple/flutter_triple.dart';

class AgendaController extends StreamStore<Falha, AgendaModel> {
  final BlocAgendaModel diaSelecionado =
      BlocAgendaModel(AgendaModel(Agenda(Constants.formatoData.format(DateTime.now())), List.empty()));
  final BlocAgendaModel diaAtualizado =
      BlocAgendaModel(AgendaModel(Agenda(Constants.formatoData.format(DateTime.now())), List.empty()));

  AgendaController(AgendaModel initialState) : super(initialState) {
    //print('AgendaController: hashcode ${this.hashCode}');
  }

  @override
  Future destroy() {
    //print('AgendaController: Destruindo');
    diaSelecionado.destroy();
    diaAtualizado.destroy();
    return super.destroy();
  }

  void notificaDiaSelecionado(AgendaModel dia) {
    print('AgendaController: Dia Selecionado ${dia.agenda.data}');
    diaSelecionado.update(dia);
  }

  void notificaDiaAtualizado(AgendaModel dia) {
    print('AgendaController: Dia Atualizado ${dia.agenda.data}');
    diaAtualizado.update(dia);
  }
}
