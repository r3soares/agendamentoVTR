import 'dart:convert';

import 'package:agendamento_vtr/app/domain/erros.dart';
import 'package:agendamento_vtr/app/domain/log.dart';
import 'package:agendamento_vtr/app/models/tanque.dart';
import 'package:agendamento_vtr/app/modules/agendamento/models/tanque_agendado.dart';

import 'infra/IDatabase.dart';

class RepositoryTanque {
  final IDatabase db;

  RepositoryTanque(this.db);

  Future<bool> salvaTanque(Tanque value) async {
    try {
      bool salvou = await db.save(jsonEncode(value.toJson()));
      if (!salvou) Log.message(this, 'Tanque não foi salvo: ${value.placa}');
      return salvou;
    } on Falha catch (e) {
      Log.message(this, 'Erro ao salvar tanque ${value.placa}: $e');
      throw e;
    }
  }

  Future<bool> salvaTanques(List<Tanque> lista) async {
    try {
      bool salvou = true;
      for (var item in lista) {
        salvou = salvou && await db.save(jsonEncode(item.toJson()));
      }
      if (!salvou) print('Erro em salvaTanques em Repository Tanque');
      return salvou;
    } on Falha catch (e) {
      Log.message(this, 'Erro ao salvar lista de tanques: $e');
      throw e;
    }
  }

  Future<bool> removeTanque(String inmetro) async {
    try {
      return await db.delete(inmetro);
    } on Falha catch (e) {
      Log.message(this, 'Erro ao remover tanque $inmetro: $e');
      throw e;
    }
  }

  Future<Tanque> findTanqueByPlaca(String placa) async {
    try {
      var result = await db.find('placa', placa);
      var tanque = result == false ? throw NaoEncontrado(placa) : Tanque.fromJson(result);
      return tanque;
    } on Falha catch (e) {
      Log.message(this, 'Erro ao procurar tanque pela placa $placa: $e');
      throw e;
    }
  }

  Future<List<Tanque>> findTanquesByPlacaParcial(String placa) async {
    try {
      var result = await db.find('placaParcial', placa);
      return result == false ? List.empty(growable: true) : (result as List).map((n) => Tanque.fromJson(n)).toList();
    } on Falha catch (e) {
      print('Erro ao procurar tanques pela placa parcial $placa: $e');
      throw e;
    }
  }

  Future<List<Tanque>> findTanquesByInmetroParcial(String inmetro) async {
    try {
      var result = await db.find('inmetroParcial', inmetro);
      return result == false ? List.empty(growable: true) : (result as List).map((n) => Tanque.fromJson(n)).toList();
    } on Falha catch (e) {
      print('Erro ao procurar tanques pelo cod inmetro parcial $inmetro: $e');
      throw e;
    }
  }

  Future<List<Tanque>> findTanquesByProprietario(String proprietario) async {
    try {
      var result = await db.find('proprietario', proprietario);
      return result == false ? List.empty(growable: true) : (result as List).map((n) => Tanque.fromJson(n)).toList();
    } on Falha catch (e) {
      Log.message(this, 'Erro ao procurar tanques pelo proprietário $proprietario: $e');
      throw e;
    }
  }

  Future<List<TanqueAgendado>> getHistorico(String inmetro) async {
    try {
      var result = await db.find('historico', inmetro);
      List<TanqueAgendado> lista = result == false
          ? List.empty(growable: true)
          : (result as List).map((n) => TanqueAgendado.fromJson(n)).toList();
      return lista;
    } on Falha catch (e) {
      Log.message(this, 'Erro ao buscar historico: $e');
      throw e;
    }
  }

  Future<Tanque> getTanque(String inmetro) async {
    try {
      var result = await db.getById(inmetro);
      var tanque = result == false ? throw NaoEncontrado(inmetro) : Tanque.fromJson(result);
      return tanque;
    } on Falha catch (e) {
      Log.message(this, 'Erro ao procurar tanque $inmetro: $e');
      throw e;
    }
  }

  Future<List<Tanque>> getTanques() async {
    try {
      var result = await db.getAll();
      return result == false ? List.empty(growable: true) : (result as List).map((n) => Tanque.fromJson(n)).toList();
    } on Falha catch (e) {
      Log.message(this, 'Erro ao buscar tanques: $e');
      throw e;
    }
  }
}
