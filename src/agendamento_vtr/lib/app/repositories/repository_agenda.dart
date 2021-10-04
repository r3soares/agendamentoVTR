import 'dart:convert';

import 'package:agendamento_vtr/app/domain/erros.dart';
import 'package:agendamento_vtr/app/domain/extensions.dart';
import 'package:agendamento_vtr/app/models/model_base.dart';
import 'package:agendamento_vtr/app/modules/agendamento/models/agenda.dart';
import 'package:uuid/uuid.dart';

import 'infra/IDatabase.dart';

class RepositoryAgenda {
  final IDatabase db;

  RepositoryAgenda(this.db);

  Future<ModelBase> getAgenda(String id) async {
    try {
      var result = await db.getById(id);
      var agenda = result == false ? throw NaoEncontrado(id) : Agenda.fromJson(result);
      return ModelBase(agenda);
    } on Falha catch (e) {
      print('Erro ao procurar agenda $id: $e');
      throw e;
    }
  }

  Future<ModelBase> findAgenda(DateTime data) async {
    try {
      var result = await db.find('data', data.diaMesAno());
      var agenda = result == false ? throw NaoEncontrado(data) : Agenda.fromJson(result);
      return ModelBase(agenda);
    } on Falha catch (e) {
      print('FindAgenda => Erro ao procurar agenda pela data ${data.diaMesAnoToString()}: $e');
      throw e;
    }
  }

  Future<ModelBase> findAgendas(DateTime inicio, DateTime fim) async {
    try {
      var result = await db.find('periodo', [inicio.diaMesAno(), fim.diaMesAno()]);
      var agendas =
          result == false ? List.empty(growable: true) : (result as List).map((n) => Agenda.fromJson(n)).toList();
      return ModelBase(agendas);
    } on Falha catch (e) {
      print(
          'FindAgendas => Erro ao procurar agendas pela data entre: ${inicio.diaMesAnoToString()} e ${fim.diaMesAnoToString()}: $e');
      throw e;
    }
  }

  Future<ModelBase> findCreateAgenda(DateTime data) async {
    try {
      var result = await db.find('data', data.diaMesAno());
      Agenda agenda = result == false ? Agenda(Uuid().v1(), data.diaMesAno()) : Agenda.fromJson(result);
      return ModelBase(agenda);
    } on Falha catch (e) {
      print('FindCreateAgenda => Erro ao procurar agenda pela data ${data.diaMesAnoToString()}: $e');
    }
    print('Agenda criada');
    return ModelBase(Agenda(Uuid().v1(), data.diaMesAno()));
  }

  Future<ModelBase> salvaAgenda(Agenda value) async {
    try {
      bool salvou = await db.save(jsonEncode(value.toJson()));
      if (!salvou) print('Erro em salvaAgenda em Repository Agenda');
      return ModelBase(value);
    } on Falha catch (e) {
      print('Erro ao salvar agenda do dia ${value.data.diaMesAnoToString()}: $e');
      throw e;
    }
  }
}