import 'package:agendamento_vtr/app/models/empresa.dart';
import 'package:agendamento_vtr/app/repositories/repository.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Repositorio Empresas', () {
    Empresa e = new Empresa();
    e.cnpj = '00970455941';
    e.email = 'teste@teste';
    e.proprietario = 1;
    e.telefone = '91977750';
    e.tanques.addAll(['OKG5498', 'MME1396']);

    Repository repo = Repository();

    repo.salvaEmpresa(e);

    e.email = 'teste2';

    Empresa? eSalva = repo.findEmpresa('00970455941');
    expect(eSalva, isNot(equals(null)));
    expect(eSalva!.email, equals('teste@teste'));
  });
}
