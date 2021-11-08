import 'package:agendamento_vtr/app/domain/erros.dart';
import 'package:agendamento_vtr/app/domain/log.dart';
import 'package:agendamento_vtr/app/modules/agendamento/models/municipio.dart';

import 'infra/IDatabase.dart';

class RepositoryMunicipio {
  final IDatabase db;

  RepositoryMunicipio(this.db);

  // Future<Tanque> findTanqueByPlaca(String placa) async {
  //   try {
  //     var result = await db.find('placa', placa);
  //     var tanque = result == false ? throw NaoEncontrado(placa) : Tanque.fromJson(result);
  //     return tanque;
  //   } on Falha catch (e) {
  //     print('Erro ao procurar tanque pela placa $placa: $e');
  //     throw e;
  //   }
  // }

  Future<List<Municipio>> findMunicipiosByNome(String nome) async {
    try {
      var result = await db.find('nome', nome.replaceAll(' ', '_'));
      return result == false ? List.empty(growable: true) : (result as List).map((n) => Municipio.fromJson(n)).toList();
    } on Falha catch (e) {
      print('Erro ao procurar tanques pelo proprietário $nome: $e');
      throw e;
    }
  }

  Future<Municipio> getMunicipio(int cod) async {
    try {
      var result = await db.getById(cod);
      var municipio = result == false ? throw NaoEncontrado(cod) : Municipio.fromJson(result);
      return municipio;
    } on Falha catch (e) {
      Log.message(this, 'Erro ao procurar municipio $cod: $e');
      throw e;
    }
  }

  Future<List<Municipio>> getMunicipios() async {
    try {
      var result = await db.getAll();
      return result == false ? List.empty(growable: true) : (result as List).map((n) => Municipio.fromJson(n)).toList();
    } on Falha catch (e) {
      print('Erro ao buscar tanques: $e');
      throw e;
    }
  }
}
