import 'package:agendamento_vtr/app/models/custo_tanque.dart';
import 'package:agendamento_vtr/app/modules/tanque/models/arquivo.dart';
import 'package:agendamento_vtr/app/models/compartimento.dart';

class Tanque {
  String _placa = '';
  int _numInmetro = 0;

  String? _proprietario;
  bool _isZero = false;

  DateTime _dataRegistro = DateTime.now();
  DateTime _dataUltimaAlteracao = DateTime.now();
  //CNPJ_CPF da Empresa

  String? _idTanqueAgendado;

  StatusTanque _statusTanque = StatusTanque.Ativo;

  List<Compartimento> compartimentos = [Compartimento('C1')];

  Arquivo? _doc; //Tem que remover
  DateTime? _agenda; //Tem que remover
  String? _responsavelAgendamento; //Tem que remover
  CustoTanque? _ultimoCusto;

  final List<Arquivo> docs = List.empty(growable: true);

  String get placa => _placa;
  int get numInmetro => _numInmetro;
  bool get isZero => this._isZero;
  Arquivo? get doc => this._doc;
  DateTime get dataRegistro => this._dataRegistro;
  DateTime get dataUltimaAlteracao => this._dataUltimaAlteracao;
  String? get proprietario => this._proprietario;
  String? get responsavelAgendamento => this._responsavelAgendamento;
  String? get tanqueAgendado => this._idTanqueAgendado;
  DateTime? get agenda => this._agenda;
  int get capacidadeTotal => compartimentos.fold(
      0, (previousValue, element) => previousValue + element.capacidade);
  StatusTanque get status => _statusTanque;
  CustoTanque? get ultimoCusto => _ultimoCusto;
  //String? get bitrem => _bitrem;

  set placa(value) => this._placa = value;
  set numInmetro(value) => this._numInmetro = value;
  set isZero(value) => this._isZero = value;
  set doc(value) => this._doc = value;

  //Tem que remover (usado para testes)
  set dataRegistro(DateTime value) => this._dataRegistro = value;

  set dataUltimaAlteracao(DateTime value) => this._dataUltimaAlteracao = value;
  set proprietario(String? value) => this._proprietario = value;
  set responsavelAgendamento(String? value) =>
      this._responsavelAgendamento = value;
  set tanqueAgendado(String? value) => this._idTanqueAgendado = value;
  set agenda(DateTime? value) => this._agenda = value;
  set status(StatusTanque value) => this._statusTanque;
  set ultimoCusto(CustoTanque? value) => this._ultimoCusto = value;
  //set bitrem(value) => this._bitrem = value;

}

enum StatusTanque {
  Ativo,
  Inativo,
}
