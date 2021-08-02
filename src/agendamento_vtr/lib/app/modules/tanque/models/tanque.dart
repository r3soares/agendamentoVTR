import 'package:agendamento_vtr/app/modules/tanque/models/arquivo.dart';
import 'package:agendamento_vtr/app/modules/tanque/models/compartimento.dart';

class Tanque {
  String _placa = '';
  bool _isZero = false;
  Arquivo? _doc;
  DateTime _dataRegistro = DateTime.now();
  //CNPJ_CPF da Empresa
  String? _proprietario;
  String? _responsavelAgendamento;
  DateTime? _agenda;
  //String? _bitrem;

  List<Compartimento> compartimentos = [Compartimento('C1')];

  String get placa => _placa;
  bool get isZero => this._isZero;
  Arquivo? get doc => this._doc;
  DateTime get dataRegistro => this._dataRegistro;
  String? get proprietario => this._proprietario;
  String? get responsavelAgendamento => this._responsavelAgendamento;
  DateTime? get agenda => this._agenda;
  int get capacidadeTotal => compartimentos.fold(
      0, (previousValue, element) => previousValue + element.capacidade);
  //String? get bitrem => _bitrem;

  set placa(value) => this._placa = value;
  set isZero(value) => this._isZero = value;
  set doc(value) => this._doc = value;
  set dataRegistro(DateTime value) => this._dataRegistro = value;
  set proprietario(String? value) => this._proprietario = value;
  set responsavelAgendamento(String? value) =>
      this._responsavelAgendamento = value;
  set agenda(DateTime? value) => this._agenda = value;
  //set bitrem(value) => this._bitrem = value;

}
