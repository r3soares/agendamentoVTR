import 'package:agendamento_vtr/app/models/empresa.dart';
import 'package:agendamento_vtr/app/models/proprietario.dart';
import 'package:agendamento_vtr/app/models/tanque.dart';
import 'package:agendamento_vtr/app/repositories/infra/api.dart';
import 'package:agendamento_vtr/app/repositories/repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';

import 'objetos/empresas_test.dart';
import 'objetos/tanques_test.dart';

void main() {
  group('Teste de repositorios', () {
    test('Empresas', () async {
      Empresa e = EmpresasTest().empresa1;

      Repository repo = Repository(Api('empresa'));

      Response resp = await repo.salvaEmpresa(e);
      print(resp);
      e.email = 'teste2';

      Empresa? eSalva = await repo.findEmpresa('00970455941');
      expect(eSalva, isNot(equals(null)));
      expect(eSalva!.email, equals('teste@teste'));
    });

    test('Tanques', () async {
      Repository repo = Repository(Api('tanque'));
      TanquesTest tt = TanquesTest();
      for (int i = 0; i < tt.tanques.length; i++) {
        Tanque t1 = tt.tanques[i];
        Response resp = await repo.addTanque(t1);
      }
    });
  });
}
