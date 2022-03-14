import 'dart:convert';

import 'package:agendamento_vtr/app/domain/erros.dart';
import 'package:agendamento_vtr/app/models/empresa.dart';
import 'package:agendamento_vtr/app/repositories/infra/IDatabase.dart';

class RepositoryEmpresa {
  final IDatabase db;

  RepositoryEmpresa(this.db);

  Future<bool> salvaEmpresa(Empresa value) async {
    try {
      bool salvou = await db.save(jsonEncode(value.toJson()));
      if (!salvou) print('Erro em salvaEmpresa em Repository Empresa');
      return salvou;
    } on Falha catch (e) {
      print('Erro ao salvar empresa ${value.cnpjCpf}: ${e.msg}');
      throw e;
    }
  }

  Future<bool> removeEmpresa(String cnpj) async {
    try {
      return await db.delete(cnpj);
    } on Falha catch (e) {
      print('Erro ao remover empresa $cnpj: ${e.msg}');
      throw e;
    }
  }

  Future<Empresa> getEmpresa(String cnpjCpf) async {
    try {
      var result = await db.getById(cnpjCpf);
      var empresa = result == false ? throw NaoEncontrado(cnpjCpf) : Empresa.fromJson(result);
      return empresa;
    } on Falha catch (e) {
      print('Erro ao buscar empresa $cnpjCpf: ${e.msg}');
      throw e;
    }
  }

  Future<List<Empresa>> getEmpresas() async {
    try {
      var result = await db.getAll();
      List<Empresa> lista =
          result == false ? List.empty(growable: true) : (result as List).map((n) => Empresa.fromJson(n)).toList();
      return lista;
    } on Falha catch (e) {
      print('Erro ao buscar empresas: ${e.msg}');
      throw e;
    }
  }

  Future<List<Empresa>> findEmpresasByNome(String nome) async {
    try {
      var result = await db.find('nome', '|$nome|');
      return result == false ? List.empty(growable: true) : (result as List).map((n) => Empresa.fromJson(n)).toList();
    } on Falha catch (e) {
      print('Erro ao procurar empresas pelo nome $nome: ${e.msg}');
      throw e;
    }
  }

  Future<List<Empresa>> findEmpresasByCNPJParcial(String cnpj) async {
    try {
      var result = await db.find('cnpjParcial', cnpj);
      return result == false ? List.empty(growable: true) : (result as List).map((n) => Empresa.fromJson(n)).toList();
    } on Falha catch (e) {
      print('Erro ao procurar empresas pelo cnpj parcial $cnpj: ${e.msg}');
      throw e;
    }
  }
}
