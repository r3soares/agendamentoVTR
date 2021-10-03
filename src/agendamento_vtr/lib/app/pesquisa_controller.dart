import 'package:agendamento_vtr/app/modules/empresa/models/empresa_model.dart';
import 'package:agendamento_vtr/app/repositories/repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class PesquisaController extends ChangeNotifier {
  //0 -> sem pesquisa ativa
  //1 -> localizado
  //2 -> nao localizado
  int _status = 0;
  var _resultado;
  final _repository = Modular.get<Repository>();

  get resultado => _resultado;
  int get status => _status;

  Future<bool> pesquisaTanque(String termo) async {
    _status = 0;
    _resultado = null;
    print('Pesquisando $termo');
    var tanque = (await _repository.findTanqueByPlaca(termo)).model;
    if (tanque != null) {
      print('$termo encontrado');
      _resultado = tanque;
      _status = 1;
      notifyListeners();
      return true;
    }
    _status = 2;
    notifyListeners();
    return false;
  }

  Future<bool> pesquisaEmpresa(String termo) async {
    print('Pesquisando $termo');
    EmpresaModel empresaM = (await _repository.getEmpresa(termo)) as EmpresaModel;
    if (empresaM.model != null) {
      print('$termo encontrado');
      _resultado = empresaM.model;
      _status = 1;
      notifyListeners();
      return true;
    }
    _status = 2;
    notifyListeners();
    return false;
  }

  resetPesquisa() {
    _status = 0;
    _resultado = null;
    notifyListeners();
  }
}
