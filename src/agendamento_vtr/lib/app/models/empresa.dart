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

  String get cnpjFormatado => cnpjCpf.length > 11
      ? '${cnpjCpf.substring(0, 2)}.${cnpjCpf.substring(2, 5)}.${cnpjCpf.substring(5, 8)}/${cnpjCpf.substring(8, 12)}-${cnpjCpf.substring(12, 14)}'
      : '${cnpjCpf.substring(0, 3)}.${cnpjCpf.substring(3, 6)}.${cnpjCpf.substring(6, 9)}-${cnpjCpf.substring(9, 11)}';

  String get cnpjOuCpf => cnpjCpf.length > 11 ? 'CNPJ' : 'CPF';
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
