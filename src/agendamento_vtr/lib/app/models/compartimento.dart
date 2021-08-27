import 'package:flutter/cupertino.dart';

class Compartimento extends ChangeNotifier {
  final String _id;
  int _capacidade = 0;
  int _setas = 0;

  Compartimento(this._id);

  String get id => this._id;
  int get capacidade => this._capacidade;
  int get setas => this._setas;

  set capacidade(value) => {this._capacidade = value, notifyListeners()};
  set setas(value) => this._setas = value;
}
