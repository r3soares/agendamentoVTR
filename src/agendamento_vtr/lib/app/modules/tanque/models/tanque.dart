import 'package:agendamento_vtr/app/modules/tanque/models/arquivo.dart';
import 'package:agendamento_vtr/app/modules/tanque/models/compartimento.dart';

class Tanque {
  String _placa = '';
  bool _isZero = false;
  Arquivo? _doc;
  DateTime _dataRegistro = DateTime.now();
  //CNPJ_CPF
  String? _proprietario;
  DateTime? _agenda;
  //String? _bitrem;

  String get placa => _placa;
  bool get isZero => this._isZero;
  Arquivo? get doc => this._doc;
  DateTime get dataRegistro => this._dataRegistro;
  String? get proprietario => this._proprietario;
  DateTime? get agenda => this._agenda;
  //String? get bitrem => _bitrem;

  set placa(value) => this._placa = value;
  set isZero(value) => this._isZero = value;
  set doc(value) => this._doc = value;
  set dataRegistro(DateTime value) => this._dataRegistro = value;
  set proprietario(String? value) => this._proprietario = value;
  set agenda(DateTime? value) => this._agenda = value;
  //set bitrem(value) => this._bitrem = value;

  List<Compartimento> compartimentos = [Compartimento('C1')];
}
