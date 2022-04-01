import 'package:agendamento_vtr/app/domain/erros.dart';
import 'package:agendamento_vtr/app/models/tanque.dart';
import 'package:agendamento_vtr/app/repositories/repository_tanque.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_triple/flutter_triple.dart';

class TanqueStore extends StreamStore<Falha, List<Tanque?>> {
  TanqueStore(List<Tanque?> initialState) : super(initialState);
  final RepositoryTanque _repoTanque = Modular.get<RepositoryTanque>();

  getTanques(String placa1, String? placa2) async {
    setLoading(true);
    try {
      Tanque t1 = await _getTanque(placa1);
      Tanque t2 = await _getTanque(placa2);
      t1.placa = placa1;
      t2.placa = placa2 == null ? '' : placa2;
      update([t1, t2], force: true);
    } on Falha catch (e) {
      setError(e);
    } finally {
      setLoading(false);
    }
    //sTanque.execute(() => _repoTanque.getTanques());
  }

  Future<Tanque> _getTanque(String? placa) async {
    try {
      if (placa == null) return Tanque();
      return await _repoTanque.findTanqueByPlaca(placa);
    } on NaoEncontrado {
      return Tanque();
    }
  }
}
