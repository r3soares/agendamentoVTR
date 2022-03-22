import 'dart:convert';

import 'package:agendamento_vtr/app/domain/erros.dart';
import 'package:agendamento_vtr/app/domain/log.dart';
import 'package:agendamento_vtr/app/models/dado_psie.dart';

import 'infra/IDatabase.dart';

class RepositoryPsie {
  final IDatabase db;

  RepositoryPsie(this.db);

  Future<DadoPsie> getPlaca(String placa) async {
    try {
      var result = await db.getById(placa);
      var dados = result == false
          ? throw NaoEncontrado(placa)
          : DadoPsie.fromJson(result);
      return dados;
    } on Falha catch (e) {
      Log.message(this, 'Erro ao procurar placa pelo PSIE $placa: ${e.msg}');
      throw e;
    }
  }
}
