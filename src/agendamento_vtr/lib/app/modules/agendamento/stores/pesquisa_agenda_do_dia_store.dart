import 'package:agendamento_vtr/app/domain/constantes.dart';
import 'package:agendamento_vtr/app/domain/erros.dart';
import 'package:agendamento_vtr/app/domain/log.dart';
import 'package:agendamento_vtr/app/models/bloc.dart';
import 'package:agendamento_vtr/app/models/model_base.dart';
import 'package:agendamento_vtr/app/models/tanque.dart';
import 'package:agendamento_vtr/app/modules/agendamento/controllers/agendaController.dart';
import 'package:agendamento_vtr/app/modules/agendamento/models/agenda.dart';
import 'package:agendamento_vtr/app/modules/agendamento/models/blocAgendaModel.dart';
import 'package:agendamento_vtr/app/modules/agendamento/models/tanque_agendado.dart';
import 'package:agendamento_vtr/app/repositories/repository_agenda.dart';
import 'package:agendamento_vtr/app/repositories/repository_tanque_agendado.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_triple/flutter_triple.dart';
import 'package:collection/collection.dart';

class PesquisaAgendaDoDiaStore extends StreamStore<Falha, TanqueAgendado> {
  final RepositoryAgenda repoAgenda;
  final RepositoryTanqueAgendado repoAt;
  final AgendaController _controller = Modular.get<AgendaController>();
  final Bloc blocPesquisa = Bloc('');
  final Bloc blocAgenda = Bloc('');

  PesquisaAgendaDoDiaStore(this.repoAgenda, this.repoAt) : super(TanqueAgendado(id: '', tanque: Tanque()));

  @override
  Future destroy() {
    blocPesquisa.destroy();
    blocAgenda.destroy();
    return super.destroy();
  }

  void getVeiculo(String termo) async {
    setLoading(true);
    try {
      List<TanqueAgendado> tAgendados = (await repoAt.findPendentes()).model;
      TanqueAgendado? tEcontrado =
          tAgendados.firstWhereOrNull((e) => e.tanque.codInmetro == termo || e.tanque.placa == termo);
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
      Agenda a = _controller.diaSelecionado.lastState.state;
      a.tanquesAgendados.add(tAgendado);
      await repoAt.save(tAgendado);
      await repoAgenda.save(a);
      blocAgenda.update(ModelBase(tAgendado), force: true);
      _controller.notificaDiaAtualizado(a);
    } on Falha catch (e) {
      blocAgenda.setError(e);
    } finally {
      setLoading(false);
    }
  }
}
