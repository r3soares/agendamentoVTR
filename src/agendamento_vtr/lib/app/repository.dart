import 'dart:math';

import 'package:agendamento_vtr/app/modules/tanque/models/compartimento.dart';
import 'package:agendamento_vtr/app/modules/tanque/models/empresa.dart';
import 'package:agendamento_vtr/app/modules/tanque/models/tanque.dart';

class Repository {
  List<Tanque?> _tanques = List.empty(growable: true);
  List<Empresa?> _empresas = List.empty(growable: true);

  List<Tanque?> get tanques => _tanques;
  List<Empresa?> get empresas => _empresas;

  Repository() {
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
      p.cnpj = '00970455941';
      p.email = 'contato@empresa.com';
      p.telefone = '(47) 9622-5871';
      p.razaoSocial = 'Rolando Milhas';
      empresas.add(p);
      for (int i = 0; i < Random().nextInt(100) + 15; i++) {
        Tanque t = Tanque();
        t.proprietario = p.cnpj;
        t.placa = alfabeto[Random().nextInt(alfabeto.length)] +
            alfabeto[Random().nextInt(alfabeto.length)] +
            alfabeto[Random().nextInt(alfabeto.length)] +
            Random().nextInt(10).toString() +
            Random().nextInt(10).toString() +
            Random().nextInt(10).toString() +
            Random().nextInt(10).toString();
        for (int j = 0; j < Random().nextInt(10); j++) {
          t.compartimentos.add(Compartimento('C$j'));
          t.compartimentos[j].capacidade = Random().nextInt(50) * 100;
          t.compartimentos[j].setas = Random().nextInt(5);
        }
        t.dataRegistro = DateTime.now()
            .subtract(Duration(minutes: Random().nextInt(200000)));
        _tanques.add(t);
      }
      return true;
    }());
  }

  addTanque(value) => _tanques.add(value);
  void addEmpresa(Empresa value) {
    var pExistente =
        empresas.firstWhere((p) => p!.cnpj == value.cnpj, orElse: () => null);
    if (pExistente != null) {
      empresas.remove(pExistente);
      empresas.add(value);
      return;
    }
    empresas.add(value);
  }

  removeTanque(value) => _tanques.remove(value);
  removeEmpresa(value) => _empresas.remove(value);

  Tanque? findTanque(String placa) =>
      _tanques.firstWhere((t) => t?.placa == placa, orElse: () => null);
  Empresa? findEmpresa(String cnpjCpf) =>
      _empresas.firstWhere((t) => t?.cnpj == cnpjCpf, orElse: () => null);
}
