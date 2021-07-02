import 'package:agendamento_vtr/app/modules/tanque/models/tanque.dart';
import 'package:flutter/cupertino.dart';

class Agenda extends ChangeNotifier {
  final DateTime _data;
  List<String> _tanques = List.empty(growable: true);

  Agenda(this._data);

  DateTime get data => this._data;

  List<String> get tanques => this._tanques;

  addTanque(String value) {
    _tanques.add(value);
    notifyListeners();
  }

  removeTanque(Tanque value) {
    _tanques.remove(value);
    notifyListeners();
  }
}
