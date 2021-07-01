import 'package:agendamento_vtr/app/modules/tanque/models/tanque.dart';

class Agenda {
  final DateTime _data;
  List<String> _tanques = List.empty(growable: true);

  Agenda(this._data);

  get data => this._data;

  get tanques => this._tanques;

  addTanque(String value) {
    _tanques.add(value);
  }

  removeTanque(Tanque value) {
    _tanques.remove(value);
  }
}
