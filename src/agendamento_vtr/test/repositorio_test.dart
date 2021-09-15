import 'package:agendamento_vtr/app/models/empresa.dart';
import 'package:agendamento_vtr/app/models/proprietario.dart';
import 'package:agendamento_vtr/app/repositories/repository.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Repositorio Empresas', () {
    Empresa e = new Empresa();
    e.cnpjCpf = '00970455941';
    e.email = 'teste@teste';
    e.proprietario = Proprietario();
    e.telefone = '91977750';
    e.addTanque('OKG5498');
    e.addTanque('MME1396');

    Repository repo = Repository();

    repo.salvaEmpresa(e);

    e.email = 'teste2';

    Empresa? eSalva = repo.findEmpresa('00970455941');
    expect(eSalva, isNot(equals(null)));
    expect(eSalva!.email, equals('teste@teste'));
  });
}
