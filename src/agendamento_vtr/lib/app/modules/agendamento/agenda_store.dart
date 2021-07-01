import 'package:agendamento_vtr/app/modules/agendamento/models/agenda.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_triple/flutter_triple.dart';

import 'agenda_repository.dart';

class AgendaStore extends NotifierStore<Exception, DateTime> {
  final _repository = Modular.get<AgendaRepository>();

  AgendaStore() : super(DateTime.now());

  Agenda get agendaDoDia => _repository.findAgenda(state) ?? _novaAgenda();

  Agenda _novaAgenda() {
    final agenda = Agenda(state);
    _repository.addAgenda(agenda);
    return agenda;
  }
}
