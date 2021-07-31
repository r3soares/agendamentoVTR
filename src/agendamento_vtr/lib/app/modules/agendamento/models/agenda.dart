class Agenda {
  final DateTime _data;
  List<String> _tanques = List.empty(growable: true);
  List<String> _tanquesConfirmados = List.empty(growable: true);

  Agenda(this._data);

  DateTime get data => this._data;

  List<String> get tanques => this._tanques;
  List<String> get tanquesConfirmados => this._tanquesConfirmados;
}
