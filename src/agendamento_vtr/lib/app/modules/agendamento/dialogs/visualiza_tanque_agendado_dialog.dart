import 'package:agendamento_vtr/app/behaviors/custom_scroll_behavior.dart';
import 'package:agendamento_vtr/app/domain/constantes.dart';
import 'package:agendamento_vtr/app/models/compartimento.dart';
import 'package:agendamento_vtr/app/models/empresa.dart';
import 'package:agendamento_vtr/app/models/tanque.dart';
import 'package:agendamento_vtr/app/modules/agendamento/dialogs/pesquisa_empresa_dialog.dart';
import 'package:agendamento_vtr/app/modules/agendamento/models/tanque_agendado.dart';
import 'package:agendamento_vtr/app/repositories/repository_tanque_agendado.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class VisualizaTanqueAgendadoDialog extends StatelessWidget {
  final TanqueAgendado tAgendado;
  final RepositoryTanqueAgendado repoTa = Modular.get<RepositoryTanqueAgendado>();
  final ScrollController scrollControlller = ScrollController();

  VisualizaTanqueAgendadoDialog(this.tAgendado);

  @override
  Widget build(BuildContext context) {
    Tanque tanque = tAgendado.tanque;
    final data = Constants.formatoData.format(tanque.dataRegistro);
    return Dialog(
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        controller: scrollControlller,
        child: Container(
          width: 900,
          height: 700,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                flex: 1,
                child: Container(
                  padding: EdgeInsets.all(12),
                  alignment: Alignment.topCenter,
                  child: Text(
                    tAgendado.tanque.placaFormatada,
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ),
              Flexible(
                flex: 2,
                child: Column(
                  children: [
                    buildTitulo('Empresas associadas ao veículo'),
                    Card(
                      elevation: 4,
                      shadowColor: Colors.black,
                      child: Column(
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
                      ),
                    ),
                  ],
                ),
              ),
              Flexible(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    buildTitulo('Dados do tanque'),
                    Expanded(
                      child: Card(
                        elevation: 4,
                        shadowColor: Colors.black,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Flexible(child: buildCompatimentosWidget(tanque.compartimentos)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Flexible(
                flex: 2,
                child: Column(
                  children: [
                    buildTitulo('Status'),
                    Card(
                      elevation: 4,
                      shadowColor: Colors.black,
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                child: const Text(
                                  'Confirmação ',
                                  style: TextStyle(fontSize: 18),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.all(8),
                                child: buildStatusConfirmacao(),
                              )
                            ],
                          ),
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                child: const Text(
                                  'Pagamento',
                                  style: TextStyle(fontSize: 18),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.all(8),
                                child: buildStatusPagamento(),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Flexible(
                flex: 1,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    buildTitulo('Agendamentos'),
                    buildUltimoAgendamentoWidget(),
                  ],
                ),
              ),
              Flexible(
                flex: 1,
                child: Container(
                  alignment: Alignment.bottomRight,
                  padding: EdgeInsets.only(top: 12, right: 8, bottom: 8),
                  child: Text(
                    'Tanque cadastrado em $data',
                    style: TextStyle(fontSize: 10),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTitulo(String texto) {
    return Container(
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.all(8),
        child: Text(
          "$texto",
          style: TextStyle(fontSize: 20),
        ));
  }

  Widget buildCompatimentosWidget(List<Compartimento> compartimentos) {
    if (compartimentos.isEmpty) {
      return TextButton(
        onPressed: () => {},
        child: Text(
          'Sem compartimentos cadastrados',
          style: TextStyle(fontSize: 18, color: Colors.blueAccent),
        ),
      );
    }
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(
          flex: 1,
          child: Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.all(8),
            child: Text(
              'Compartimentos\n${tAgendado.tanque.capacidadeTotal} L',
              textAlign: TextAlign.center,
            ),
          ),
        ),
        Expanded(flex: 4, child: buildListaCompartimentos(compartimentos)),
      ],
    );
  }

  Widget buildListaCompartimentos(List<Compartimento> compartimentos) {
    return ScrollConfiguration(
      behavior: CustomScrollBehavior(),
      child: ListView.builder(
          itemExtent: 80,
          physics: const ClampingScrollPhysics(),
          controller: scrollControlller,
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemCount: compartimentos.length,
          itemBuilder: (BuildContext context, int i) {
            Compartimento c = compartimentos.elementAt(i);
            return Card(
              elevation: 4,
              shadowColor: Colors.black,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('${c.capacidade} L'),
                    c.setas > 0 ? Text('${c.setas} SS') : const SizedBox.shrink(),
                  ],
                ),
              ),
            );
          }),
    );
  }

  Widget buildUltimoAgendamentoWidget() {
    return TextButton(
      child: Text(
        'Visualizar histórico de agendamentos',
        style: TextStyle(color: Colors.blueAccent),
      ),
      onPressed: () => {},
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

  Widget buildStatusConfirmacao() {
    var statusC = getStatusConfirmacao();

    return TextButton(
        onPressed: () => {},
        child: Text(
          statusC.key,
          style: TextStyle(color: statusC.value),
        ));
  }

  Widget buildStatusPagamento() {
    var statusP = getStatusPagamento(tAgendado.statusPagamento);
    return TextButton(
        onPressed: () => {},
        child: Text(
          statusP.key,
          style: TextStyle(color: statusP.value),
        ));
  }

  Future _salvaAlteracoes(BuildContext context, TanqueAgendado tAgendado) async {
    try {
      await repoTa.save(tAgendado);
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Não foi possível salvar as alterações')));
    }
  }

  MapEntry<String, Color> getStatusConfirmacao() {
    var status = tAgendado.statusConfirmacao;
    switch (status) {
      case StatusConfirmacao.PreAgendado:
        return MapEntry('Fila de Espera', Colors.deepPurple);
      case StatusConfirmacao.NaoConfirmado:
        return MapEntry('Aguardando confirmação para o dia ${tAgendado.agenda}', Colors.orange);
      case StatusConfirmacao.Confirmado:
        return MapEntry('Confirmado para o dia ${tAgendado.agenda}', Colors.green);
      case StatusConfirmacao.Reagendado:
        return MapEntry('Reagendado para o dia ${tAgendado.agenda}', Colors.blue.shade900);
      case StatusConfirmacao.Cancelado:
        return MapEntry('Cancelado para o dia ${tAgendado.agenda}', Colors.red);
    }
  }

  MapEntry<String, Color> getStatusPagamento(StatusPagamento status) {
    switch (status) {
      case StatusPagamento.Atrasado:
        return MapEntry('Atrasado', Colors.red.shade900);
      case StatusPagamento.Confirmado:
        return MapEntry('Confirmado', Colors.green);
      case StatusPagamento.Pendente:
        return MapEntry('Pendente', Colors.orange);
    }
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
