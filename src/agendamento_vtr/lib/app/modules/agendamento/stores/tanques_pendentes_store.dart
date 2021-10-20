import 'package:agendamento_vtr/app/domain/constantes.dart';
import 'package:agendamento_vtr/app/domain/erros.dart';
import 'package:agendamento_vtr/app/models/bloc.dart';
import 'package:agendamento_vtr/app/models/model_base.dart';
import 'package:agendamento_vtr/app/modules/agendamento/controllers/agendaController.dart';
import 'package:agendamento_vtr/app/modules/agendamento/models/agenda.dart';
import 'package:agendamento_vtr/app/modules/agendamento/models/blocAgendaModel.dart';
import 'package:agendamento_vtr/app/repositories/repository_tanque.dart';
import 'package:agendamento_vtr/app/repositories/repository_tanque_agendado.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_triple/flutter_triple.dart';

class TanquesPendentesStore extends StreamStore<Falha, ModelBase> {
  final RepositoryTanqueAgendado repoAt;
  final RepositoryTanque repoTanque;
  final AgendaController _controller = Modular.get<AgendaController>();
  final Bloc blocTanquesPendentes = Bloc('');
  final BlocAgendaModel blocDiaAtualizado = BlocAgendaModel(Agenda(Constants.formatoData.format(DateTime.now())));
  final List<Disposer> disposers = List.empty(growable: true);

  TanquesPendentesStore(this.repoAt, this.repoTanque) : super(ModelBase(null)) {
    final d1 = _controller.diaAtualizado.observer(
        onState: (aModel) => {
              //Log.message(this, 'Atualizou ${aModel.data}'),
              blocDiaAtualizado.update(aModel, force: true),
            });
    //Log.message(this, 'Hash Controller: ${_controller.hashCode}');
    disposers.add(d1);
  }

  @override
  Future destroy() {
    //Log.message(this, 'Destruindo');
    blocTanquesPendentes.destroy();
    blocDiaAtualizado.destroy();
    disposers.forEach((d) {
      d();
    });
    return super.destroy();
  }

  void getTanquesPendentes() async {
    //Log.message(this, 'Obtendo tanques pendentes...');
    blocTanquesPendentes.execute(() => repoAt.findPendentes());
  }
}
