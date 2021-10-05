import 'dart:convert';

import 'package:agendamento_vtr/app/domain/erros.dart';
import 'package:agendamento_vtr/app/models/model_base.dart';
import 'package:agendamento_vtr/app/models/tanque.dart';

import 'infra/IDatabase.dart';

class RepositoryTanque {
  final IDatabase db;

  RepositoryTanque(this.db);

  Future<ModelBase> salvaTanque(Tanque value) async {
    try {
      bool salvou = await db.save(jsonEncode(value.toJson()));
      if (!salvou) print('Erro em salvaTanque em Repository Tanque');
      return ModelBase(salvou);
    } on Falha catch (e) {
      print('Erro ao salvar tanque ${value.placa}: $e');
      throw e;
    }
  }

  Future<ModelBase> salvaTanques(List<Tanque> lista) async {
    try {
      bool salvou = true;
      for (var item in lista) {
        salvou = salvou && await db.save(jsonEncode(item.toJson()));
      }
      if (!salvou) print('Erro em salvaTanques em Repository Tanque');
      return ModelBase(lista);
    } on Falha catch (e) {
      print('Erro ao salvar lista de tanques: $e');
      throw e;
    }
  }

  Future<bool> removeTanque(String inmetro) async {
    try {
      return await db.delete(inmetro);
    } on Falha catch (e) {
      print('Erro ao remover tanque $inmetro: $e');
      throw e;
    }
  }

  Future<ModelBase> findTanqueByPlaca(String placa) async {
    try {
      var result = await db.find('placa', placa);
      var tanque = result == false ? throw NaoEncontrado(placa) : Tanque.fromJson(result);
      return ModelBase(tanque);
    } on Falha catch (e) {
      print('Erro ao procurar tanque pela placa $placa: $e');
      throw e;
    }
  }

  Future<ModelBase> findTanquesByProprietario(String proprietario) async {
    try {
      var result = await db.find('proprietario', proprietario);
      var lista =
          result == false ? List.empty(growable: true) : (result as List).map((n) => Tanque.fromJson(n)).toList();
      return ModelBase(lista);
    } on Falha catch (e) {
      print('Erro ao procurar tanques pelo proprietário $proprietario: $e');
      throw e;
    }
  }

  Future<ModelBase> getTanque(String inmetro) async {
    try {
      var result = await db.getById(inmetro);
      var tanque = result == false ? throw NaoEncontrado(inmetro) : Tanque.fromJson(result);
      return ModelBase(tanque);
    } on Falha catch (e) {
      print('Erro ao procurar tanque $inmetro: $e');
      throw e;
    }
  }

  Future<List<Tanque>> getTanques() async {
    try {
      var result = await db.getAll();
      return result == false ? List.empty(growable: true) : (result as List).map((n) => Tanque.fromJson(n)).toList();
    } on Falha catch (e) {
      print('Erro ao buscar tanques: $e');
      throw e;
    }
  }
}
