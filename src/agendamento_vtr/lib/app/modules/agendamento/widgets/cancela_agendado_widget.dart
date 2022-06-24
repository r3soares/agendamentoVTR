import 'package:agendamento_vtr/app/modules/agendamento/controllers/agendaController.dart';
import 'package:agendamento_vtr/app/modules/agendamento/models/tanque_agendado.dart';
import 'package:agendamento_vtr/app/repositories/repository_tanque_agendado.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_modular/flutter_modular.dart';

class CancelaAgendadoWidget extends StatelessWidget {
  final TanqueAgendado tAgendado;
  final controller = Modular.get<AgendaController>();
  final repoTa = Modular.get<RepositoryTanqueAgendado>();
  CancelaAgendadoWidget(this.tAgendado);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Retornar à lista de espera?'),
      content: Text(
          'O Veículo ${tAgendado.tanque.placaFormatada} retornará a lista de tanques não agendados'),
      actions: <Widget>[
        TextButton(
          onPressed: () async => {
            _excluiTanqueAgendado(tAgendado),
            await _salvaAlteracoes(context, tAgendado),
            _notificaPendentes(tAgendado),
          },
          child: const Text('Sim'),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, 'Cancel'),
          child: const Text('Não'),
        ),
      ],
    );
  }

  void _notificaPendentes(TanqueAgendado ta) {
    var lista = controller.storePendentes.lastState.state;
    lista.add(ta);
    controller.notificaPendentes(lista);
  }

  void _excluiTanqueAgendado(TanqueAgendado ta) {
    ta.statusConfirmacao = StatusConfirmacao.PreAgendado;
    //repoTa.remove(tAgendado.id);
    //agenda.tanquesAgendados.remove(ta);
  }

  Future _salvaAlteracoes(
      BuildContext context, TanqueAgendado tAgendado) async {
    try {
      await repoTa.save(tAgendado);
      controller.notificaTanqueAgendadoAtualizado(tAgendado);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Não foi possível salvar as alterações')));
    }
  }
}
