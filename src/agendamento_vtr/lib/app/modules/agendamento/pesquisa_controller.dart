import 'package:agendamento_vtr/app/repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_modular/flutter_modular.dart';

class PesquisaController extends ChangeNotifier {
  //0 -> sem pesquisa ativa
  //1 -> pesquisa ativa
  int _status = 0;
  var _resultado;
  final _repository = Modular.get<Repository>();

  get resultado => _resultado;
  int get status => _status;

  bool pesquisa(String termo) {
    print('Pesquisando $termo');
    var tanque = _repository.findTanque(termo);
    if (tanque != null) {
      print('$termo encontrado');
      _resultado = tanque;
      _status = 1;
      notifyListeners();
      return true;
    }
    return false;
  }

  resetPesquisa() {
    _status = 0;
    notifyListeners();
  }
}
