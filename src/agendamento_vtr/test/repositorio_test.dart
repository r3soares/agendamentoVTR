import 'dart:io';

import 'package:agendamento_vtr/app/models/empresa.dart';
import 'package:agendamento_vtr/app/models/tanque.dart';
import 'package:agendamento_vtr/app/modules/empresa/models/empresa_model.dart';
import 'package:agendamento_vtr/app/repositories/infra/api.dart';
import 'package:agendamento_vtr/app/repositories/repository.dart';
import 'package:flutter_test/flutter_test.dart';

import 'objetos/empresas_test.dart';
import 'objetos/tanques_test.dart';

void main() {
  group('Teste de repositorios', () {
    test('Empresas', () async {
      EmpresasTest et = EmpresasTest();
      Repository repo = Repository(Api('empresa'));
      for (int i = 0; i < et.empresas.length; i++) {
        Empresa e = et.empresas[i];
        bool salvou = (await repo.salvaEmpresa(e)).status == Status.Salva;
        expect(salvou, isTrue, reason: '$i -> ${e.cnpjCpf}');
      }
      sleep(Duration(seconds: 1));
      for (int i = 0; i < et.empresas.length; i++) {
        Empresa e = et.empresas[i];
        Empresa? e2 = (await repo.getEmpresa(e.cnpjCpf)).empresa;
        expect(e2, isNotNull);
        expect(e2.email, equals(e.email));
        if (e.proprietario != null) {
          expect(e2.proprietario, isNotNull);
          expect(e2.proprietario!.cod, equals(e.proprietario!.cod));
          expect(e2.proprietario!.codMun, equals(e.proprietario!.codMun));
          expect(e2.proprietario!.tanques.length, equals(e2.proprietario!.tanques.length));
        }
        expect(e2.razaoSocial, equals(e.razaoSocial));
        expect(e2.status, equals(e.status));
        expect(e2.telefones.length, equals(e.telefones.length));
      }
    }, timeout: Timeout(Duration(minutes: 2)));

    test('Tanques', () async {
      Repository repo = Repository(Api('tanque'));
      TanquesTest tt = TanquesTest();
      for (int i = 0; i < tt.tanques.length; i++) {
        Tanque t1 = tt.tanques[i];
        bool salvou = await repo.salvaTanque(t1);
        expect(salvou, isTrue, reason: '$i -> ${t1.placa}');
      }
      sleep(Duration(seconds: 1));
      for (int i = 0; i < tt.tanques.length; i++) {
        Tanque t1 = tt.tanques[i];
        Tanque? t2 = await repo.findTanqueByPlaca(t1.placa);
        expect(t2, isNotNull);
        expect(t2!.codInmetro, t1.codInmetro);
        expect(t2.placa, t1.placa);
        expect(t2.compartimentos[0].capacidade, t1.compartimentos[0].capacidade);
        expect(t2.dataRegistro.second, t1.dataRegistro.second);
        expect(t2.dataRegistro.minute, t1.dataRegistro.minute);
        expect(t2.dataRegistro.hour, t1.dataRegistro.hour);
        expect(t2.dataRegistro.day, t1.dataRegistro.day);
        expect(t2.dataRegistro.month, t1.dataRegistro.month);
        expect(t2.dataRegistro.year, t1.dataRegistro.year);
        //expect(t2.dataUltimaAlteracao, t1.dataUltimaAlteracao);
      }
    }, timeout: Timeout(Duration(minutes: 2)));
  });
}
