import 'dart:convert';
import 'dart:math';

import 'package:agendamento_vtr/app/models/compartimento.dart';
import 'package:agendamento_vtr/app/models/empresa.dart';
import 'package:agendamento_vtr/app/models/tanque.dart';
import 'package:agendamento_vtr/app/repositories/IRepository.dart';

class Repository {
  List<Tanque?> _tanques = List.empty(growable: true);
  List<Empresa?> _empresas = List.empty(growable: true);

  List<Tanque?> get tanques => _tanques;
  //List<Empresa?> get empresas => _empresas;

  final IRepository repo;

  Repository(this.repo) {
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
        _tanques.add(t);
      }
      return true;
    }());
  }

  Future<bool> salvaTanque(Tanque value) async {
    var pExistente = await findTanqueByInmetro(value.codInmetro);
    if (pExistente != null) {
      return await repo.update(jsonEncode(value.toJson())) != null;
    }
    return await repo.save(jsonEncode(value.toJson())) != null;
  }

  Future<bool> salvaEmpresa(Empresa value) async {
    var pExistente = await findEmpresa(value.cnpjCpf);
    if (pExistente != null) {
      return await repo.update(jsonEncode(value.toJson())) != null;
    }
    return await repo.save(jsonEncode(value.toJson())) != null;
  }

  removeTanque(Tanque value) => _tanques.remove(value);
  removeEmpresa(Empresa value) => _empresas.remove(value);

  Future<Tanque?> findTanqueByPlaca(String placa) async {
    var result = await repo.find('placa', placa);
    return result == null ? null : Tanque.fromJson(result);
  }

  Future<Tanque?> findTanqueByInmetro(String inmetro) async {
    var result = await await repo.getById(inmetro);
    return result == null ? null : Tanque.fromJson(result);
  }

  Future<Empresa?> findEmpresa(String cnpjCpf) async {
    var result = await await repo.getById(cnpjCpf);
    return result == null ? null : Empresa.fromJson(result);
  }
}
