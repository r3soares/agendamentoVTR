import 'package:agendamento_vtr/app/modules/agendamento/models/agenda_antiga.dart';

class AgendaAntigaRepository {
  List<AgendaAntiga?> _agendas = List.empty(growable: true);

  addAgenda(AgendaAntiga value) {
    _agendas.add(value);
  }

  removeAgenda(AgendaAntiga value) {
    _agendas.remove(value);
  }

  Map<DateTime, AgendaAntiga> agendasOcupadas() {
    final agendasOcupadas = _agendas.where((a) => a!.tanques.isNotEmpty).toList();
    return Map<DateTime, AgendaAntiga>.fromIterable(agendasOcupadas, key: (k) => k.db, value: (v) => v);
  }

  AgendaAntiga? findAgenda(DateTime data) {
    return _agendas.firstWhere((a) => a != null && _comparaData(a.data, data), orElse: () => null);
  }

  bool _comparaData(DateTime a, DateTime b) {
    if (a.day != b.day) return false;
    if (a.month != b.month) return false;
    if (a.year != b.year) return false;

    return true;
  }
}
