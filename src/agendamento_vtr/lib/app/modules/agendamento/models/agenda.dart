import 'package:agendamento_vtr/app/modules/tanque/models/tanque.dart';

class Agenda {
  final DateTime _data;
  List<Tanque> _tanques = List.empty(growable: true);

  Agenda(this._data);

  get data => this._data;

  get tanques => this._tanques;

  addTanque(Tanque value) {
    _tanques.add(value);
  }

  removeTanque(Tanque value) {
    _tanques.remove(value);
  }
}
