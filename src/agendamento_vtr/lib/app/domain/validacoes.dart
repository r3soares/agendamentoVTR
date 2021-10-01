import 'package:agendamento_vtr/app/domain/util/cnpj.dart';
import 'package:agendamento_vtr/app/domain/util/cpf.dart';

class Validacoes {
  bool validaPlaca(String placa) {
    RegExp regex = RegExp('[A-Z]{3}[0-9][0-9A-Z][0-9]{2}');
    return regex.hasMatch(placa);
  }

  bool validaEmail(String email) {
    String pattern = r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]"
        r"{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]"
        r"{0,253}[a-zA-Z0-9])?)*$";
    RegExp regex = new RegExp(pattern);
    return regex.hasMatch(email);
  }

  bool validaTelefone(String telefone) {
    print(telefone);
    String pattern = '[1-9]{2}[1-9]?[0-9]{8}';
    RegExp regex = new RegExp(pattern);
    return regex.hasMatch(telefone);
  }

  bool validaCNPJ(value) {
    return CNPJ.isValid(value);
  }

  bool validaCPF(value) {
    return CPF.isValid(value);
  }
}
