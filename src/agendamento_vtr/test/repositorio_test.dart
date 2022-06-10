import 'dart:io';
import 'dart:math';

import 'package:agendamento_vtr/app/domain/constantes.dart';
import 'package:agendamento_vtr/app/models/empresa.dart';
import 'package:agendamento_vtr/app/models/model_base.dart';
import 'package:agendamento_vtr/app/models/responsavel.dart';
import 'package:agendamento_vtr/app/models/tanque.dart';
import 'package:agendamento_vtr/app/modules/agendamento/models/agenda.dart';
import 'package:agendamento_vtr/app/modules/agendamento/models/tanque_agendado.dart';
import 'package:agendamento_vtr/app/repositories/infra/api.dart';
import 'package:agendamento_vtr/app/repositories/infra/constantes.dart';
import 'package:agendamento_vtr/app/repositories/repository_agenda.dart';
import 'package:agendamento_vtr/app/repositories/repository_municipio.dart';
import 'package:agendamento_vtr/app/repositories/repository_responsavel.dart';
import 'package:agendamento_vtr/app/repositories/repository_tanque_agendado.dart';
import 'package:agendamento_vtr/app/repositories/repository_empresa.dart';
import 'package:agendamento_vtr/app/repositories/repository_tanque.dart';
import 'package:flutter_test/flutter_test.dart';

import 'objetos/agendas.dart';
import 'objetos/agendados.dart';
import 'objetos/empresas.dart';
import 'objetos/responsaveis.dart';
import 'objetos/tanques.dart';

