import 'dart:io';
import 'dart:math';

import 'package:agendamento_vtr/app/domain/extensions.dart';
import 'package:agendamento_vtr/app/models/empresa.dart';
import 'package:agendamento_vtr/app/models/model_base.dart';
import 'package:agendamento_vtr/app/models/tanque.dart';
import 'package:agendamento_vtr/app/modules/agendamento/models/agenda.dart';
import 'package:agendamento_vtr/app/modules/agendamento/models/tanque_agendado.dart';
import 'package:agendamento_vtr/app/repositories/infra/api.dart';
import 'package:agendamento_vtr/app/repositories/repository_agenda.dart';
import 'package:agendamento_vtr/app/repositories/repository_tanque_agendado.dart';
import 'package:agendamento_vtr/app/repositories/repository_empresa.dart';
import 'package:agendamento_vtr/app/repositories/repository_tanque.dart';
import 'package:flutter_test/flutter_test.dart';

import 'objetos/agendas.dart';
import 'objetos/agendados.dart';
import 'objetos/empresas.dart';
import 'objetos/tanques.dart';

void main() {
  group('Teste de repositorios', () {
    bool baseAgendaPopulada = false;
    bool baseAgendaTanquePopulada = false;
    test('Empresas', () async {
      var repo = RepositoryEmpresa(Api('empresa'));
      Empresas();
      for (int i = 0; i < Empresas.empresas.length; i++) {
        Empresa e = Empresas.empresas[i];
        ModelBase mb = await repo.salvaEmpresa(e);
        expect(mb.model, isTrue, reason: '$i Não salvou -> ${e.cnpjCpf}');
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
      var repo = RepositoryTanque(Api('tanque'));
      Tanques();
      for (int i = 0; i < Tanques.tanques.length; i++) {
        Tanque t1 = Tanques.tanques[i];
        ModelBase mb = await repo.salvaTanque(t1);
        expect(mb.model, isTrue, reason: '$i Não salvou -> ${t1.placa}');
      }
      sleep(Duration(seconds: 1));
      for (int i = 0; i < Tanques.tanques.length; i++) {
        Tanque t1 = Tanques.tanques[i];
        Tanque t2 = (await repo.findTanqueByPlaca(t1.placa)).model;
        expect(t2, isNotNull);
        expect(t2.codInmetro, t1.codInmetro);
        expect(t2.placa, t1.placa);
        if (t1.compartimentos.isNotEmpty) {
          expect(t2.compartimentos[0].capacidade, t1.compartimentos[0].capacidade);
        }
        expect(t2.dataRegistro.second, t1.dataRegistro.second);
        expect(t2.dataRegistro.minute, t1.dataRegistro.minute);
        expect(t2.dataRegistro.hour, t1.dataRegistro.hour);
        expect(t2.dataRegistro.day, t1.dataRegistro.day);
        expect(t2.dataRegistro.month, t1.dataRegistro.month);
        expect(t2.dataRegistro.year, t1.dataRegistro.year);
        //expect(t2.dataUltimaAlteracao, t1.dataUltimaAlteracao);
      }
    }, timeout: Timeout(Duration(minutes: 2)));

    test('AgendasTanque', () async {
      var repo = RepositoryTanqueAgendado(Api('agendaTanque'));
      Agendados();
      Agendas();
      for (TanqueAgendado at in Agendados.agendas) {
        ModelBase mb = await repo.save(at);
        expect(mb.model, isTrue);
      }
      baseAgendaTanquePopulada = true;
      var lista = Agendados.agendas;
      for (int i = 0; i < lista.length; i++) {
        ModelBase mb = await repo.get(lista[i].id);
        expect(mb, isNotNull);
        TanqueAgendado at = mb.model;
        expect(at, isNotNull);
        expect(at.agenda, equals(lista[i].agenda));
        expect(at.agendaAnterior, equals(lista[i].agendaAnterior));
        expect(at.bitremAgenda, equals(lista[i].bitremAgenda));
        expect(at.custoVerificacao, equals(lista[i].custoVerificacao));
        expect(at.id, equals(lista[i].id));
        expect(at.obs, equals(lista[i].obs));
        expect(at.responsavel, equals(lista[i].responsavel));
        expect(at.statusConfirmacao, equals(lista[i].statusConfirmacao));
        expect(at.statusPagamento, equals(lista[i].statusPagamento));
        expect(at.tanque, equals(lista[i].tanque));
        expect(at.tempoVerificacao, equals(lista[i].tempoVerificacao));
      }
    }, timeout: Timeout(Duration(minutes: 2)));
    test('Agendas', () async {
      var repo = RepositoryAgenda(Api('agenda'));
      Agendados();
      Agendas();
      for (Agenda a in Agendas.agendas) {
        ModelBase mb = await repo.save(a);
        expect(mb.model, isTrue);
      }
      baseAgendaPopulada = true;
      var lista = Agendas.agendas;
      var menorData = DateTime.now().add(Duration(days: 3000));
      var maiorData = DateTime.now().add(Duration(days: -3000));
      for (int i = 0; i < lista.length; i++) {
        ModelBase mb = await repo.get(lista[i].id);
        expect(mb, isNotNull);
        Agenda a = mb.model;
        menorData = a.data.compareTo(menorData) < 0 ? a.data : menorData;
        maiorData = a.data.compareTo(menorData) > 0 ? a.data : maiorData;

        expect(a, isNotNull);
        expect(a.data.diaMesAno(), equals(lista[i].data.diaMesAno()));
        //expect(a.data.m, equals(lista[i].data.day));
        //expect(a.data.day, equals(lista[i].data.day));
        expect(a.id, equals(lista[i].id));
        expect(a.obs, equals(lista[i].obs));
        expect(a.status, equals(lista[i].status));
        if (lista[i].tanquesAgendados.isNotEmpty) {
          for (int j = 0; j < lista[i].tanquesAgendados.length; j++) {
            expect(a.tanquesAgendados[j], equals(lista[i].tanquesAgendados[j]));
          }
        }
      }
      ModelBase mb = await repo.getAll();
      List<Agenda> todas = mb.model;
      expect(lista.length, equals(todas.length));

      mb = await repo.findByPeriodo(menorData.subtract(Duration(hours: 12)), maiorData);
      List<Agenda> periodo = mb.model;
      // lista.removeWhere((x) => periodo.firstWhereOrNull((e) => e.id == x.id) != null);
      // if (lista.isNotEmpty) {
      //   print('Inconsistencia no periodo (${lista.length})');
      //   print('Menor data: $menorData');
      //   print('Maior data: $maiorData');
      //   for (var item in lista) {
      //     print('${item.id} => ${item.data}');
      //   }
      // }
      expect(lista.length, equals(periodo.length));
    }, timeout: Timeout(Duration(minutes: 2)));
    test('Agendas Filtros', () async {
      var repoA = RepositoryAgenda(Api('agenda'));
      var repoAT = RepositoryTanqueAgendado(Api('agendaTanque'));
      if (!baseAgendaPopulada) {
        Agendados();
        Agendas();
        for (Agenda a in Agendas.agendas) {
          ModelBase mb = await repoA.save(a);
          expect(mb.model, isTrue);
        }
      }

      if (!baseAgendaTanquePopulada) {
        for (TanqueAgendado at in Agendados.agendas) {
          ModelBase mb = await repoAT.save(at);
          expect(mb.model, isTrue);
        }
      }

      List<Agenda> lista = (await repoA.getAll()).model;
      var menorData = DateTime.now().add(Duration(days: 3000));
      var maiorData = DateTime.now().add(Duration(days: -3000));
      for (int i = 0; i < lista.length; i++) {
        Agenda a = lista[i];
        menorData = a.data.compareTo(menorData) < 0 ? a.data : menorData;
        maiorData = a.data.compareTo(menorData) > 0 ? a.data : maiorData;
      }
      var mb = await repoA.findByPeriodo(menorData.subtract(Duration(hours: 12)), maiorData);
      List<Agenda> periodo = mb.model;
      expect(periodo, isNotNull, reason: 'FindByPeriodo não validou');

      Agenda a = lista[Random().nextInt(lista.length)];
      mb = await repoA.findByData(a.data);
      expect(a.id, equals(mb.model.id), reason: 'FindByData não validou');

      List<TanqueAgendado> listaAt = (await repoAT.findByAgendas(lista.map((e) => e.id).toList())).model;
      expect(listaAt.length, greaterThan(0));
    }, timeout: Timeout(Duration(minutes: 2)));
  });
}
