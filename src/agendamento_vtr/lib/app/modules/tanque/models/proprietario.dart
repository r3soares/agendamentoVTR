import 'package:flutter/cupertino.dart';

import 'tanque.dart';

class Proprietario extends ChangeNotifier {
  String _cnpjCpf = '';
  String _razaoSocial = '';
  String _email = '';
  String? _oficina;

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
  set oficina(value) => _oficina = value;

  String get cnpj => _cnpjCpf;
  String get razaoSocial => _razaoSocial;
  String get email => _email;
  String? get oficina => _oficina;

  List get tanques => _tanques;
}
