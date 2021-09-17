import 'package:agendamento_vtr/app/models/json_serializable.dart';
import 'package:flutter/cupertino.dart';

class Compartimento extends ChangeNotifier implements JsonSerializable {
  final int pos;
  int _capacidade = 0;
  int _setas = 0;

  Compartimento(this.pos);

  int get capacidade => this._capacidade;
  int get setas => this._setas;

  set capacidade(value) => {this._capacidade = value, notifyListeners()};
  set setas(value) => {this._setas = value, notifyListeners()};

  @override
  fromJson(Map<String, dynamic> json) {
    Compartimento.fromJson(json);
  }

  Compartimento.fromJson(Map<String, dynamic> json)
      : pos = json['Pos'],
        _capacidade = json['Cap'],
        _setas = json['Setas'];

  @override
  Map<String, dynamic> toJson() => {
        'Pos': pos,
        'Cap': capacidade,
        'Setas': setas,
      };
}
