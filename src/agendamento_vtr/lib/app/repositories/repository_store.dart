import 'package:agendamento_vtr/app/repositories/repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class RepositoryStore extends ChangeNotifier {
  //0 -> Inicial
  //1 -> Adicionou Tanque
  //2 -> Removeu Tanque
  //3 -> Adicionou Empresa
  //4 -> Removeu Empresa
  int _status = 0;
  var _argStatus;

  final Repository _repository = Modular.get<Repository>();

  int get status => _status;
  get argStatus => _argStatus;

  addTanque(value) {
    _repository.addTanque(value);
    _status = 1;
    _argStatus = value;
    notifyListeners();
  }

  removeTanque(value) {
    _repository.removeTanque(value);
    _status = 2;
    _argStatus = value;
    notifyListeners();
  }

  addEmpresa(value) {
    _repository.salvaEmpresa(value);
    _status = 3;
    _argStatus = value;
    notifyListeners();
  }

  removeEmpresa(value) {
    _repository.removeEmpresa(value);
    _status = 4;
    _argStatus = value;
    notifyListeners();
  }
}
