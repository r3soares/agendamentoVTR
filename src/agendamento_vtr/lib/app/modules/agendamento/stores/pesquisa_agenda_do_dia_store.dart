import 'package:agendamento_vtr/app/domain/erros.dart';
import 'package:agendamento_vtr/app/domain/log.dart';
import 'package:agendamento_vtr/app/models/model_base.dart';
import 'package:agendamento_vtr/app/models/tanque.dart';
import 'package:agendamento_vtr/app/modules/agendamento/controllers/agendaController.dart';
import 'package:agendamento_vtr/app/modules/agendamento/models/agenda.dart';
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
  PesquisaAgendaDoDiaStore(this.repoAgenda, this.repoAt) : super(TanqueAgendado(id: '', tanque: Tanque()));

  void getVeiculo(String termo) async {
    setLoading(true);
    try {
      List<TanqueAgendado> tAgendados = (await repoAt.findPendentes()).model;
      TanqueAgendado? tEcontrado =
          tAgendados.firstWhereOrNull((e) => e.tanque.codInmetro == termo || e.tanque.placa == termo);
      if (tEcontrado == null) {
        setError(NaoEncontrado('Veículo não localizado'));
        return;
      }
      update(tEcontrado);
    } on Falha catch (e) {
      setError(e);
    } finally {
      setLoading(false);
    }
  }

  agendaVeiculo(TanqueAgendado tAgendado) async {
    setLoading(true);
    try {
      tAgendado.statusConfirmacao = StatusConfirmacao.NaoConfirmado;
      Agenda a = _controller.diaSelecionado.state;
      a.tanquesAgendados.add(tAgendado);
      await repoAt.save(tAgendado);
      await repoAgenda.save(a);
      _controller.notificaDiaAtualizado(a);
    } on Falha catch (e) {
      setError(e);
    } finally {
      setLoading(false);
    }
  }
}
