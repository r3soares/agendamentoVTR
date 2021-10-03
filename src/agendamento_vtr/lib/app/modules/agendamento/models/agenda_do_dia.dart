import 'package:agendamento_vtr/app/models/json_serializable.dart';

class AgendaDoDia implements JsonSerializable {
  final String id;
  DateTime data = DateTime.now();
  List<String> tanquesAgendados = List.empty(growable: true);
  StatusAgenda status = StatusAgenda.Disponivel;
  String? obs;

  @override
  fromJson(Map<String, dynamic> json) => AgendaDoDia.fromJson(json);

  AgendaDoDia.fromJson(Map<String, dynamic> json)
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
}

enum StatusAgenda { Disponivel, Cheia, Encerrada, Indisponivel }
