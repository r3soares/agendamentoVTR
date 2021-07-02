import 'dart:math';

import 'package:agendamento_vtr/app/modules/tanque/models/compartimento.dart';
import 'package:agendamento_vtr/app/modules/tanque/models/proprietario.dart';
import 'package:agendamento_vtr/app/modules/tanque/models/tanque.dart';

class Repository {
  List<Tanque?> _tanques = List.empty(growable: true);
  List<Proprietario?> _proprietarios = List.empty(growable: true);

  List<Tanque?> get tanques => _tanques;
  List<Proprietario?> get proprietarios => _proprietarios;

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
      for (int i = 0; i < 100; i++) {
        Tanque t = Tanque();
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
  addProprietario(value) => proprietarios.add(value);

  removeTanque(value) => _tanques.remove(value);
  removeProprietario(value) => _proprietarios.remove(value);

  Tanque? findTanque(String placa) =>
      _tanques.firstWhere((t) => t?.placa == placa, orElse: () => null);
  Proprietario? findProprietario(String cnpjCpf) =>
      _proprietarios.firstWhere((t) => t?.cnpj == cnpjCpf, orElse: () => null);
}
