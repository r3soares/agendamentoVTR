import 'package:agendamento_vtr/app/domain/erros.dart';
import 'package:agendamento_vtr/app/models/bloc.dart';
import 'package:agendamento_vtr/app/models/model_base.dart';
import 'package:agendamento_vtr/app/modules/agendamento/controllers/agendaController.dart';
import 'package:agendamento_vtr/app/modules/agendamento/models/agenda.dart';
import 'package:agendamento_vtr/app/modules/agendamento/models/agenda_model.dart';
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

  getAgendaNova(String dia) async {
    print('Agenda nova $dia');
    blocAgendaNova.execute(() => _repoAgenda.getOrCreate(dia));
  }

  getAgendaAntiga(String dia) async {
    blocAgendaAntiga.execute(() => _repoAgenda.get(dia), delay: Duration(seconds: 2));
  }

  reagenda(TanqueAgendado taVelho, TanqueAgendado taNovo, Agenda aVelha, Agenda aNova) async {
    taVelho.statusConfirmacao = StatusConfirmacao.Reagendado;
    taNovo.agendaAnterior = taVelho.agenda;
    aVelha.tanquesAgendados.remove(taVelho.id);
    aNova.tanquesAgendados.add(taNovo.id);
    setLoading(true);
    try {
      await _repoAt.save(taVelho);
      await _repoAt.save(taNovo);
      await _repoAgenda.save(aVelha);
      await _repoAgenda.save(aNova);
      _controller.notificaDiaAtualizado(AgendaModel(aVelha, List.empty()));
      _controller.notificaDiaAtualizado(AgendaModel(aNova, List.empty()));
      blocReagenda.update(true);
    } on Falha catch (e) {
      setError(e);
    } finally {
      setLoading(false);
    }
  }
}
