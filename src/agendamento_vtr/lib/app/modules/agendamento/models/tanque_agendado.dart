import 'package:agendamento_vtr/app/models/empresa.dart';
import 'package:agendamento_vtr/app/models/json_serializable.dart';
import 'package:agendamento_vtr/app/models/tanque.dart';

class TanqueAgendado implements JsonSerializable {
  final String id;
  final Tanque tanque;
  DateTime dataRegistro = DateTime.now();
  String? agenda;
  Empresa? responsavel;
  String? bitremAgenda;
  bool isNovo = false;

  String? agendaAnterior;

  StatusConfirmacao statusConfirmacao = StatusConfirmacao.PreAgendado;
  StatusPagamento statusPagamento = StatusPagamento.Pendente;

  double custoVerificacao = 0;
  int tempoVerificacao = 0;
  String? obs;

  TanqueAgendado({required this.id, required this.tanque, this.agenda});

  @override
  fromJson(Map<String, dynamic> json) => TanqueAgendado.fromJson(json);

  TanqueAgendado.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        tanque = Tanque.fromJson(json['tanque']),
        dataRegistro = DateTime.parse(json['dataRegistro']),
        responsavel = json['responsavel'] == null ? null : Empresa.fromJson(json['responsavel']),
        bitremAgenda = json['bitremAgenda'],
        isNovo = json['isNovo'],
        agendaAnterior = json['agendaAnterior'],
        agenda = json['agenda'],
        statusConfirmacao = StatusConfirmacao.values[json['statusConfirmacao']],
        statusPagamento = StatusPagamento.values[json['statusPagamento']],
        custoVerificacao = json['custoVerificacao'],
        tempoVerificacao = json['tempoVerificacao'],
        obs = json['obs'] == null ? null : json['obs'];

  @override
  Map<String, dynamic> toJson() => {
        'id': id,
        'tanque': tanque.toJson(),
        'dataRegistro': dataRegistro.toIso8601String(),
        'responsavel': responsavel?.toJson(),
        'bitremAgenda': bitremAgenda,
        'isNovo': isNovo,
        'agendaAnterior': agendaAnterior,
        'agenda': agenda,
        'statusConfirmacao': statusConfirmacao.index,
        'statusPagamento': statusPagamento.index,
        'custoVerificacao': custoVerificacao,
        'tempoVerificacao': tempoVerificacao,
        'obs': obs,
      };

  // @override
  // List<Object?> get props => [id.hashCode];
}

enum StatusConfirmacao { PreAgendado, NaoConfirmado, Confirmado, Reagendado, Cancelado }
enum StatusPagamento { Pendente, Confirmado, Atrasado }
