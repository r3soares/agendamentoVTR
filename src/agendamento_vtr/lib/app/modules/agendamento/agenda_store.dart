import 'package:agendamento_vtr/app/modules/agendamento/models/agenda.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'agenda_repository.dart';

class AgendaStore extends ChangeNotifier {
  final _repository = Modular.get<AgendaRepository>();
  Agenda _agenda = Agenda(DateTime.now());
  int _statusTanque = 0;
  //0 -> inicial
  //1 -> adicionou
  //2 -> removeu

  Agenda get agenda => _agenda;
  int get statusTanque => _statusTanque;

  update(DateTime data) {
    //_agenda.removeListener(() {});
    _agenda = _repository.findAgenda(data) ?? _novaAgenda(data);
    // _agenda.addListener(() {
    //   notifyListeners();
    // });
    notifyListeners();
  }

  Agenda _novaAgenda(DateTime data) {
    print('Nova agenda');
    final agenda = Agenda(data);
    _repository.addAgenda(agenda);
    return agenda;
  }

  addTanque(String value) {
    _agenda.tanques.add(value);
    _statusTanque = 1;
    notifyListeners();
  }

  removeTanque(String value) {
    _agenda.tanques.remove(value);
    _statusTanque = 2;
    notifyListeners();
  }

  @override
  void dispose() {
    //_agenda.removeListener(() {});
    super.dispose();
  }
}
