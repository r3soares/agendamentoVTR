import 'package:agendamento_vtr/app/models/empresa.dart';
import 'package:agendamento_vtr/app/models/tanque.dart';
import 'package:flutter_test/flutter_test.dart';

import 'objetos/empresas_test.dart';
import 'objetos/tanques_test.dart';

void main() {
  group('Teste de conversao Json <-> Model', () {
    test('Empresa', () {
      Empresa e = EmpresasTest().empresa1;
      Map<String, dynamic> json = e.toJson();
      Empresa e2 = e.fromJson(json);
      expect(e.cnpjCpf, equals(e2.cnpjCpf), reason: 'CNPJ não validou');
      expect(e.email, equals(e2.email), reason: 'Email não validou');
      expect(e.status, equals(e2.status), reason: 'Status não validou');
      expect(e.proprietario!.cod, equals(e2.proprietario!.cod), reason: 'CodProp não validou');
      expect(e.proprietario!.codMun, equals(e2.proprietario!.codMun), reason: 'CodMunProp não validou');
      expect(e.proprietario!.tanques[0], equals(e2.proprietario!.tanques[0]), reason: 'TanqueProp não validou');
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
