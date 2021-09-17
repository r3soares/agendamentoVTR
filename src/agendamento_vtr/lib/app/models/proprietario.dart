import 'dart:convert';

import 'package:agendamento_vtr/app/models/json_serializable.dart';

class Proprietario implements JsonSerializable {
  int cod = 0;
  int codMun = 0;
  List<String> tanques = List.empty(growable: true);

  Proprietario();
  @override
  fromJson(Map<String, dynamic> json) {
    return Proprietario.fromJson(json);
  }

  Proprietario.fromJson(Map<String, dynamic> json)
      : cod = json['Cod'],
        codMun = json['CodMun'],
        tanques = List.from(json['Tanques']);

  @override
  Map<String, dynamic> toJson() =>
      {'Cod': cod, 'CodMun': codMun, 'Tanques': jsonEncode(tanques)};
}
