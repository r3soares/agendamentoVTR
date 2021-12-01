import 'package:agendamento_vtr/app/behaviors/custom_scroll_behavior.dart';
import 'package:agendamento_vtr/app/domain/constantes.dart';
import 'package:agendamento_vtr/app/domain/custo_compartimento.dart';
import 'package:agendamento_vtr/app/models/compartimento.dart';
import 'package:agendamento_vtr/app/models/tanque.dart';
import 'package:agendamento_vtr/app/modules/agendamento/dialogs/tanque_agendado/visualiza_tanque_agendado_dialog.dart';
import 'package:agendamento_vtr/app/modules/agendamento/models/tanque_agendado.dart';
import 'package:agendamento_vtr/app/modules/tanque/widgets/compartimento_form.dart';
import 'package:agendamento_vtr/app/repositories/repository_tanque.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class TanqueTab extends StatelessWidget {
  static const double LARGURA_MAXIMA_COMPONENTES = 300;
  final RepositoryTanque repoTanque = Modular.get<RepositoryTanque>();
  final TanqueAgendado tAgendado;
  final ScrollController scrollControlller = ScrollController();
  final CustoCompartimento custo = CustoCompartimento();
  TanqueTab(this.tAgendado);

  @override
  Widget build(BuildContext context) {
    var statusPagamento = getStatusPagamento(tAgendado.statusPagamento);
    Tanque tanque = tAgendado.tanque;
    return tanque.compartimentos.isEmpty
        ? Center(
            child: TextButton(
              child: Text(
                'Sem compartimentos cadastrados',
                style: TextStyle(fontSize: 20),
              ),
              onPressed: () => openCompartimentoForm(context),
            ),
          )
        : Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 200, child: buildListaCompartimentos(tanque.compartimentos)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Flexible(
                        child: Column(
                      children: [
                        ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: LARGURA_MAXIMA_COMPONENTES),
                          child: Card(
                            margin: const EdgeInsets.all(1),
                            child: ListTile(
                              title: Text('Capacidade'),
                              trailing: Text('${tanque.capacidadeTotal}L'),
                            ),
                          ),
                        ),
                        ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: LARGURA_MAXIMA_COMPONENTES),
                          child: Card(
                            margin: const EdgeInsets.all(1),
                            child: ListTile(
                              title: Text('Custo Verificação'),
                              subtitle: Text(
                                statusPagamento.key,
                                style: TextStyle(color: statusPagamento.value),
                              ),
                              trailing: Text(
                                'R\$${getCustoTotal(tanque.compartimentos)}',
                                style: TextStyle(color: Colors.red[800]),
                              ),
                            ),
                          ),
                        ),
                        ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: LARGURA_MAXIMA_COMPONENTES),
                          child: Card(
                            margin: const EdgeInsets.all(1),
                            child: ListTile(
                              title: Text('Tempo Estimado'),
                              trailing: Text('${tAgendado.tempoVerificacao} minutos'),
                            ),
                          ),
                        ),
                        ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: LARGURA_MAXIMA_COMPONENTES),
                          child: Card(
                            margin: const EdgeInsets.all(1),
                            child: ListTile(
                              title: Text('Inicial'),
                              trailing: Text(tAgendado.isNovo ? 'Sim' : 'Não'),
                            ),
                          ),
                        ),
                        ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: LARGURA_MAXIMA_COMPONENTES),
                          child: Card(
                            margin: const EdgeInsets.all(1),
                            child: ListTile(
                              title: Text('Bitrem'),
                              trailing: Text(tAgendado.bitremAgenda != null ? 'Sim' : 'Não'),
                            ),
                          ),
                        ),
                      ],
                    )),
                    Expanded(
                        child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Text(
                            'Compartimentos',
                            style: TextStyle(fontSize: 22),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton(onPressed: () => openCompartimentoForm(context), child: Text('Alterar')),
                            TextButton(
                              onPressed: () async => {
                                tanque.compartimentos.clear(),
                                await _salvaAlteracoes(context),
                                atualizaDialog(context),
                              },
                              child: Text('Remover', style: TextStyle(color: Colors.red[800])),
                            ),
                          ],
                        ),
                      ],
                    ))
                  ],
                ),
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Align(
                      alignment: Alignment.bottomRight,
                      child: Text('Registrado em: ${Constants.formatoData.format(tanque.dataRegistro)}')),
                ))
              ],
            ),
          );
  }

  Widget buildListaCompartimentos(List<Compartimento> compartimentos) {
    return ScrollConfiguration(
      behavior: CustomScrollBehavior(),
      child: ListView.builder(
          itemExtent: 150,
          physics: const ClampingScrollPhysics(),
          controller: scrollControlller,
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemCount: compartimentos.length,
          itemBuilder: (BuildContext context, int i) {
            Compartimento c = compartimentos.elementAt(i);
            return Card(
              elevation: 10,
              shadowColor: Colors.black,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text(
                      'C${c.pos}',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      '${c.capacidade}L',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(c.setas > 0 ? 'Setas: ${c.setas}' : 'Sem Setas'),
                  ),
                  Text(
                    'R\$${getCusto(c.capacidade, c.setas)}',
                    style: TextStyle(color: Colors.red[800]),
                  ),
                ],
              ),
            );
          }),
    );
  }

  double getCusto(int cap, int setas) {
    return custo.getCusto(cap, setas);
  }

  double getCustoTotal(List<Compartimento> compartimentos) {
    var capacidades = compartimentos.map((e) => e.capacidade).toList();
    int setas = compartimentos.fold(0, (p, e) => p + e.setas);
    return custo.getCustoTotal(capacidades, setas);
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

  openCompartimentoForm(BuildContext context) {
    CompartimentoForm form =
        CompartimentoForm(compartimentosPrevio: tAgendado.tanque.compartimentos, callback: atualizaCompartimento);
    showDialog(
      context: context,
      builder: (BuildContext context) => Center(
        child: SizedBox(
          width: 900,
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            form,
            ElevatedButton(
              onPressed: () => Modular.to.pop(),
              child: Text('Retornar'),
            ),
          ]),
        ),
      ),
    ).then((value) async => {
          await _salvaAlteracoes(context),
          atualizaDialog(context),
        });
  }

  atualizaCompartimento(List<Compartimento> compartimentos) {
    tAgendado.tanque.compartimentos.clear();
    tAgendado.tanque.compartimentos.addAll(compartimentos);
  }

  atualizaDialog(BuildContext context) {
    Modular.to.pop();
    showDialog(
        barrierDismissible: true,
        barrierColor: Color.fromRGBO(0, 0, 0, .5),
        useSafeArea: true,
        context: context,
        builder: (_) => VisualizaTanqueAgendadoDialog(
              tAgendado,
              index: 1,
            ));
  }

  _salvaAlteracoes(BuildContext context) async {
    try {
      await repoTanque.salvaTanque(tAgendado.tanque);
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Não foi possível salvar as alterações')));
    }
  }
}
