import 'package:agendamento_vtr/app/domain/erros.dart';
import 'package:agendamento_vtr/app/models/tanque.dart';
import 'package:agendamento_vtr/app/repositories/repository_tanque.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_triple/flutter_triple.dart';

class TanqueStore extends StreamStore<Falha, List<Tanque>> {
  TanqueStore(List<Tanque> initialState) : super(initialState);
  final RepositoryTanque _repoTanque = Modular.get<RepositoryTanque>();

  getTanques() async {
    execute(() => _repoTanque.getTanques());
    //sTanque.execute(() => _repoTanque.getTanques());
  }
}
