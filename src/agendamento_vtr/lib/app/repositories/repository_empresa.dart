import 'dart:convert';

import 'package:agendamento_vtr/app/domain/erros.dart';
import 'package:agendamento_vtr/app/models/empresa.dart';
import 'package:agendamento_vtr/app/models/model_base.dart';
import 'package:agendamento_vtr/app/repositories/infra/IDatabase.dart';

class RepositoryEmpresa {
  final IDatabase db;

  RepositoryEmpresa(this.db);

  Future<ModelBase> salvaEmpresa(Empresa value) async {
    try {
      bool salvou = await db.save(jsonEncode(value.toJson()));
      if (!salvou) print('Erro em salvaEmpresa em Repository Empresa');
      return ModelBase(salvou);
    } on Falha catch (e) {
      print('Erro ao salvar empresa ${value.cnpjCpf}: $e');
      throw e;
    }
  }

  Future<bool> removeEmpresa(String cnpj) async {
    try {
      return await db.delete(cnpj);
    } on Falha catch (e) {
      print('Erro ao remover empresa $cnpj: $e');
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

  Future<ModelBase> getEmpresas() async {
    try {
      var result = await db.getAll();
      List<Empresa> lista =
          result == false ? List.empty(growable: true) : (result as List).map((n) => Empresa.fromJson(n)).toList();
      return ModelBase(lista);
    } on Falha catch (e) {
      print('Erro ao buscar empresas: $e');
      throw e;
    }
  }
}
