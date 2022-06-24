import 'package:agendamento_vtr/app/models/json_serializable.dart';

class Responsavel implements JsonSerializable {
  final String id;
  final String apelido;
  String? apelidoEmpresa;
  List<String> telefones = [];
  List<String> emails = [];
  String? cnpj_cpf;
  String? obs;
  //List<String> tanques = List.empty(growable: true);

  Responsavel(this.id, this.apelido);
  @override
  fromJson(Map<String, dynamic> json) => Responsavel.fromJson(json);

  Responsavel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        apelido = json['apelido'],
        apelidoEmpresa = json['apelidoEmpresa'],
        telefones = List.from(json['telefones']),
        emails = List.from(json['emails']),
        cnpj_cpf = json['cnpj_cpf'],
        obs = json['obs'];

  @override
  Map<String, dynamic> toJson() => {
        'id': id,
        'apelido': apelido,
        'apelidoEmpresa': apelidoEmpresa,
        'telefones': telefones,
        'emails': emails,
        'cnpj_cpf': cnpj_cpf,
        'obs': obs,
      };
}
