import 'package:agendamento_vtr/app/models/proprietario.dart';
import 'package:flutter/material.dart';

class Empresa extends ChangeNotifier {
  String cnpjCpf = '';
  Proprietario? proprietario;
  String razaoSocial = '';
  String email = '';
  String? telefone = '';
  StatusEmpresa status = StatusEmpresa.Ativa;

  final List<String> _tanques = List.empty(growable: true);

  void addTanque(String placa) {
    if (_tanques.contains(placa)) return;
    _tanques.add(placa);
    notifyListeners();
  }

  void removeTanque(String placa) {
    _tanques.remove(placa);
    notifyListeners();
  }
}

enum StatusEmpresa {
  Ativa,
  Inativa,
}
