import 'package:agendamento_vtr/app/models/empresa.dart';
import 'package:agendamento_vtr/app/models/tanque.dart';
import 'package:agendamento_vtr/app/repositories/infra/api.dart';
import 'package:agendamento_vtr/app/repositories/repository.dart';
import 'package:flutter_test/flutter_test.dart';

import 'objetos/empresas_test.dart';
import 'objetos/tanques_test.dart';

void main() {
  group('Teste de repositorios', () {
    test('Empresas', () async {
      Empresa e = EmpresasTest().empresa1;

      Repository repo = Repository(Api('empresa'));

      bool salvou = await repo.salvaEmpresa(e);
      expect(salvou, equals(true));
      Empresa? e2 = await repo.getEmpresa('00970455941');
      expect(e2, isNot(equals(null)));
      expect(e2!.email, equals('teste@teste'));

      e.email = 'teste2';
      salvou = await repo.salvaEmpresa(e);
      e2 = await repo.getEmpresa('00970455941');
      expect(e2, isNot(equals(null)));
      expect(e2!.email, equals('teste2'));
    });

    test('Tanques', () async {
      Repository repo = Repository(Api('tanque'));
      TanquesTest tt = TanquesTest();
      for (int i = 0; i < tt.tanques.length; i++) {
        Tanque t1 = tt.tanques[i];
        bool salvou = await repo.salvaTanque(t1);
        expect(salvou, equals(true), reason: '$i -> ${t1.placa}');
      }
    }, timeout: Timeout(Duration(minutes: 2)));
  });
}
