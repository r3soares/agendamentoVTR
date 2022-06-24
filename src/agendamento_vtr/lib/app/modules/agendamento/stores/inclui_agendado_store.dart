import 'package:agendamento_vtr/app/domain/erros.dart';
import 'package:agendamento_vtr/app/domain/log.dart';
import 'package:agendamento_vtr/app/models/bloc.dart';
import 'package:agendamento_vtr/app/models/model_base.dart';
import 'package:agendamento_vtr/app/models/responsavel.dart';
import 'package:agendamento_vtr/app/models/tanque.dart';
import 'package:agendamento_vtr/app/modules/agendamento/controllers/agendaController.dart';
import 'package:agendamento_vtr/app/modules/agendamento/models/agenda.dart';
import 'package:agendamento_vtr/app/modules/agendamento/models/tanque_agendado.dart';
import 'package:agendamento_vtr/app/repositories/repository_agenda.dart';
import 'package:agendamento_vtr/app/repositories/repository_tanque_agendado.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_triple/flutter_triple.dart';
import 'package:collection/collection.dart';
import 'package:uuid/uuid.dart';

class IncluiAgendadoStore extends StreamStore<Falha, TanqueAgendado> {
  final RepositoryAgenda repoAgenda;
  final RepositoryTanqueAgendado repoAt;
  final AgendaController _controller = Modular.get<AgendaController>();
  final Bloc blocPesquisa = Bloc('');
  final Bloc blocAgenda = Bloc('');

  IncluiAgendadoStore(this.repoAgenda, this.repoAt)
      : super(TanqueAgendado(
            id: '',
            tanque: Tanque(),
            responsavel: Responsavel(Uuid().v1(), "")));

  @override
  Future destroy() {
    blocPesquisa.destroy();
    blocAgenda.destroy();
    return super.destroy();
  }

  void getVeiculo(String termo) async {
    setLoading(true);
    try {
      List<TanqueAgendado> tAgendados =
          _controller.storePendentes.lastState.state;
      TanqueAgendado? tEcontrado = tAgendados.firstWhereOrNull(
          (e) => e.tanque.codInmetro == termo || e.tanque.placa == termo);
      if (tEcontrado == null) {
        blocPesquisa.setError(NaoEncontrado('Veículo não localizado'));
        return;
      }
      blocPesquisa.update(tEcontrado, force: true);
    } on Falha catch (e) {
      blocPesquisa.setError(e);
    } finally {
      setLoading(false);
    }
  }

  agendaVeiculo(TanqueAgendado tAgendado) async {
    Log.message(this, 'Agendando ${tAgendado.tanque.placaFormatada}');
    setLoading(true);
    try {
      tAgendado.statusConfirmacao = StatusConfirmacao.NaoConfirmado;
      Agenda a = _controller.storeDiaAtualizado.lastState.state;
      a.tanquesAgendados.add(tAgendado);
      await repoAt.save(tAgendado);
      await repoAgenda.save(a);
      blocAgenda.update(ModelBase(tAgendado), force: true);
      _controller.notificaDiaAtualizado(a);

      var pendentes = _controller.storePendentes.lastState.state;
      pendentes.remove(tAgendado);
      _controller.notificaPendentes(pendentes);
    } on Falha catch (e) {
      blocAgenda.setError(e);
    } finally {
      setLoading(false);
    }
  }
}
