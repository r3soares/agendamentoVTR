import 'dart:convert';
import 'package:agendamento_vtr/app/domain/erros.dart';
import 'package:agendamento_vtr/app/models/model_base.dart';
import 'package:agendamento_vtr/app/modules/agendamento/models/tanque_agendado.dart';

import 'infra/IDatabase.dart';

class RepositoryTanqueAgendado {
  final IDatabase db;

  RepositoryTanqueAgendado(this.db);

  Future<ModelBase> get(String id) async {
    try {
      var result = await db.getById(id);
      var agendaTanque = result == false ? throw NaoEncontrado(id) : TanqueAgendado.fromJson(result);
      return ModelBase(agendaTanque);
    } on Falha catch (e) {
      print('Erro ao procurar agendaTanque $id: $e');
      throw e;
    }
  }

  Future<ModelBase> getMany(List<String> ids) async {
    try {
      var result = await db.find2('lista', jsonEncode(ids));
      var agendaTanque = result == false ? throw NaoEncontrado(ids) : TanqueAgendado.fromJson(result);
      return ModelBase(agendaTanque);
    } on Falha catch (e) {
      print('Erro ao procurar Tanques agendados $ids: $e');
      throw e;
    }
  }

  Future<ModelBase> getAll() async {
    try {
      var result = await db.getAll();
      List<TanqueAgendado> lista = result == false
          ? List.empty(growable: true)
          : (result as List).map((n) => TanqueAgendado.fromJson(n)).toList();
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

  //Busca todas as agendasTanque que possuem a agenda na lista
  Future<ModelBase> findByAgendas(List<String> agendas) async {
    try {
      var result = await db.find2('agendas', jsonEncode(agendas));
      var lista = result == false
          ? List.empty(growable: true)
          : (result as List).map((n) => TanqueAgendado.fromJson(n)).toList();
      return ModelBase(lista);
    } on Falha catch (e) {
      print('Erro ao procurar agendasTanque pela lista de agendas: $e');
      throw e;
    }
  }

  Future<ModelBase> save(TanqueAgendado value) async {
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
