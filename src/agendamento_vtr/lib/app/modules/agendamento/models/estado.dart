import 'package:agendamento_vtr/app/models/json_serializable.dart';

class Estado implements JsonSerializable {
  final int unfId;
  final String sgUf;
  final String noUf;

  Estado(this.unfId, this.sgUf, this.noUf);

  @override
  fromJson(Map<String, dynamic> json) => Estado.fromJson(json);

  Estado.fromJson(Map<String, dynamic> json)
      : unfId = json['unfId'],
        sgUf = json['sgUf'],
        noUf = json['noUf'];

  @override
  Map<String, dynamic> toJson() => {
        'unfId': unfId,
        'sgUf': sgUf,
        'noUf': noUf,
      };
}
