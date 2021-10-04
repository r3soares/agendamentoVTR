import 'dart:convert';

import 'package:agendamento_vtr/app/domain/erros.dart';
import 'package:agendamento_vtr/app/domain/extensions.dart';
import 'package:agendamento_vtr/app/models/model_base.dart';
import 'package:agendamento_vtr/app/modules/agendamento/models/agenda.dart';
import 'package:agendamento_vtr/app/modules/agendamento/models/agenda_tanque.dart';
import 'package:uuid/uuid.dart';

import 'infra/IDatabase.dart';

class RepositoryAgendaTanque {
  final IDatabase db;

  RepositoryAgendaTanque(this.db);

  Future<ModelBase> getAgendaTanque(String id) async {
    try {
      var result = await db.getById(id);
      var agendaTanque = result == false ? throw NaoEncontrado(id) : AgendaTanque.fromJson(result);
      return ModelBase(agendaTanque);
    } on Falha catch (e) {
      print('Erro ao procurar agendaTanque $id: $e');
      throw e;
    }
  }

  Future<ModelBase> getAgendasTanque() async {
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

  Future<ModelBase> findAgendasTanqueByAgenda(String agenda) async {
    try {
      var result = await db.find('agenda', agenda);
      var lista =
          result == false ? List.empty(growable: true) : (result as List).map((n) => AgendaTanque.fromJson(n)).toList();
      return ModelBase(lista);
    } on Falha catch (e) {
      print('Erro ao procurar agendasTanque pela agenda $agenda: $e');
      throw e;
    }
  }

  Future<ModelBase> findAgendasTanqueByAgendas(List<String> agendas) async {
    try {
      var result = await db.find('agenda', agendas);
      var lista =
          result == false ? List.empty(growable: true) : (result as List).map((n) => AgendaTanque.fromJson(n)).toList();
      return ModelBase(lista);
    } on Falha catch (e) {
      print('Erro ao procurar agendasTanque pela lista de agendas: $e');
      throw e;
    }
  }

  Future<ModelBase> salvaAgendaTanque(AgendaTanque value) async {
    try {
      bool salvou = await db.save(jsonEncode(value.toJson()));
      if (!salvou) print('Erro em salvaAgenda em Repository Agenda');
      return ModelBase(value);
    } on Falha catch (e) {
      print('Erro ao salvar agendaTanque ${value.id}: $e');
      throw e;
    }
  }
}
