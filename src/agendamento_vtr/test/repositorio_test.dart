import 'package:agendamento_vtr/app/models/empresa.dart';
import 'package:agendamento_vtr/app/models/proprietario.dart';
import 'package:agendamento_vtr/app/repositories/infra/api.dart';
import 'package:agendamento_vtr/app/repositories/repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';

void main() {
  test('Repositorio Empresas', () async {
    Empresa e = new Empresa();
    e.cnpjCpf = '00970455941';
    e.razaoSocial = 'Rodo Rodas';
    e.status = StatusEmpresa.PreCadastro;
    e.email = 'teste@teste';
    e.proprietario = Proprietario()
      ..cod = 1
      ..codMun = 100
      ..tanques.addAll(['OKG5498', 'MME1396']);
    e.telefones.add('91977750');

    Repository repo = Repository(Api('empresa'));

    Response resp = await repo.salvaEmpresa(e);
    print(resp);
    e.email = 'teste2';

    Empresa? eSalva = repo.findEmpresa('00970455941');
    expect(eSalva, isNot(equals(null)));
    expect(eSalva!.email, equals('teste@teste'));
  });
}
