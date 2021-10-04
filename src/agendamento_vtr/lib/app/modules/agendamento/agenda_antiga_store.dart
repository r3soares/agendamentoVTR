import 'package:agendamento_vtr/app/modules/agendamento/models/agenda_antiga.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'agenda_antiga_repository.dart';

class AgendaAntigaStore extends ChangeNotifier {
  final _repository = Modular.get<AgendaAntigaRepository>();
  AgendaAntiga _agenda = AgendaAntiga(DateTime.now());
  int _statusTanque = 0;
  //0 -> inicial
  //1 -> adicionou
  //2 -> removeu

  AgendaAntiga get agenda => _agenda;
  int get statusTanque => _statusTanque;

  update(DateTime data) {
    //_agenda.removeListener(() {});
    _agenda = _repository.findAgenda(data) ?? _novaAgenda(data);
    // _agenda.addListener(() {
    //   notifyListeners();
    // });
    notifyListeners();
  }

  AgendaAntiga _novaAgenda(DateTime data) {
    print('Nova agenda');
    final agenda = AgendaAntiga(data);
    _repository.addAgenda(agenda);
    return agenda;
  }

  Map<DateTime, AgendaAntiga> getAgendasOcupadas() {
    return _repository.agendasOcupadas();
  }

  void mudaAgenda(DateTime dataAtual, DateTime novaData, String tanque) {
    final agendaA = _repository.findAgenda(dataAtual) ?? _novaAgenda(dataAtual);
    final agendaB = _repository.findAgenda(novaData) ?? _novaAgenda(novaData);
    agendaA.tanques.remove(tanque);
    agendaA.tanquesConfirmados.remove(tanque);
    agendaB.tanques.add(tanque);
    _statusTanque = 1;
    notifyListeners();
  }

  addTanque(String value) {
    _agenda.tanques.add(value);
    _statusTanque = 1;
    notifyListeners();
  }

  removeTanque(String value) {
    _agenda.tanques.remove(value);
    _agenda.tanquesConfirmados.remove(value);
    _statusTanque = 2;
    notifyListeners();
  }

  confirmaTanque(String value) {
    _agenda.tanquesConfirmados.add(value);
    _statusTanque = 1;
    notifyListeners();
  }

  cancelaTanque(String value) {
    _agenda.tanquesConfirmados.remove(value);
    _statusTanque = 2;
    notifyListeners();
  }

  @override
  void dispose() {
    //_agenda.removeListener(() {});
    super.dispose();
  }
}