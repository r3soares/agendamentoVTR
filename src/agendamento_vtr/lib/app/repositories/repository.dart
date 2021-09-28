import 'dart:convert';
import 'dart:math';

import 'package:agendamento_vtr/app/domain/erros.dart';
import 'package:agendamento_vtr/app/models/compartimento.dart';
import 'package:agendamento_vtr/app/models/empresa.dart';
import 'package:agendamento_vtr/app/models/model_base.dart';
import 'package:agendamento_vtr/app/models/tanque.dart';
import 'package:agendamento_vtr/app/repositories/IRepository.dart';
import 'package:agendamento_vtr/app/repositories/infra/api.dart';

class Repository {
  final IRepository repoTanque = Api('tanque');
  final IRepository repoEmpresa = Api('empresa');
  static const bool populaTeste = false;

  Repository() {
    if (populaTeste) {
      assert(() {
        final alfabeto = [
          'A',
          'B',
          'C',
          'D',
          'E',
          'F',
          'G',
          'H',
          'I',
          'J',
          'K',
          'L',
          'M',
          'N',
          'O',
          'P',
          'Q',
          'R',
          'S',
          'T',
          'U',
          'V',
          'X',
          'Y',
          'Z'
        ];
        Empresa p = Empresa();
        p.cnpjCpf = '00970455941';
        p.email = 'contato@empresa.com';
        p.telefones.add('(47) 9622-5871');
        p.razaoSocial = 'Rolando Milhas';
        salvaEmpresa(p); //empresas.add(p);
        for (int i = 0; i < Random().nextInt(500) + 15; i++) {
          Tanque t = Tanque();
          t.proprietario = p.cnpjCpf;
          t.codInmetro = "${Random().nextInt(alfabeto.length)}$i";
          t.placa = alfabeto[Random().nextInt(alfabeto.length)] +
              alfabeto[Random().nextInt(alfabeto.length)] +
              alfabeto[Random().nextInt(alfabeto.length)] +
              Random().nextInt(10).toString() +
              Random().nextInt(10).toString() +
              Random().nextInt(10).toString() +
              Random().nextInt(10).toString();
          for (int j = 0; j < Random().nextInt(10); j++) {
            t.compartimentos.add(Compartimento(j + 1));
            t.compartimentos[j].capacidade = Random().nextInt(50) * 100;
            t.compartimentos[j].setas = Random().nextInt(5);
          }
          t.dataRegistro = DateTime.now().subtract(Duration(minutes: Random().nextInt(200000)));
          t.dataUltimaAlteracao = DateTime.now().subtract(Duration(minutes: Random().nextInt(200000)));
          t.dataRegistro = DateTime.now().subtract(Duration(minutes: Random().nextInt(200000)));
          t.custo = (Random().nextDouble() * 5000);
          t.status = StatusTanque.values[Random().nextInt(2)];
          salvaTanque(t);
        }
        return true;
      }());
    }
  }

  Future<ModelBase> salvaTanque(Tanque value) async {
    try {
      bool salvou = await repoTanque.save(jsonEncode(value.toJson()));
      return ModelBase(salvou ? Status.Salva : Status.NaoSalva, value);
    } on Falha catch (e) {
      print('Erro ao salvar tanque ${value.placa}: $e');
      throw e;
    }
  }

  Future<ModelBase> salvaTanques(List<Tanque> lista) async {
    try {
      bool salvou = true;
      for (var item in lista) {
        salvou = salvou && await repoTanque.save(jsonEncode(item.toJson()));
      }
      return ModelBase(salvou ? Status.Salva : Status.NaoSalva, lista);
    } on Falha catch (e) {
      print('Erro ao salvar lista de tanques: $e');
      throw e;
    }
  }

  Future<ModelBase> salvaEmpresa(Empresa value) async {
    try {
      bool salvou = await repoEmpresa.save(jsonEncode(value.toJson()));
      return ModelBase(salvou ? Status.Salva : Status.NaoSalva, value);
    } on Falha catch (e) {
      print('Erro ao salvar empresa ${value.cnpjCpf}: $e');
      throw e;
    }
  }

  Future<bool> removeTanque(String inmetro) async {
    try {
      return await repoTanque.delete(inmetro);
    } on Falha catch (e) {
      print('Erro ao remover tanque $inmetro: $e');
      throw e;
    }
  }

  Future<bool> removeEmpresa(String cnpj) async {
    try {
      return await repoEmpresa.delete(cnpj);
    } on Falha catch (e) {
      print('Erro ao remover empresa $cnpj: $e');
      throw e;
    }
  }

  Future<ModelBase> findTanqueByPlaca(String placa) async {
    try {
      var result = await repoTanque.find('placa', placa);
      var tanque = result == false ? throw NaoEncontrado(placa) : Tanque.fromJson(result);
      return ModelBase(Status.ConsultaPlaca, tanque);
    } on Falha catch (e) {
      print('Erro ao procurar tanque pela placa $placa: $e');
      throw e;
    }
  }

  Future<ModelBase> findTanquesByProprietario(String proprietario) async {
    try {
      var result = await repoTanque.find('proprietario', proprietario);
      var lista =
          result == false ? List.empty(growable: true) : (result as List).map((n) => Tanque.fromJson(n)).toList();
      return ModelBase(Status.ConsultaMuitos, lista);
    } on Falha catch (e) {
      print('Erro ao procurar tanques pelo proprietário $proprietario: $e');
      throw e;
    }
  }

  Future<ModelBase> getTanque(String inmetro) async {
    try {
      var result = await repoTanque.getById(inmetro);
      var tanque = result == false ? throw NaoEncontrado(inmetro) : Tanque.fromJson(result);
      return ModelBase(Status.ConsultaInmetro, tanque);
    } on Falha catch (e) {
      print('Erro ao procurar tanque $inmetro: $e');
      throw e;
    }
  }

  Future<List<Tanque>> getTanques() async {
    try {
      var result = await repoTanque.getAll();
      return result == false ? List.empty(growable: true) : (result as List).map((n) => Tanque.fromJson(n)).toList();
    } on Falha catch (e) {
      print('Erro ao buscar tanques: $e');
      throw e;
    }
  }

  Future<ModelBase> getEmpresa(String cnpjCpf) async {
    try {
      var result = await repoEmpresa.getById(cnpjCpf);
      var empresa = result == false ? throw NaoEncontrado(cnpjCpf) : Empresa.fromJson(result);
      return ModelBase(Status.Consulta, empresa);
    } on Falha catch (e) {
      print('Erro ao buscar empresa $cnpjCpf: ${e.msg}');
      throw e;
    }
  }

  Future<List<Empresa>> getEmpresas() async {
    try {
      var result = await repoEmpresa.getAll();
      return result == false ? List.empty(growable: true) : (result as List).map((n) => Empresa.fromJson(n)).toList();
    } on Falha catch (e) {
      print('Erro ao buscar empresas: $e');
      throw e;
    }
  }
}
