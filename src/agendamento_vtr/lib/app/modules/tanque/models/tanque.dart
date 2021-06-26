import 'package:agendamento_vtr/app/modules/tanque/models/arquivo.dart';
import 'package:agendamento_vtr/app/modules/tanque/models/compartimento.dart';

class Tanque {
  String _placa = '';
  bool _isZero = false;
  Arquivo? _doc;

  String get placa => _placa;
  bool get isZero => this._isZero;
  Arquivo? get doc => this._doc;

  set placa(value) => this._placa = value;
  set isZero(value) => this._isZero = value;
  set doc(value) => this._doc = value;

  List<Compartimento> compartimentos = [Compartimento('C1')];
}
