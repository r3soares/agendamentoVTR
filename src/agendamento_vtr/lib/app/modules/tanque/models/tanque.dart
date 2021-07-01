import 'package:agendamento_vtr/app/modules/tanque/models/arquivo.dart';
import 'package:agendamento_vtr/app/modules/tanque/models/compartimento.dart';
import 'package:agendamento_vtr/app/modules/tanque/models/proprietario.dart';

class Tanque {
  String _placa = '';
  bool _isZero = false;
  Arquivo? _doc;
  Proprietario? _proprietario;
  //String? _bitrem;

  String get placa => _placa;
  bool get isZero => this._isZero;
  Arquivo? get doc => this._doc;
  Proprietario? get proprietario => this._proprietario;
  //String? get bitrem => _bitrem;

  set placa(value) => this._placa = value;
  set isZero(value) => this._isZero = value;
  set doc(value) => this._doc = value;
  set proprietario(value) => this._proprietario = value;
  //set bitrem(value) => this._bitrem = value;

  List<Compartimento> compartimentos = [Compartimento('C1')];
}
