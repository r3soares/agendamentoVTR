import 'package:flutter/material.dart';

class Empresa extends ChangeNotifier {
  String _cnpjCpf = '';
  String _razaoSocial = '';
  String _email = '';
  String? _telefone = '';

  final List<String> _tanques = List.empty(growable: true);

  void addTanque(String placa) {
    _tanques.add(placa);
    notifyListeners();
  }

  void removeTanque(String placa) {
    _tanques.remove(placa);
    notifyListeners();
  }

  set cnpj(value) => _cnpjCpf = value;
  set razaoSocial(value) => _razaoSocial = value;
  set email(value) => _email = value;
  set telefone(value) => _telefone = value;
  //set oficina(value) => _responsavel = value;

  String get cnpj => _cnpjCpf;
  String get razaoSocial => _razaoSocial;
  String get email => _email;
  String? get telefone => _telefone;
  //String? get oficina => _responsavel;

  List<String> get tanques => _tanques;
}
