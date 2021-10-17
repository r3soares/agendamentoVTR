import 'package:agendamento_vtr/app/domain/erros.dart';
import 'package:agendamento_vtr/app/modules/agendamento/models/agenda.dart';
import 'package:flutter_triple/flutter_triple.dart';

class BlocAgendaModel extends StreamStore<Falha, Agenda> {
  BlocAgendaModel(initialState) : super(initialState);
}
