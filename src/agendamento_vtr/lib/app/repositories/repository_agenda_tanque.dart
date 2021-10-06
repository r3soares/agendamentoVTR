import 'dart:convert';
import 'package:agendamento_vtr/app/domain/erros.dart';
import 'package:agendamento_vtr/app/models/model_base.dart';
import 'package:agendamento_vtr/app/modules/agendamento/models/agenda_tanque.dart';

import 'infra/IDatabase.dart';

class RepositoryAgendaTanque {
  final IDatabase db;

  RepositoryAgendaTanque(this.db);

  Future<ModelBase> get(String id) async {
    try {
      var result = await db.getById(id);
      var agendaTanque = result == false ? throw NaoEncontrado(id) : AgendaTanque.fromJson(result);
      return ModelBase(agendaTanque);
    } on Falha catch (e) {
      print('Erro ao procurar agendaTanque $id: $e');
      throw e;
    }
  }

  Future<ModelBase> getAll() async {
    try {
      var result = await db.getAll();
      List<AgendaTanque> lista =
          result == false ? List.empty(growable: true) : (result as List).map((n) => AgendaTanque.fromJson(n)).toList();
      return ModelBase(lista);
    } on Falha catch (e) {
      print('Erro ao buscar agendasTanque: $e');
      throw e;
    }
  }

  // Future<ModelBase> findByAgenda(String agenda) async {
  //   try {
  //     var result = await db.find('agenda', agenda);
  //     var lista =
  //         result == false ? List.empty(growable: true) : (result as List).map((n) => AgendaTanque.fromJson(n)).toList();
  //     return ModelBase(lista);
  //   } on Falha catch (e) {
  //     print('Erro ao procurar agendasTanque pela agenda $agenda: $e');
  //     throw e;
  //   }
  // }

  Future<ModelBase> findByAgendas(List<String> agendas) async {
    try {
      ///VERIFICAR
      //var listaFormatada = agendas.fold('', (previousValue, element) => '$previousValue|$element');
      //print(listaFormatada);
      var result = await db.find2('agendas', agendas);
      var lista =
          result == false ? List.empty(growable: true) : (result as List).map((n) => AgendaTanque.fromJson(n)).toList();
      return ModelBase(lista);
    } on Falha catch (e) {
      print('Erro ao procurar agendasTanque pela lista de agendas: $e');
      throw e;
    }
  }

  Future<ModelBase> save(AgendaTanque value) async {
    try {
      bool salvou = await db.save(jsonEncode(value.toJson()));
      if (!salvou) print('Erro em salvaAgenda em Repository Agenda');
      return ModelBase(salvou);
    } on Falha catch (e) {
      print('Erro ao salvar agendaTanque ${value.id}: $e');
      throw e;
    }
  }
}
