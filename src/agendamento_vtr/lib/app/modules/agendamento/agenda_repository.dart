import 'package:agendamento_vtr/app/modules/agendamento/models/agenda.dart';

class AgendaRepository {
  List<Agenda?> _agendas = List.empty(growable: true);

  addAgenda(Agenda value) {
    _agendas.add(value);
  }

  removeAgenda(Agenda value) {
    _agendas.remove(value);
  }

  Agenda? findAgenda(DateTime data) {
    return _agendas.firstWhere((a) => a?.data == data, orElse: () => null);
  }
}