void main() {
  group('Teste de repositorios', () {
    var repoEmpresa = RepositoryEmpresa(Api(Constantes.api, 'vtr/empresa'));
    var repoTanque = RepositoryTanque(Api(Constantes.api, 'vtr/tanque'));
    var repoTa =
        RepositoryTanqueAgendado(Api(Constantes.api, 'vtr/tanqueAgendado'));
    var repoAgenda = RepositoryAgenda(Api(Constantes.api, 'vtr/agenda'));
    var repoResponsavel =
        RepositoryResponsavel(Api(Constantes.api, 'vtr/responsavel'));
    var repoMuncipio =
        RepositoryMunicipio(Api(Constantes.api, 'sgi/municipio'));
    test('Popula Base', () async {
      Empresas();
      for (int i = 0; i < Empresas.empresas.length; i++) {
        Empresa e = Empresas.empresas[i];
        bool salvou = await repoEmpresa.salvaEmpresa(e);
        expect(salvou, isTrue, reason: '$i Não salvou -> ${e.cnpjCpf}');
      }

      Tanques();
      for (int i = 0; i < Tanques.tanques.length; i++) {
        Tanque t1 = Tanques.tanques[i];
        bool salvou = await repoTanque.salvaTanque(t1);
        expect(salvou, isTrue, reason: '$i Não salvou -> ${t1.placa}');
      }

      Agendados();
      Agendas();
      for (TanqueAgendado at in Agendados.agendados) {
        bool salvou = await repoTa.save(at);
        expect(salvou, isTrue);
      }

      for (Agenda a in Agendas.agendas) {
        //sleep(Duration(milliseconds: 10));
        ModelBase mb = await repoAgenda.save(a);
        expect(mb.model, isTrue);
      }

      // Responsaveis();
      // for (Responsavel r in Responsaveis.responsaveis) {
      //   bool salvou = await repoResponsavel.salvaResponsavel(r);
      //   expect(salvou, isTrue);
      // }
    }, timeout: Timeout(Duration(minutes: 10)));
    test('Empresas', () async {
      sleep(Duration(seconds: 1));
      for (int i = 0; i < Empresas.empresas.length; i++) {
        Empresa e = Empresas.empresas[i];
        Empresa e2 = await repoEmpresa.getEmpresa(e.cnpjCpf);
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
    }, timeout: Timeout(Duration(minutes: 5)));

    test('Tanques', () async {
      sleep(Duration(seconds: 1));
      for (int i = 0; i < Tanques.tanques.length; i++) {
        Tanque t1 = Tanques.tanques[i];
        Tanque t2 = await repoTanque.findTanqueByPlaca(t1.placa);
        expect(t2, isNotNull);
        expect(t2.codInmetro, t1.codInmetro);
        expect(t2.placa, t1.placa);
        if (t1.compartimentos.isNotEmpty) {
          expect(
              t2.compartimentos[0].capacidade, t1.compartimentos[0].capacidade);
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

    test('Tanques Agendados', () async {
      sleep(Duration(seconds: 1));
      var lista = Agendados.agendados;
      for (int i = 0; i < lista.length; i++) {
        ModelBase mb = await repoTa.get(lista[i].id);
        expect(mb, isNotNull);
        TanqueAgendado at = mb.model;
        expect(at, isNotNull);
        expect(at.agenda, equals(lista[i].agenda));
        //expect(at.agendaAnterior, equals(lista[i].agendaAnterior));
        expect(at.bitremAgenda, equals(lista[i].bitremAgenda));
        expect(at.custoVerificacao, equals(lista[i].custoVerificacao));
        expect(at.id, equals(lista[i].id));
        expect(at.obs, equals(lista[i].obs));
        expect(at.responsavel?.cnpjCpf, equals(lista[i].responsavel?.cnpjCpf));
        expect(at.statusConfirmacao, equals(lista[i].statusConfirmacao));
        expect(at.statusPagamento, equals(lista[i].statusPagamento));
        expect(at.tanque.codInmetro, equals(lista[i].tanque.codInmetro));
        expect(at.tempoVerificacao, equals(lista[i].tempoVerificacao));
      }
    }, timeout: Timeout(Duration(minutes: 2)));
    test('Agendados Filtros', () async {
      List<TanqueAgendado> pendentes = await repoTa.findPendentes();
      expect(pendentes, isNotNull);
      for (var item in pendentes) {
        expect(item.statusConfirmacao, equals(StatusConfirmacao.PreAgendado));
      }
    }, timeout: Timeout(Duration(minutes: 2)));
    test('Agendas', () async {
      var lista = Agendas.agendas;
      var menorData = DateTime.now().add(Duration(days: 3000));
      var maiorData = DateTime.now().add(Duration(days: -3000));
      for (int i = 0; i < lista.length; i++) {
        ModelBase mb = await repoAgenda.get(lista[i].data);
        expect(mb, isNotNull);
        Agenda a = mb.model;
        menorData = a.d.compareTo(menorData) < 0 ? a.d : menorData;
        maiorData = a.d.compareTo(menorData) > 0 ? a.d : maiorData;

        expect(a, isNotNull);
        expect(a.data, equals(lista[i].data));
        //expect(a.data.m, equals(lista[i].data.day));
        //expect(a.data.day, equals(lista[i].data.day));
        //expect(a.id, equals(lista[i].id));
        expect(a.obs, equals(lista[i].obs));
        expect(a.status, equals(lista[i].status));
        if (lista[i].tanquesAgendados.isNotEmpty) {
          for (int j = 0; j < lista[i].tanquesAgendados.length; j++) {
            expect(a.tanquesAgendados[j].id,
                equals(lista[i].tanquesAgendados[j].id));
          }
        }
      }
      ModelBase mb = await repoTa.getAll();
      List<TanqueAgendado> todas = mb.model;
      expect(lista.length, equals(todas.length));

      mb = await repoAgenda.findByPeriodo(
          Constants.formatoData.format(menorData),
          Constants.formatoData.format(maiorData));
    }, timeout: Timeout(Duration(minutes: 2)));
    test('Agendas Filtros', () async {
      List<Agenda> lista = (await repoAgenda.getAll()).model;
      var menorData = DateTime.now().add(Duration(days: 3000));
      var maiorData = DateTime.now().add(Duration(days: -3000));
      for (int i = 0; i < lista.length; i++) {
        Agenda a = lista[i];
        menorData = a.d.compareTo(menorData) < 0 ? a.d : menorData;
        maiorData = a.d.compareTo(menorData) > 0 ? a.d : maiorData;
      }
      var mb = await repoAgenda.findByPeriodo(
          Constants.formatoData.format(menorData),
          Constants.formatoData.format(maiorData));
      List<Agenda> periodo = mb.model;
      expect(periodo, isNotNull, reason: 'FindByPeriodo não validou');

      Agenda a = lista[Random().nextInt(lista.length)];
      mb = await repoAgenda.get(a.data);
      expect(a.data, equals(mb.model.data), reason: 'Get não validou');
    }, timeout: Timeout(Duration(minutes: 2)));

    test('Municipios', () async {
      var municipios = await repoMuncipio.getMunicipios();
      expect(municipios.length > 5000, isTrue);
      var listaFiltrada = await repoMuncipio.findMunicipiosByNome(('ita'));
      var m = listaFiltrada.firstWhere((e) => e.noMunicipio == 'ITAJAÍ');
      expect(m, isNotNull);
      expect(m.noMunicipio, equals('ITAJAÍ'));
    }, timeout: Timeout(Duration(minutes: 2)));

    test('Responsaveis', () async {
      var responsaveis = await repoResponsavel.getResponsaveis();
      expect(responsaveis.length > 1, isTrue);
      var listaFiltrada =
          await repoResponsavel.findResponsaveisByNomeParcial('M');
      var m = listaFiltrada.firstWhere((e) => e.nome == 'Michael Jackson');
      expect(m, isNotNull);
      expect(m.nome, equals('Michael Jackson'));

      for (int i = 0; i < 100; i++) {
        String novoID = await repoResponsavel.getNovoID();
        expect(novoID, isNotNull);
      }
    }, timeout: Timeout(Duration(minutes: 2)));
  });
}
