import 'package:agendamento_vtr/app/domain/erros.dart';
import 'package:agendamento_vtr/app/models/bloc.dart';
import 'package:agendamento_vtr/app/models/model_base.dart';
import 'package:agendamento_vtr/app/modules/agendamento/controllers/agendaController.dart';
import 'package:agendamento_vtr/app/modules/agendamento/models/agenda.dart';
import 'package:agendamento_vtr/app/modules/agendamento/models/tanque_agendado.dart';
import 'package:agendamento_vtr/app/repositories/repository_agenda.dart';
import 'package:agendamento_vtr/app/repositories/repository_tanque_agendado.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_triple/flutter_triple.dart';

class ReagendaStore extends StreamStore<Falha, ModelBase> {
  final RepositoryAgenda _repoAgenda;
  final RepositoryTanqueAgendado _repoAt;
  final AgendaController _controller = Modular.get<AgendaController>();
  final Bloc blocAgendaNova = Bloc('');
  final Bloc blocReagenda = Bloc('');
  final Bloc blocAgendaAntiga = Bloc('');

  ReagendaStore(this._repoAgenda, this._repoAt) : super(ModelBase(null));

  @override
  destroy() {
    blocAgendaAntiga.destroy();
    blocAgendaNova.destroy();
    blocReagenda.destroy();
    return super.destroy();
  }

  getAgendaNova(String dia) async {
    //print('Agenda nova $dia');
    blocAgendaNova.execute(() => _repoAgenda.getOrCreate(dia));
  }

  getAgendaAntiga(String dia) async {
    blocAgendaAntiga.execute(() => _repoAgenda.get(dia), delay: Duration(seconds: 2));
  }

  reagenda(TanqueAgendado taVelho, TanqueAgendado taNovo, Agenda aVelha, Agenda aNova) async {
    taVelho.statusConfirmacao = StatusConfirmacao.Reagendado;
    taNovo.statusConfirmacao = StatusConfirmacao.NaoConfirmado;
    taNovo.agendaAnterior = taVelho.agenda;
    aVelha.tanquesAgendados.removeWhere((ta) => ta.id == taVelho.id);
    aNova.tanquesAgendados.add(taNovo);
    setLoading(true);
    try {
      await _repoAt.save(taVelho);
      await _repoAt.save(taNovo);
      await _repoAgenda.save(aVelha);
      await _repoAgenda.save(aNova);
      _controller.notificaDiaAtualizado(aVelha);
      _controller.notificaDiaAtualizado(aNova);
      blocReagenda.update(true, force: true);
    } on Falha catch (e) {
      setError(e);
    } finally {
      setLoading(false);
    }
  }
}
