import 'dart:convert';
import 'dart:math';

import 'package:agendamento_vtr/app/domain/erros.dart';
import 'package:agendamento_vtr/app/models/compartimento.dart';
import 'package:agendamento_vtr/app/models/empresa.dart';
import 'package:agendamento_vtr/app/models/tanque.dart';
import 'package:agendamento_vtr/app/modules/empresa/models/empresa_model.dart';
import 'package:agendamento_vtr/app/repositories/IRepository.dart';

class Repository {
  final IRepository repo;
  static const bool populaTeste = false;

  Repository(this.repo) {
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

  Future<bool> salvaTanque(Tanque value) async {
    try {
      return await repo.save(jsonEncode(value.toJson()));
    } on Falha catch (e) {
      print('Erro ao salvar tanque ${value.placa}: $e');
      throw e;
    }
  }

  Future<EmpresaModel> salvaEmpresa(Empresa value) async {
    try {
      bool salvou = await repo.save(jsonEncode(value.toJson()));
      return EmpresaModel(salvou ? Status.Salva : Status.NaoSalva, value);
    } on Falha catch (e) {
      print('Erro ao salvar empresa ${value.cnpjCpf}: $e');
      throw e;
    }
  }

  Future<bool> removeTanque(String inmetro) async {
    try {
      return await repo.delete(inmetro);
    } on Falha catch (e) {
      print('Erro ao remover tanque $inmetro: $e');
      throw e;
    }
  }

  Future<bool> removeEmpresa(String cnpj) async {
    try {
      return await repo.delete(cnpj);
    } on Falha catch (e) {
      print('Erro ao remover empresa $cnpj: $e');
      throw e;
    }
  }

  Future<Tanque?> findTanqueByPlaca(String placa) async {
    try {
      var result = await repo.find('placa', placa);
      return result == false ? null : Tanque.fromJson(result);
    } on Falha catch (e) {
      print('Erro ao procurar tanque pela placa $placa: $e');
      throw e;
    }
  }

  Future<Tanque?> getTanque(String inmetro) async {
    try {
      var result = await repo.getById(inmetro);
      return result == false ? null : Tanque.fromJson(result);
    } on Falha catch (e) {
      print('Erro ao procurar tanque $inmetro: $e');
      throw e;
    }
  }

  Future<List<Tanque>> getTanques() async {
    try {
      var result = await repo.getAll();
      return result == false ? List.empty(growable: true) : (result as List).map((n) => Tanque.fromJson(n)).toList();
    } on Falha catch (e) {
      print('Erro ao buscar tanques: $e');
      throw e;
    }
  }

  Future<EmpresaModel> getEmpresa(String cnpjCpf) async {
    try {
      var result = await repo.getById(cnpjCpf);
      var empresa = result == false ? throw NaoEncontrado(cnpjCpf) : Empresa.fromJson(result);
      return EmpresaModel(Status.Consulta, empresa);
    } on Falha catch (e) {
      print('Erro ao buscar empresa $cnpjCpf: ${e.msg}');
      throw e;
    }
  }

  Future<List<Empresa>> getEmpresas() async {
    try {
      var result = await repo.getAll();
      return result == false ? List.empty(growable: true) : (result as List).map((n) => Empresa.fromJson(n)).toList();
    } on Falha catch (e) {
      print('Erro ao buscar empresas: $e');
      throw e;
    }
  }
}
