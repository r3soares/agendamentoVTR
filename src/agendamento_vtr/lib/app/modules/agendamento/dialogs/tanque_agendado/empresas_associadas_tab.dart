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
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Flexible(
                  flex: 1,
                  child: const Text(
                    'Proprietário ',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                Expanded(flex: 3, child: buildProprietarioWidget(context, tanque.proprietario, 'Proprietário')),
                Flexible(flex: 1, child: buildBotoes(context)),
              ],
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Flexible(
                  flex: 1,
                  child: const Text(
                    'Responsável pelo Agendamento',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                Expanded(flex: 3, child: buildProprietarioWidget(context, tAgendado.responsavel, 'Responsável')),
                Flexible(flex: 1, child: buildBotoes(context)),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget buildBotoes(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ElevatedButton(onPressed: () => {}, child: Text('Alterar')),
          TextButton(
              onPressed: () => {},
              child: Text(
                'Remover',
                style: TextStyle(color: Colors.red[800]),
              )),
        ],
      ),
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
        : buildCamposEmpresa(p);
  }

  buildCamposEmpresa(Empresa e) {
    return Card(
      elevation: 10,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            child: ListTile(
              title: Text(e.razaoSocial),
              subtitle: Text('Razão Social'),
            ),
          ),
          Expanded(
            child: ListTile(
              title: Text(e.cnpjFormatado),
              subtitle: Text(e.cnpjOuCpf),
            ),
          ),
          Expanded(
            child: ListTile(
              title: Text(e.email),
              subtitle: Text('E-mail'),
            ),
          ),
          e.telefones.isEmpty
              ? Expanded(
                  child: ListTile(
                    title: Text('Nenhum telefone cadastrado'),
                  ),
                )
              : Expanded(
                  child: ListTile(
                    title: Text(e.telefones[0]),
                    subtitle: Text('Telefone'),
                  ),
                ),
        ],
      ),
    );
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
