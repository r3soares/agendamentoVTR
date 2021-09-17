import 'package:agendamento_vtr/app/models/empresa.dart';
import 'package:agendamento_vtr/app/models/proprietario.dart';

class EmpresasTest {
  Empresa get empresa1 => Empresa()
    ..cnpjCpf = '00970455941'
    ..razaoSocial = 'Rodo Rodas'
    ..status = StatusEmpresa.PreCadastro
    ..email = 'teste@teste'
    ..telefones.add('91977750')
    ..proprietario = (Proprietario()
      ..cod = 1
      ..codMun = 100
      ..tanques.addAll(['OKG5498', 'MME1396']));
}
