import 'package:agendamento_vtr/app/models/empresa.dart';
import 'package:agendamento_vtr/app/models/tanque.dart';
import 'package:flutter_test/flutter_test.dart';

import 'objetos/empresas_test.dart';
import 'objetos/tanques_test.dart';

void main() {
  group('Teste de conversao Json <-> Model', () {
    test('Empresa', () {
      EmpresasTest et = EmpresasTest();
      for (int i = 0; i < et.empresas.length; i++) {
        Empresa e = et.empresas[i];
        Map<String, dynamic> json = e.toJson();
        Empresa e2 = e.fromJson(json);
        expect(e.cnpjCpf, equals(e2.cnpjCpf), reason: 'CNPJ não validou');
        expect(e.email, equals(e2.email), reason: 'Email não validou');
        expect(e.status, equals(e2.status), reason: 'Status não validou');
        expect(e.razaoSocial, equals(e2.razaoSocial), reason: 'Nome não validou');
        expect(e.telefones.length, equals(e2.telefones.length), reason: 'Telefone não validou');
        if (e.proprietario != null) {
          expect(e2.proprietario, isNotNull);
          expect(e.proprietario!.cod, equals(e2.proprietario!.cod), reason: 'CodProp não validou');
          expect(e.proprietario!.codMun, equals(e2.proprietario!.codMun), reason: 'CodMunProp não validou');
          expect(e.proprietario!.tanques.length, equals(e2.proprietario!.tanques.length),
              reason: 'TanqueProp não validou');
        }
      }
    });
    test('Tanque', () {
      TanquesTest tt = TanquesTest();
      for (int i = 0; i < tt.tanques.length; i++) {
        Tanque t1 = tt.tanques[i];
        Map<String, dynamic> json = t1.toJson();
        Tanque t2 = t1.fromJson(json);
        expect(t1.capacidadeTotal, equals(t2.capacidadeTotal), reason: 'Capacidades Totais diferentes');
        expect(t1.codInmetro, equals(t2.codInmetro), reason: 'CodInmetro não validou');
        expect(t1.compartimentos.length, equals(t2.compartimentos.length), reason: 'Qtd Compartimentos não validou');
        expect(t1.compartimentos[0], equals(t2.compartimentos[0]), reason: 'Compartimento 1 não validou');
        expect(t1.custo, equals(t2.custo), reason: 'Custo diferente');
        expect(t1.dataRegistro, equals(t2.dataRegistro), reason: 'DataRegistro não validou');
        expect(t1.dataUltimaAlteracao, equals(t2.dataUltimaAlteracao), reason: 'DataAlteracao não validou');
        expect(t1.placa, equals(t2.placa), reason: 'Placa diferentes');
        expect(t1.proprietario, equals(t2.proprietario), reason: 'Proprietario não validou');
        expect(t1.status, equals(t2.status), reason: 'Status não validou');
        expect(t1.tanqueAgendado, equals(t2.tanqueAgendado), reason: 'TanqueAgendado não validou');
      }
    });
  });
}
