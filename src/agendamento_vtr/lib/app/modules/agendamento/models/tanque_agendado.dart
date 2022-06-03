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
  String? _agenda;
  Empresa? responsavel;
  String? bitremAgenda;
  bool isNovo = false;

  StatusConfirmacao statusConfirmacao = StatusConfirmacao.PreAgendado;
  StatusPagamento statusPagamento = StatusPagamento.Pendente;

  double _custoVerificacao = 0;
  double get custoVerificacao => _custoVerificacao;
  int tempoVerificacao = 0;
  String? obs;

  TanqueAgendado({
    required this.id,
    required this.tanque,
    agenda,
  }) {
    _custoVerificacao = tanque.custoTotal;
  }

  String? get agenda => _agenda;

  set agenda(String? data) => {
        _agenda = data,
        dataInicio = data == null
            ? null
            : DateFormat('dd-MM-yyyy').parse(data).add(Duration(hours: 8)),
        dataFim = data == null
            ? null
            : DateFormat('dd-MM-yyyy').parse(data).add(Duration(hours: 11)),
      };

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
        _agenda = json['agenda'],
        statusConfirmacao = StatusConfirmacao.values[json['statusConfirmacao']],
        statusPagamento = StatusPagamento.values[json['statusPagamento']],
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
        'agenda': _agenda,
        'statusConfirmacao': statusConfirmacao.index,
        'statusPagamento': statusPagamento.index,
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
