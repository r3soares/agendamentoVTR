import 'package:agendamento_vtr/app/modules/agendamento/models/agenda.dart';
import 'package:agendamento_vtr/app/modules/agendamento/models/tanque_agendado.dart';

class AgendaModel {
  final Agenda agenda;
  final List<TanqueAgendado> agendados;

  AgendaModel(this.agenda, this.agendados);
}
