import 'package:agendamento_vtr/app/domain/constantes.dart';
import 'package:agendamento_vtr/app/domain/erros.dart';
import 'package:agendamento_vtr/app/domain/log.dart';
import 'package:agendamento_vtr/app/modules/agendamento/models/agenda.dart';
import 'package:agendamento_vtr/app/modules/agendamento/models/blocAgendaModel.dart';
import 'package:flutter_triple/flutter_triple.dart';

class AgendaController extends StreamStore<Falha, Agenda> {
  final BlocAgendaModel diaSelecionado = BlocAgendaModel(Agenda(Constants.formatoData.format(DateTime.now())));
  final BlocAgendaModel diaAtualizado = BlocAgendaModel(Agenda(Constants.formatoData.format(DateTime.now())));

  AgendaController(initialState) : super(initialState) {
    print('AgendaController: hashcode ${this.hashCode}');
  }

  @override
  Future destroy() {
    //print('AgendaController: Destruindo');
    diaSelecionado.destroy();
    diaAtualizado.destroy();
    return super.destroy();
  }

  void notificaDiaSelecionado(Agenda dia) {
    //print('AgendaController: Dia Selecionado ${dia.data}');
    diaSelecionado.update(dia);
  }

  void notificaDiaAtualizado(Agenda dia) {
    Log.message(this, 'Dia Atualizado ${dia.data}');
    diaAtualizado.update(dia);
  }
}
