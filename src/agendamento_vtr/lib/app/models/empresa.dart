import 'package:agendamento_vtr/app/models/json_serializable.dart';
import 'package:agendamento_vtr/app/models/proprietario.dart';

class Empresa implements JsonSerializable {
  String cnpjCpf = '';
  Proprietario? proprietario;
  String razaoSocial = '';
  String email = '';
  List<String> telefones = List.empty(growable: true);
  StatusEmpresa status = StatusEmpresa.PreCadastro;
  String? obs;

  Empresa();

  @override
  Empresa fromJson(Map<String, dynamic> json) => Empresa.fromJson(json);

  Empresa.fromJson(Map<String, dynamic> json)
      : cnpjCpf = json['cnpj'],
        razaoSocial = json['nome'],
        email = json['email'],
        telefones = List.from(json['telefones']),
        proprietario = json['proprietario'] == null ? null : Proprietario.fromJson(json['proprietario']),
        status = StatusEmpresa.values[json['status']],
        obs = json['obs'] == null ? null : json['obs'];

  @override
  Map<String, dynamic> toJson() => {
        'cnpj': cnpjCpf,
        'nome': razaoSocial,
        'email': email,
        'telefones': telefones,
        'status': status.index,
        'proprietario': proprietario == null ? null : proprietario!.toJson(),
        'obs': obs
      };

  @override
  String toString() {
    return '[$cnpjCpf] $razaoSocial';
  }
}

enum StatusEmpresa {
  PreCadastro,
  Ativa,
  Inativa,
}
