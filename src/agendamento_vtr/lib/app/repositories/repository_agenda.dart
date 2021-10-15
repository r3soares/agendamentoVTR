import 'dart:convert';

import 'package:agendamento_vtr/app/domain/erros.dart';
import 'package:agendamento_vtr/app/domain/log.dart';
import 'package:agendamento_vtr/app/models/model_base.dart';
import 'package:agendamento_vtr/app/modules/agendamento/models/agenda.dart';

import 'infra/IDatabase.dart';

class RepositoryAgenda {
  final IDatabase db;

  RepositoryAgenda(this.db);

  Future<ModelBase> getAll() async {
    try {
      var result = await db.getAll();
      var agendas =
          result == false ? List.empty(growable: true) : (result as List).map((n) => Agenda.fromJson(n)).toList();
      return ModelBase(agendas);
    } on Falha catch (e) {
      Log.message(this, 'GetAgendas => Erro ao buscar todas as agendas: $e');
      throw e;
    }
  }

  Future<ModelBase> get(String id) async {
    try {
      var result = await db.getById(id);
      var agenda = result == false ? throw NaoEncontrado(id) : Agenda.fromJson(result);
      return ModelBase(agenda);
    } on Falha catch (e) {
      Log.message(this, 'Erro ao procurar agenda $id: $e');
      throw e;
    }
  }

  Future<ModelBase> findByPeriodo(String dInicio, String dFim) async {
    try {
      var result = await db.find('periodo', '$dInicio|$dFim');
      var agendas =
          result == false ? List.empty(growable: true) : (result as List).map((n) => Agenda.fromJson(n)).toList();
      return ModelBase(agendas);
    } on Falha catch (e) {
      Log.message(this, 'Erro ao procurar agendas pela data entre: $dInicio e $dFim: $e');
      throw e;
    }
  }

  Future<ModelBase> getOrCreate(String data) async {
    try {
      var result = await db.getById(data);
      Agenda agenda = result == false ? Agenda(data) : Agenda.fromJson(result);
      return ModelBase(agenda);
    } on Falha catch (e) {
      Log.message(this, 'Erro ao procurar agenda pela data $data: $e');
    }
    Log.message(this, 'Agenda criada');
    return ModelBase(Agenda(data));
  }

  Future<ModelBase> save(Agenda value) async {
    try {
      bool salvou = await db.save(jsonEncode(value.toJson()));
      if (!salvou) Log.message(this, 'Erro em salvaAgenda em Repository Agenda');
      return ModelBase(salvou);
    } on Falha catch (e) {
      Log.message(this, 'Erro ao salvar agenda do dia ${value.data}: $e');
      throw e;
    }
  }
}
