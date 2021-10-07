import 'package:agendamento_vtr/app/models/json_serializable.dart';

class TanqueAgendado implements JsonSerializable {
  final String id;
  final String tanque;
  final String agenda;
  String responsavel = '';
  String? bitremAgenda;

  String? agendaAnterior;

  StatusConfirmacao statusConfirmacao = StatusConfirmacao.NaoConfirmado;
  StatusPagamento statusPagamento = StatusPagamento.Pendente;

  double custoVerificacao = 0;
  int tempoVerificacao = 0;
  String? obs;

  TanqueAgendado({required this.id, required this.tanque, required this.agenda});

  @override
  fromJson(Map<String, dynamic> json) => TanqueAgendado.fromJson(json);

  TanqueAgendado.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        tanque = json['tanque'],
        responsavel = json['responsavel'],
        bitremAgenda = json['bitremAgenda'],
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
        'tanque': tanque,
        'responsavel': responsavel,
        'bitremAgenda': bitremAgenda,
        'agendaAnterior': agendaAnterior,
        'agenda': agenda,
        'statusConfirmacao': statusConfirmacao.index,
        'statusPagamento': statusPagamento.index,
        'custoVerificacao': custoVerificacao,
        'tempoVerificacao': tempoVerificacao,
        'obs': obs,
      };
}

enum StatusConfirmacao { NaoConfirmado, Confirmado, Cancelado }
enum StatusPagamento { Pendente, Confirmado, Atrasado }
