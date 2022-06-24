import 'package:agendamento_vtr/app/domain/erros.dart';
import 'package:agendamento_vtr/app/models/responsavel.dart';
import 'package:agendamento_vtr/app/models/tanque.dart';
import 'package:agendamento_vtr/app/modules/agendamento/controllers/agendaController.dart';
import 'package:agendamento_vtr/app/modules/agendamento/models/tanque_agendado.dart';
import 'package:agendamento_vtr/app/modules/agendamento/stores/store_data.dart';
import 'package:agendamento_vtr/app/repositories/repository_tanque.dart';
import 'package:agendamento_vtr/app/repositories/repository_tanque_agendado.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_triple/flutter_triple.dart';
import 'package:uuid/uuid.dart';

class IncluiPendenteStore extends StreamStore<Falha, TanqueAgendado> {
  final RepositoryTanque repoTanque;
  final RepositoryTanqueAgendado repoAt;
  final AgendaController _controller = Modular.get<AgendaController>();
  final StoreData<Tanque> blocPesquisa = StoreData(Tanque());
  final StoreData<TanqueAgendado> blocAgenda = StoreData(TanqueAgendado(
      id: Uuid().v1(),
      tanque: Tanque(),
      responsavel: Responsavel(Uuid().v1(), "")));

  StoreData<List<TanqueAgendado>> get blocPendentes =>
      _controller.storePendentes;

  IncluiPendenteStore(this.repoTanque, this.repoAt)
      : super(TanqueAgendado(
            id: Uuid().v1(),
            tanque: Tanque(),
            responsavel: Responsavel(Uuid().v1(), "")));

  @override
  Future destroy() {
    blocPesquisa.destroy();
    blocAgenda.destroy();
    return super.destroy();
  }

  void filtraLista(String termo) async {
    setLoading(true);
    try {
      List<TanqueAgendado> tAgendados = await repoAt.findPendentes();
      if (tAgendados.isEmpty) return;
      if (termo.isNotEmpty)
        tAgendados.retainWhere((e) =>
            e.tanque.placa.startsWith(termo) ||
            e.tanque.codInmetro.startsWith(termo));
      _controller.notificaPendentes(tAgendados);
    } on Falha catch (e) {
      blocPendentes.setError(e);
    } finally {
      setLoading(false);
    }
  }

  void getVeiculoByInmetro(String termo) async {
    blocPesquisa.execute(() => repoTanque.getTanque(termo));
  }

  void getVeiculoByPlaca(String termo) async {
    blocPesquisa.execute(() => repoTanque.findTanqueByPlaca(termo));
  }

  agendaVeiculo(Tanque tanque, Responsavel resp) async {
    setLoading(true);
    try {
      TanqueAgendado ta =
          TanqueAgendado(id: Uuid().v1(), tanque: tanque, responsavel: resp);
      if (await repoAt.save(ta)) {
        blocAgenda.update(ta);
      } else {
        throw Falha('${ta.id} não salvou');
      }
    } on Falha catch (e) {
      blocAgenda.setError(e);
    } finally {
      setLoading(false);
    }
  }
}
