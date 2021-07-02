import 'package:agendamento_vtr/app/modules/agendamento/models/agenda.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'agenda_repository.dart';

class AgendaStore extends ChangeNotifier {
  final _repository = Modular.get<AgendaRepository>();
  Agenda _agenda = Agenda(DateTime.now());

  Agenda get agenda => _agenda;

  update(DateTime data) {
    _agenda.removeListener(() {
      notifyListeners();
    });
    _agenda = _repository.findAgenda(data) ?? _novaAgenda(data);
    _agenda.addListener(() {
      notifyListeners();
    });
    notifyListeners();
  }

  Agenda _novaAgenda(DateTime data) {
    print('Nova agenda');
    final agenda = Agenda(data);
    _repository.addAgenda(agenda);
    return agenda;
  }
}
