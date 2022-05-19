import 'package:agendamento_vtr/app/models/empresa.dart';
import 'package:agendamento_vtr/app/models/json_serializable.dart';

class Responsavel implements JsonSerializable {
  final String id;
  final String nome;
  final String telefone;
  final String email;
  final Empresa? empresa;
  //List<String> tanques = List.empty(growable: true);

  Responsavel(this.id, this.nome, this.telefone, this.email, this.empresa);
  @override
  fromJson(Map<String, dynamic> json) => Responsavel.fromJson(json);

  Responsavel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        nome = json['nome'],
        telefone = json['telefone'],
        email = json['email'],
        empresa =
            json['empresa'] == null ? null : Empresa.fromJson(json['empresa']);

  @override
  Map<String, dynamic> toJson() => {
        'id': id,
        'nome': nome,
        'telefone': telefone,
        'email': email,
        'empresa': empresa == null ? null : empresa!.toJson()
      }; //'tanques': tanques};
}
