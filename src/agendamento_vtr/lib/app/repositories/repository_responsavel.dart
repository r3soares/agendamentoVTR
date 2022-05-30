import 'dart:convert';

import 'package:agendamento_vtr/app/domain/erros.dart';
import 'package:agendamento_vtr/app/models/responsavel.dart';
import 'package:agendamento_vtr/app/repositories/infra/IDatabase.dart';

class RepositoryResponsavel {
  final IDatabase db;

  RepositoryResponsavel(this.db);

  Future<bool> salvaResponsavel(Responsavel value) async {
    try {
      bool salvou = await db.save(jsonEncode(value.toJson()));
      if (!salvou) print('Erro em salvaResponsavel em Repository Responsavel');
      return salvou;
    } on Falha catch (e) {
      print('Erro ao salvar responsavel ${value.nome}: ${e.msg}');
      throw e;
    }
  }

  Future<bool> removeResponsavel(String id) async {
    try {
      return await db.delete(id);
    } on Falha catch (e) {
      print('Erro ao remover repsonsavel $id: ${e.msg}');
      throw e;
    }
  }

  Future<Responsavel> getResponsavel(String id) async {
    try {
      var result = await db.getById(id);
      var responsavel = result == false
          ? throw NaoEncontrado(id)
          : Responsavel.fromJson(result);
      return responsavel;
    } on Falha catch (e) {
      print('Erro ao buscar responsavel $id: ${e.msg}');
      throw e;
    }
  }

  Future<String> getNovoID() async {
    try {
      var result = await db.get('novo');
      return result;
    } on Falha catch (e) {
      print('Erro ao gerar novo ID: ${e.msg}');
      throw e;
    }
  }

  Future<List<Responsavel>> getResponsaveis() async {
    try {
      var result = await db.getAll();
      List<Responsavel> lista = result == false
          ? List.empty(growable: true)
          : (result as List).map((n) => Responsavel.fromJson(n)).toList();
      return lista;
    } on Falha catch (e) {
      print('Erro ao buscar responsaveis: ${e.msg}');
      throw e;
    }
  }

  Future<List<Responsavel>> findResponsaveisByNomeParcial(
      String nomeParcial) async {
    try {
      var result = await db.find('nomeParcial', '|$nomeParcial|');
      return result == false
          ? List.empty(growable: true)
          : (result as List).map((n) => Responsavel.fromJson(n)).toList();
    } on Falha catch (e) {
      print('Erro ao procurar responsaveis pelo nome $nomeParcial: ${e.msg}');
      throw e;
    }
  }
}
