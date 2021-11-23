import 'package:agendamento_vtr/app/models/empresa.dart';
import 'package:agendamento_vtr/app/models/tanque.dart';
import 'package:agendamento_vtr/app/modules/agendamento/dialogs/pesquisa_empresa_dialog.dart';
import 'package:agendamento_vtr/app/modules/agendamento/dialogs/tanque_agendado/visualiza_tanque_agendado_dialog.dart';
import 'package:agendamento_vtr/app/modules/agendamento/models/tanque_agendado.dart';
import 'package:agendamento_vtr/app/repositories/repository_tanque_agendado.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class EmpresasAssociadasTab extends StatelessWidget {
  final TanqueAgendado tAgendado;
  final RepositoryTanqueAgendado repoTa = Modular.get<RepositoryTanqueAgendado>();

  EmpresasAssociadasTab(this.tAgendado);

  @override
  Widget build(BuildContext context) {
    Tanque tanque = tAgendado.tanque;
    return Column(
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              child: const Text(
                'Proprietário ',
                style: TextStyle(fontSize: 18),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(8),
              child: buildProprietarioWidget(context, tanque.proprietario, 'Proprietário'),
            )
          ],
        ),
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              child: const Text(
                'Responsável (Agendamento)',
                style: TextStyle(fontSize: 18),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(8),
              child: buildProprietarioWidget(context, tAgendado.responsavel, 'Responsável'),
            )
          ],
        )
      ],
    );
  }

  Widget buildProprietarioWidget(BuildContext context, Empresa? p, String proOuResp) {
    return p == null
        ? TextButton(
            onPressed: () => showDialogPesquisaEmpresa(context, proOuResp),
            child: Text(
              'Nenhum $proOuResp definido',
              style: TextStyle(fontSize: 18, color: Colors.blueAccent),
            ))
        : TextButton(
            onPressed: () => {},
            child: Text(
              '${p.razaoSocial}',
              style: TextStyle(fontSize: 18, color: Colors.blueAccent),
            ));
  }

  showDialogPesquisaEmpresa(BuildContext context, String propOuResp) {
    showDialog(
      barrierDismissible: true,
      barrierColor: Color.fromRGBO(0, 0, 0, .5),
      useSafeArea: true,
      context: context,
      builder: (_) => PesquisaEmpresaDialog(propOuResp, tAgendado),
    ).then((_) async => {
          await _salvaAlteracoes(context, tAgendado),
          atualizaDialog(context),
        });
  }

  Future _salvaAlteracoes(BuildContext context, TanqueAgendado tAgendado) async {
    try {
      await repoTa.save(tAgendado);
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Não foi possível salvar as alterações')));
    }
  }

  atualizaDialog(BuildContext context) {
    Modular.to.pop();
    showDialog(
        barrierDismissible: true,
        barrierColor: Color.fromRGBO(0, 0, 0, .5),
        useSafeArea: true,
        context: context,
        builder: (_) => VisualizaTanqueAgendadoDialog(tAgendado));
  }
}
