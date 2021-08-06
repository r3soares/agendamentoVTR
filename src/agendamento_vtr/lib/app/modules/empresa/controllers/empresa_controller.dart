import 'package:agendamento_vtr/app/modules/tanque/models/empresa.dart';
import 'package:agendamento_vtr/app/repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class EmpresaController extends ChangeNotifier {
  final repo = Modular.get<Repository>();
  Empresa _empresa = Empresa();
  bool _isSalvo = false;

  Empresa get empresa => _empresa;
  bool get isSalvo => _isSalvo;
  set empresa(Empresa value) => {
        _empresa = value,
        _isSalvo = false,
        notifyListeners(),
      };
  salvaEmpresa() {
    repo.salvaEmpresa(_empresa);
    _isSalvo = true;
    notifyListeners();
  }

  Empresa? findEmpresa({String? cnpj}) {
    if (cnpj != null) return repo.findEmpresa(cnpj);
    return _empresa.cnpj != '' ? repo.findEmpresa(_empresa.cnpj) : null;
  }
}
