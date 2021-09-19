import 'package:agendamento_vtr/app/models/json_serializable.dart';

class Proprietario implements JsonSerializable {
  int cod = 0;
  int codMun = 0;
  List<String> tanques = List.empty(growable: true);

  Proprietario();
  @override
  fromJson(Map<String, dynamic> json) => Proprietario.fromJson(json);

  Proprietario.fromJson(Map<String, dynamic> json)
      : cod = json['cod'],
        codMun = json['codMun'],
        tanques = List.from(json['tanques']);

  @override
  Map<String, dynamic> toJson() => {'cod': cod, 'codMun': codMun, 'tanques': tanques};
}
