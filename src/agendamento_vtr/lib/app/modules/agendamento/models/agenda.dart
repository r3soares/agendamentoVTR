import 'package:agendamento_vtr/app/models/json_serializable.dart';

class Agenda implements JsonSerializable {
  final String id;
  final DateTime data;
  List<String> tanquesAgendados = List.empty(growable: true);
  StatusAgenda status = StatusAgenda.Disponivel;
  String? obs;

  Agenda(this.id, this.data);

  @override
  fromJson(Map<String, dynamic> json) => Agenda.fromJson(json);

  Agenda.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        data = DateTime.parse(json['data']),
        tanquesAgendados = List.from(json['tanquesAgendados']),
        status = StatusAgenda.values[json['status']],
        obs = json['obs'] == null ? null : json['obs'];

  @override
  Map<String, dynamic> toJson() => {
        'id': id,
        'data': data.toIso8601String(),
        'tanquesAgendados': tanquesAgendados,
        'status': status.index,
        'obs': obs,
      };

  @override
  int get hashCode => id.hashCode;
}

enum StatusAgenda { Disponivel, Cheia, Encerrada, Indisponivel }
