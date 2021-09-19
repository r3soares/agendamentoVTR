import 'dart:convert';
import 'dart:math';

import 'package:agendamento_vtr/app/models/compartimento.dart';
import 'package:agendamento_vtr/app/models/empresa.dart';
import 'package:agendamento_vtr/app/models/tanque.dart';
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
    var pExistente = await repo.getById(value.codInmetro);
    return pExistente == null
        ? await repo.save(jsonEncode(value.toJson()))
        : await repo.update(jsonEncode(value.toJson()));
  }

  Future<bool> salvaEmpresa(Empresa value) async {
    var pExistente = await repo.getById(value.cnpjCpf);
    return pExistente == null
        ? await repo.save(jsonEncode(value.toJson()))
        : await repo.update(jsonEncode(value.toJson()));
  }

  Future<bool> removeTanque(String inmetro) async {
    return await repo.delete(inmetro) != null;
  }

  Future<bool> removeEmpresa(String cnpj) async {
    return await repo.delete(cnpj) != null;
  }

  Future<Tanque?> findTanqueByPlaca(String placa) async {
    var result = await repo.find('placa', placa);
    return result == null ? null : Tanque.fromJson(result);
  }

  Future<Tanque?> getTanque(String inmetro) async {
    var result = await repo.getById(inmetro);
    return result == null ? null : Tanque.fromJson(result);
  }

  Future<List<Tanque>> getTanques() async {
    var result = await repo.getAll();
    return result == null ? List.empty(growable: true) : (result as List).map((n) => Tanque.fromJson(n)).toList();
  }

  Future<Empresa?> getEmpresa(String cnpjCpf) async {
    var result = await repo.getById(cnpjCpf);
    return result == null ? null : Empresa.fromJson(result);
  }
}
