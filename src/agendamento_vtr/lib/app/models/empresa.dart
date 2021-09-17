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
  StatusEmpresa status = StatusEmpresa.Ativa;

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
  Empresa fromJson(Map<String, dynamic> json) {
    return Empresa.fromJson(json);
  }

  Empresa.fromJson(Map<String, dynamic> json)
      : cnpjCpf = json['Cnpj'],
        razaoSocial = json['Nome'],
        email = json['Email'],
        telefones = List.from(json['Telefones']),
        proprietario = json['Proprietario'] == null
            ? null
            : Proprietario.fromJson(json['Proprietario']),
        status = json['Status'];

  @override
  Map<String, dynamic> toJson() => {
        'Cnpj': cnpjCpf,
        'Nome': razaoSocial,
        'Email': email,
        'Telefones': telefones,
        'Status': status.index,
        'Proprietaro': proprietario == null ? null : proprietario!.toJson(),
      };
}

enum StatusEmpresa {
  PreCadastro,
  Ativa,
  Inativa,
}
