import 'dart:io';

import 'package:agendamento_vtr/app/models/empresa.dart';
import 'package:agendamento_vtr/app/models/model_base.dart';
import 'package:agendamento_vtr/app/models/tanque.dart';
import 'package:agendamento_vtr/app/repositories/repository.dart';
import 'package:flutter_test/flutter_test.dart';

import 'objetos/empresas.dart';
import 'objetos/tanques.dart';

void main() {
  group('Teste de repositorios', () {
    test('Empresas', () async {
      Empresas et = Empresas();
      Repository repo = Repository();
      for (int i = 0; i < Empresas.empresas.length; i++) {
        Empresa e = Empresas.empresas[i];
        bool salvou = (await repo.salvaEmpresa(e)).status == Status.Salva;
        expect(salvou, isTrue, reason: '$i -> ${e.cnpjCpf}');
      }
      sleep(Duration(seconds: 1));
      for (int i = 0; i < Empresas.empresas.length; i++) {
        Empresa e = Empresas.empresas[i];
        Empresa e2 = (await repo.getEmpresa(e.cnpjCpf)).model;
        expect(e2, isNotNull);
        expect(e2.email, equals(e.email));
        if (e.proprietario != null) {
          expect(e2.proprietario, isNotNull);
          expect(e2.proprietario!.cod, equals(e.proprietario!.cod));
          expect(e2.proprietario!.codMun, equals(e.proprietario!.codMun));
          //expect(e2.proprietario!.tanques.length, equals(e2.proprietario!.tanques.length));
        }
        expect(e2.razaoSocial, equals(e.razaoSocial));
        expect(e2.status, equals(e.status));
        expect(e2.telefones.length, equals(e.telefones.length));
      }
    }, timeout: Timeout(Duration(minutes: 2)));

    test('Tanques', () async {
      Repository repo = Repository();
      Tanques tt = Tanques();
      for (int i = 0; i < Tanques.tanques.length; i++) {
        Tanque t1 = Tanques.tanques[i];
        bool salvou = (await repo.salvaTanque(t1)).status == Status.Salva;
        expect(salvou, isTrue, reason: '$i -> ${t1.placa}');
      }
      sleep(Duration(seconds: 1));
      for (int i = 0; i < Tanques.tanques.length; i++) {
        Tanque t1 = Tanques.tanques[i];
        Tanque t2 = (await repo.findTanqueByPlaca(t1.placa)).model;
        expect(t2, isNotNull);
        expect(t2.codInmetro, t1.codInmetro);
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
