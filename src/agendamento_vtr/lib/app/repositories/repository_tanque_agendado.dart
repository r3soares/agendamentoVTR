import 'dart:convert';
import 'package:agendamento_vtr/app/domain/erros.dart';
import 'package:agendamento_vtr/app/domain/log.dart';
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
      Log.message(this, 'Erro ao procurar agendaTanque $id: $e');
      throw e;
    }
  }

  Future<ModelBase> getFromList(List<String> ids) async {
    if (ids.isEmpty) return ModelBase(List<TanqueAgendado>.empty());
    try {
      var result = await db.find2('lista', jsonEncode(ids));
      List<TanqueAgendado> lista = result == false
          ? List.empty(growable: true)
          : (result as List).map((n) => TanqueAgendado.fromJson(n)).toList();
      return ModelBase(lista);
    } on Falha catch (e) {
      print('Erro ao procurar Tanques agendados $ids: ${e.msg}');
      throw e;
    }
  }

  Future<List<TanqueAgendado>> findPendentes() async {
    try {
      var result = await db.find('pendentes', '');
      var pendentes = result == false
          ? List.empty(growable: true)
          : (result as List).map((n) => TanqueAgendado.fromJson(n)).toList();
      return pendentes as List<TanqueAgendado>;
    } on Falha catch (e) {
      Log.message(this, 'Erro ao procurar tanques pendentes: ${e.msg}');
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
      Log.message(this, 'Erro ao buscar agendasTanque: ${e.msg}');
      throw e;
    }
  }

  //Busca todas as agendasTanque que possuem a agenda na lista
  Future<ModelBase> findByAgendas(List<String> agendas) async {
    try {
      var result = await db.find2('agendas', jsonEncode(agendas));
      var lista = result == false
          ? List.empty(growable: true)
          : (result as List).map((n) => TanqueAgendado.fromJson(n)).toList();
      return ModelBase(lista);
    } on Falha catch (e) {
      Log.message(this, 'Erro ao procurar agendasTanque pela lista de agendas: ${e.msg}');
      throw e;
    }
  }

  Future<bool> save(TanqueAgendado value) async {
    try {
      bool salvou = await db.save(jsonEncode(value.toJson()));
      if (!salvou) Log.message(this, 'Erro em salvaAgenda em Repository Agenda');
      return salvou;
    } on Falha catch (e) {
      Log.message(this, 'Erro ao salvar agendaTanque ${value.id}: ${e.msg}');
      throw e;
    }
  }

  Future<ModelBase> saveMany(List<TanqueAgendado> lista) async {
    try {
      bool salvou = true;
      for (var item in lista) {
        salvou = await db.save(jsonEncode(item.toJson())) && salvou;
      }
      if (!salvou) Log.message(this, 'Erro em saveMany em Repository de Tanques Agendados');
      return ModelBase(salvou);
    } on Falha catch (e) {
      Log.message(this, 'Erro ao salvar lista de tanques agendados: ${e.msg}');
      throw e;
    }
  }

  Future<bool> remove(String id) async {
    try {
      bool removeu = await db.delete(id);
      if (!removeu) Log.message(this, 'Erro ao remover tanque agendado');
      return removeu;
    } on Falha catch (e) {
      Log.message(this, 'Erro ao remover tanque agendado $id: ${e.msg}');
      throw e;
    }
  }
}
