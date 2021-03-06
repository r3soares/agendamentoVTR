import 'package:agendamento_vtr/app/models/json_serializable.dart';
import 'package:agendamento_vtr/app/modules/agendamento/models/tanque_agendado.dart';
import 'package:intl/intl.dart';

// ignore: must_be_immutable
class Agenda implements JsonSerializable {
  //final String id;
  final String data;
  List<TanqueAgendado> tanquesAgendados = List.empty(growable: true);
  StatusAgenda status = StatusAgenda.Disponivel;
  String? obs;

  Agenda(this.data);

  DateTime get d => DateFormat('dd-MM-yyyy').parse(data);

  @override
  fromJson(Map<String, dynamic> json) => Agenda.fromJson(json);

  Agenda.fromJson(Map<String, dynamic> json)
      : //id = json['id'],
        data = json['data'],
        tanquesAgendados = List.from(json['tanquesAgendados']),
        status = StatusAgenda.values[json['status']],
        obs = json['obs'] == null ? null : json['obs'];

  @override
  Map<String, dynamic> toJson() => {
        //'id': id,
        'data': data,
        'tanquesAgendados': tanquesAgendados,
        'status': status.index,
        'obs': obs,
      };

  // @override
  // List<Object?> get props => [data.hashCode];
}

enum StatusAgenda { Disponivel, Cheia, Encerrada, Indisponivel }
