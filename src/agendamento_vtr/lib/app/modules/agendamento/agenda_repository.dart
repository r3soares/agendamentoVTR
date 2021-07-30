import 'package:agendamento_vtr/app/modules/agendamento/models/agenda.dart';

class AgendaRepository {
  List<Agenda?> _agendas = List.empty(growable: true);

  addAgenda(Agenda value) {
    _agendas.add(value);
  }

  removeAgenda(Agenda value) {
    _agendas.remove(value);
  }

  Map<DateTime, Agenda> agendasOcupadas() {
    final agendasOcupadas =
        _agendas.where((a) => a!.tanques.isNotEmpty).toList();
    return Map<DateTime, Agenda>.fromIterable(agendasOcupadas,
        key: (k) => k.data, value: (v) => v);
  }

  Agenda? findAgenda(DateTime data) {
    return _agendas.firstWhere((a) => a != null && _comparaData(a.data, data),
        orElse: () => null);
  }

  bool _comparaData(DateTime a, DateTime b) {
    if (a.day != b.day) return false;
    if (a.month != b.month) return false;
    if (a.year != b.year) return false;

    return true;
  }
}
