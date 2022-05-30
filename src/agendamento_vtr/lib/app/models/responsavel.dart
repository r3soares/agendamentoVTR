import 'package:agendamento_vtr/app/models/json_serializable.dart';

class Responsavel implements JsonSerializable {
  final String id;
  final String nome;
  final String telefone;
  final String email;
  final String? empresa;
  final String? obs;
  //List<String> tanques = List.empty(growable: true);

  Responsavel(
      this.id, this.nome, this.telefone, this.email, this.empresa, this.obs);
  @override
  fromJson(Map<String, dynamic> json) => Responsavel.fromJson(json);

  Responsavel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        nome = json['nome'],
        telefone = json['telefone'],
        email = json['email'],
        empresa = json['empresa'],
        obs = json['obs'];

  @override
  Map<String, dynamic> toJson() => {
        'id': id,
        'nome': nome,
        'telefone': telefone,
        'email': email,
        'empresa': empresa,
        'obs': obs,
      };
}
