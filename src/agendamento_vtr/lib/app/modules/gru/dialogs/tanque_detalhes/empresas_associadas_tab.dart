import 'package:agendamento_vtr/app/models/empresa.dart';
import 'package:agendamento_vtr/app/models/tanque.dart';
import 'package:agendamento_vtr/app/modules/gru/dialogs/pesquisa_empresa_dialog.dart';
import 'package:agendamento_vtr/app/modules/gru/dialogs/tanque_detalhes/visualiza_tanque_dialog.dart';
import 'package:agendamento_vtr/app/repositories/repository_tanque.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class EmpresasAssociadasTab extends StatelessWidget {
  final Tanque tanque;
  final RepositoryTanque repo = Modular.get<RepositoryTanque>();

  EmpresasAssociadasTab(this.tanque);

  @override
  Widget build(BuildContext context) {
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
                tanque.proprietario == null
                    ? SizedBox.shrink()
                    : Flexible(flex: 1, child: buildBotoes(context, 'Proprietário')),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildBotoes(BuildContext context, String propOuResp) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ElevatedButton(
              onPressed: () => Modular.to.pushNamed('/empresa/cadastro', arguments: tanque.proprietario),
              child: Text('Alterar')),
          TextButton(
              onPressed: () async =>
                  {tanque.proprietario = null, await _salvaAlteracoes(context), atualizaDialog(context)},
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
      child: Row(
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: ListTile(
                    title: SelectableText(e.razaoSocial),
                    subtitle: Text('Razão Social'),
                  ),
                ),
                Expanded(
                  child: ListTile(
                    title: SelectableText(e.cnpjFormatado),
                    subtitle: Text(e.cnpjOuCpf),
                  ),
                ),
                Expanded(
                  child: ListTile(
                    title: SelectableText(e.email),
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
                          title: SelectableText(e.telefones[0]),
                          subtitle: Text('Telefone'),
                        ),
                      ),
              ],
            ),
          ),
          e.proprietario == null
              ? Expanded(child: SizedBox.shrink())
              : Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      ListTile(
                        title: SelectableText('${e.proprietario!.cod}'),
                        subtitle: Text('Código Proprietário'),
                      ),
                      ListTile(
                        title: SelectableText('${e.proprietario!.codMun}'),
                        subtitle: Text('Código Município'),
                      ),
                    ],
                  ),
                )
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
      builder: (_) => PesquisaEmpresaDialog('Empresa', tanque),
    ).then((_) async => {
          await _salvaAlteracoes(context),
          atualizaDialog(context),
        });
  }

  Future _salvaAlteracoes(BuildContext context) async {
    try {
      await repo.salvaTanque(tanque);
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
        builder: (_) => VisualizaTanqueDialog(tanque));
  }
}
