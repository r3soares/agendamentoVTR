import 'dart:convert';

import 'package:agendamento_vtr/app/models/json_serializable.dart';
import 'package:agendamento_vtr/app/models/proprietario.dart';
import 'package:flutter/material.dart';

class Empresa extends ChangeNotifier implements JsonSerializable {
  String cnpjCpf = '';
  Proprietario? proprietario;
  String razaoSocial = '';
  String email = '';
  List<String> telefones = List.empty(growable: true);
  StatusEmpresa status = StatusEmpresa.PreCadastro;

  Empresa();
//tEM QUE REMOVER
  final List<String> _tanques = List.empty(growable: true);

//tEM QUE REMOVER
  void addTanque(String placa) {
    if (_tanques.contains(placa)) return;
    _tanques.add(placa);
    notifyListeners();
  }

//tEM QUE REMOVER
  void removeTanque(String placa) {
    _tanques.remove(placa);
    notifyListeners();
  }

  @override
  Empresa fromJson(Map<String, dynamic> json) => Empresa.fromJson(json);

  Empresa.fromJson(Map<String, dynamic> json)
      : cnpjCpf = json['cnpj'],
        razaoSocial = json['nome'],
        email = json['email'],
        telefones = List.from(json['telefones']),
        proprietario = json['proprietario'] == null ? null : Proprietario.fromJson(json['proprietario']),
        status = StatusEmpresa.values[json['status']];

  @override
  Map<String, dynamic> toJson() => {
        'cnpj': cnpjCpf,
        'nome': razaoSocial,
        'email': email,
        'telefones': telefones,
        'status': status.index,
        'proprietario': proprietario == null ? null : proprietario!.toJson(),
      };
}

enum StatusEmpresa {
  PreCadastro,
  Ativa,
  Inativa,
}
