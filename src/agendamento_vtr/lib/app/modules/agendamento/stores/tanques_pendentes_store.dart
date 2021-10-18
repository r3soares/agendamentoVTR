import 'package:agendamento_vtr/app/domain/erros.dart';
import 'package:agendamento_vtr/app/models/bloc.dart';
import 'package:agendamento_vtr/app/models/model_base.dart';
import 'package:agendamento_vtr/app/repositories/repository_tanque.dart';
import 'package:agendamento_vtr/app/repositories/repository_tanque_agendado.dart';
import 'package:flutter_triple/flutter_triple.dart';

class TanquesPendentesStore extends StreamStore<Falha, ModelBase> {
  final RepositoryTanqueAgendado repoAt;
  final RepositoryTanque repoTanque;
  final Bloc blocTanquesPendentes = Bloc('');

  TanquesPendentesStore(this.repoAt, this.repoTanque) : super(ModelBase(null));

  @override
  Future destroy() {
    blocTanquesPendentes.destroy();
    return super.destroy();
  }

  void getTanquesPendentes() async {
    blocTanquesPendentes.execute(() => repoAt.findPendentes());
  }
}
