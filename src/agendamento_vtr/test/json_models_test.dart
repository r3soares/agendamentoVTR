import 'dart:math';

import 'package:agendamento_vtr/app/models/empresa.dart';
import 'package:agendamento_vtr/app/models/responsavel.dart';
import 'package:agendamento_vtr/app/models/tanque.dart';
import 'package:agendamento_vtr/app/modules/agendamento/models/agenda.dart';
import 'package:agendamento_vtr/app/modules/agendamento/models/estado.dart';
import 'package:agendamento_vtr/app/modules/agendamento/models/municipio.dart';
import 'package:agendamento_vtr/app/modules/agendamento/models/tanque_agendado.dart';
import 'package:flutter_test/flutter_test.dart';

import 'objetos/agendas.dart';
import 'objetos/agendados.dart';
import 'objetos/empresas.dart';
import 'objetos/responsaveis.dart';
import 'objetos/tanques.dart';

void main() {
  group('Teste de conversao Json - Model', () {
    Empresas();
    Tanques();
    Agendados();
    Agendas();
    Responsaveis();
    test('Empresa', () {
      for (int i = 0; i < Empresas.empresas.length; i++) {
        Empresa e = Empresas.empresas[i];
        Map<String, dynamic> json = e.toJson();
        Empresa e2 = e.fromJson(json);
        expect(e.cnpjCpf, equals(e2.cnpjCpf), reason: 'CNPJ não validou');
        expect(e.email, equals(e2.email), reason: 'Email não validou');
        expect(e.status, equals(e2.status), reason: 'Status não validou');
        expect(e.razaoSocial, equals(e2.razaoSocial),
            reason: 'Nome não validou');
        expect(e.telefones.length, equals(e2.telefones.length),
            reason: 'Telefone não validou');
        if (e.proprietario != null) {
          expect(e2.proprietario, isNotNull);
          expect(e.proprietario!.cod, equals(e2.proprietario!.cod),
              reason: 'CodProp não validou');
          expect(e.proprietario!.codMun, equals(e2.proprietario!.codMun),
              reason: 'CodMunProp não validou');
          //expect(e.proprietario!.tanques.length, equals(e2.proprietario!.tanques.length),
          //reason: 'TanqueProp não validou');
        }
      }
    });
    test('Tanque', () {
      for (int i = 0; i < Tanques.tanques.length; i++) {
        Tanque t1 = Tanques.tanques[i];
        Map<String, dynamic> json = t1.toJson();
        Tanque t2 = t1.fromJson(json);
        expect(t1.capacidadeTotal, equals(t2.capacidadeTotal),
            reason: 'Capacidades Totais diferentes');
        expect(t1.codInmetro, equals(t2.codInmetro),
            reason: 'CodInmetro não validou');
        expect(t1.compartimentos.length, equals(t2.compartimentos.length),
            reason: 'Qtd Compartimentos não validou');
        if (t1.compartimentos.isNotEmpty) {
          expect(t1.compartimentos[0], equals(t2.compartimentos[0]),
              reason: 'Compartimento 1 não validou');
          expect(t1.compartimentos[0].capacidade,
              equals(t2.compartimentos[0].capacidade),
              reason: 'capacidade 1 não validou');
          expect(t1.compartimentos[0].pos, equals(t2.compartimentos[0].pos),
              reason: 'pos 1 não validou');
          expect(t1.compartimentos[0].setas, equals(t2.compartimentos[0].setas),
              reason: 'pos 1 não validou');
        }

        expect(t1.dataRegistro, equals(t2.dataRegistro),
            reason: 'DataRegistro não validou');
        expect(t1.dataUltimaAlteracao, equals(t2.dataUltimaAlteracao),
            reason: 'DataAlteracao não validou');
        expect(t1.placa, equals(t2.placa), reason: 'Placa diferentes');
        if (t1.proprietario != null) {
          expect(t1.proprietario!.cnpjCpf, equals(t2.proprietario!.cnpjCpf),
              reason: 'Proprietario não validou');
        }

        expect(t1.status, equals(t2.status), reason: 'Status não validou');
        //expect(t1.ultimoAgendamento, equals(t2.ultimoAgendamento), reason: 'TanqueAgendado não validou');
      }
    });
    test('Tanque Agendado', () {
      for (int i = 0; i < Agendados.agendados.length; i++) {
        TanqueAgendado a1 = Agendados.agendados[i];
        Map<String, dynamic> json = a1.toJson();
        TanqueAgendado a2 = a1.fromJson(json);
        expect(a1.agenda, equals(a2.agenda), reason: 'Agenda não validou');
        //expect(a1.agendaAnterior, equals(a2.agendaAnterior), reason: 'agendaAnterior não validou');
        expect(a1.bitremAgenda, equals(a2.bitremAgenda),
            reason: 'bitremAgenda não validou');
        expect(a1.custoVerificacao, equals(a2.custoVerificacao),
            reason: 'custoVerificacao não validou');
        expect(a1.id, equals(a2.id), reason: 'id diferente');
        expect(a1.obs, equals(a2.obs), reason: 'obs não validou');
        expect(a1.responsavel.cnpj_cpf, equals(a2.responsavel.cnpj_cpf),
            reason: 'responsavel não validou');
        expect(a1.statusConfirmacao, equals(a2.statusConfirmacao),
            reason: 'statusConfirmacao diferentes');
        expect(a1.statusPagamento, equals(a2.statusPagamento),
            reason: 'statusPagamento não validou');
        //expect(a1.tanque, equals(a2.tanque), reason: 'tanque não validou');
        expect(a1.tanque.codInmetro, equals(a2.tanque.codInmetro),
            reason: 'tanque não validou');
        expect(a1.tanque.placa, equals(a2.tanque.placa),
            reason: 'tanque não validou');
        expect(a1.tempoVerificacao, equals(a2.tempoVerificacao),
            reason: 'tempoVerificacao não validou');
        expect(a1.statusCor, equals(a2.statusCor), reason: 'Cor não validou');
      }
    });

    test('AgendasDoDia', () {
      for (int i = 0; i < Agendas.agendas.length; i++) {
        Agenda a1 = Agendas.agendas[i];
        Map<String, dynamic> json = a1.toJson();
        Agenda a2 = a1.fromJson(json);
        expect(a1.data, equals(a2.data), reason: 'data não validou');
        //expect(a1.id, equals(a2.id), reason: 'id não validou');
        expect(a1.obs, equals(a2.obs), reason: 'obs não validou');
        expect(a1.status, equals(a2.status), reason: 'status não validou');
        expect(a1.tanquesAgendados.length, equals(a2.tanquesAgendados.length),
            reason: 'tanquesAgendados diferente');
        if (a1.tanquesAgendados.isNotEmpty) {
          expect(a1.tanquesAgendados[0].id, equals(a2.tanquesAgendados[0].id),
              reason: 'tanquesAgendados[0] diferente');
        }
      }
    });
    test('Municipios', () {
      Estado e = Estado(Random().nextInt(1000), 'SC', 'Santa Catarina');
      Municipio m = Municipio(
          e, Random().nextInt(1000), Random().nextInt(1000), 'Itajaí');
      Map<String, dynamic> json = m.toJson();
      Municipio m2 = Municipio.fromJson(json);
      expect(m.cdMunicipio, equals(m2.cdMunicipio));
      expect(m.munId, equals(m2.munId));
      expect(m.noMunicipio, equals(m2.noMunicipio));
      expect(m.unfId.noUf, equals(m2.unfId.noUf));
      expect(m.unfId.sgUf, equals(m2.unfId.sgUf));
      expect(m.unfId.unfId, equals(m2.unfId.unfId));
    });

    test('Responsaveis', () {
      for (var r in Responsaveis.responsaveis) {
        Map<String, dynamic> json = r.toJson();
        Responsavel r2 = Responsavel.fromJson(json);
        expect(r.id, equals(r2.id));
        expect(r.emails.length, equals(r.emails.length));
        expect(r.apelido, equals(r.apelido));
        expect(r.telefones.length, equals(r.telefones.length));
        expect(r.cnpj_cpf, equals(r.cnpj_cpf));
      }
    });
  });
}
