import 'package:agendamento_vtr/app/models/empresa.dart';
import 'package:agendamento_vtr/app/models/json_serializable.dart';
import 'package:agendamento_vtr/app/models/tanque.dart';
import 'package:intl/intl.dart';

class TanqueAgendado implements JsonSerializable {
  final String id;
  final Tanque tanque;
  DateTime dataRegistro = DateTime.now();
  DateTime? dataInicio;
  DateTime? dataFim;
  String? agenda;
  Empresa? responsavel;
  String? bitremAgenda;
  bool isNovo = false;
  List<int> _statusGenerico = [
    0, //StatusConfirmaco
    0, //StatusPagamento
    0, //Cor
  ];
  String? obs;
  int tempoVerificacao = 0;

  StatusConfirmacao get statusConfirmacao =>
      StatusConfirmacao.values[_statusGenerico[0]];
  set statusConfirmacao(StatusConfirmacao value) =>
      _statusGenerico[0] = value.index;
  StatusPagamento get statusPagamento =>
      StatusPagamento.values[_statusGenerico[1]];
  set statusPagamento(StatusPagamento value) =>
      _statusGenerico[1] = value.index;
  int get statusCor => _statusGenerico[2];
  set statusCor(int cor) => _statusGenerico[2] = cor;

  double _custoVerificacao = 0;
  double get custoVerificacao => _custoVerificacao;

  TanqueAgendado({
    required this.id,
    required this.tanque,
    agenda,
  }) {
    _custoVerificacao = tanque.custoTotal;
  }

  @override
  fromJson(Map<String, dynamic> json) => TanqueAgendado.fromJson(json);

  TanqueAgendado.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        tanque = Tanque.fromJson(json['tanque']),
        dataRegistro = DateTime.parse(json['dataRegistro']),
        dataInicio = DateTime.tryParse(json['dataInicio'] ?? ''),
        dataFim = DateTime.tryParse(json['dataFim'] ?? ''),
        responsavel = json['responsavel'] == null
            ? null
            : Empresa.fromJson(json['responsavel']),
        bitremAgenda = json['bitremAgenda'],
        isNovo = json['isNovo'],
        //agendaAnterior = json['agendaAnterior'],
        agenda = json['agenda'],
        // statusConfirmacao = StatusConfirmacao.values[json['statusConfirmacao']],
        // statusPagamento = StatusPagamento.values[json['statusPagamento']],
        _statusGenerico = List.from(json['statusGenerico']),
        _custoVerificacao =
            json['custoVerificacao'], //CustoVerificação é somente get
        tempoVerificacao = json['tempoVerificacao'],
        obs = json['obs'] == null ? null : json['obs'];

  @override
  Map<String, dynamic> toJson() => {
        'id': id,
        'tanque': tanque.toJson(),
        'dataRegistro': dataRegistro.toIso8601String(),
        'dataInicio': dataInicio?.toIso8601String(),
        'dataFim': dataFim?.toIso8601String(),
        'responsavel': responsavel?.toJson(),
        'bitremAgenda': bitremAgenda,
        'isNovo': isNovo,
        //'agendaAnterior': agendaAnterior,
        'agenda': agenda,
        // 'statusConfirmacao': statusConfirmacao.index,
        // 'statusPagamento': statusPagamento.index,
        'statusGenerico': _statusGenerico,
        'custoVerificacao': custoVerificacao,
        'tempoVerificacao': tempoVerificacao,
        'obs': obs,
      };

  // @override
  // List<Object?> get props => [id.hashCode];
}

enum StatusConfirmacao {
  PreAgendado,
  NaoConfirmado,
  Confirmado,
  Reagendado,
  Cancelado
}

enum StatusPagamento { Pendente, Confirmado, Atrasado }
