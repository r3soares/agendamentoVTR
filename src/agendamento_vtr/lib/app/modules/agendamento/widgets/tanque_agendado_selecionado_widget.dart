import 'package:agendamento_vtr/app/behaviors/custom_scroll_behavior.dart';
import 'package:agendamento_vtr/app/domain/constantes.dart';
import 'package:agendamento_vtr/app/models/tanque.dart';
import 'package:agendamento_vtr/app/modules/agendamento/controllers/agendaController.dart';
import 'package:agendamento_vtr/app/modules/agendamento/dialogs/tanque_agendado/visualiza_tanque_agendado_dialog.dart';
import 'package:agendamento_vtr/app/modules/agendamento/models/tanque_agendado.dart';
import 'package:agendamento_vtr/app/modules/agendamento/widgets/cancela_agendado_widget.dart';
import 'package:agendamento_vtr/app/modules/agendamento/widgets/color_popup_widget.dart';
import 'package:agendamento_vtr/app/repositories/repository_tanque_agendado.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class TanqueAgendadoSelecionadoWidget extends StatelessWidget {
  static const double LARGURA_MAXIMA_COMPONENTES = 300;
  final TanqueAgendado tAgendado;
  final repoTa = Modular.get<RepositoryTanqueAgendado>();
  final controller = Modular.get<AgendaController>();
  final ScrollController scrollController = ScrollController();
  final ScrollController scrollControllerLateral = ScrollController();
  TanqueAgendadoSelecionadoWidget(this.tAgendado);

  Widget build(BuildContext context) {
    return ScrollConfiguration(
      behavior: CustomScrollBehavior(),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.max,
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Column(
                              children: [
                                Text(tAgendado.tanque.placa,
                                    style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 2,
                                        color: Color(tAgendado.statusCor))),
                                Text(
                                  '${tAgendado.tanque.capacidadeTotal}L ${tAgendado.tanque.resumoCompartimento}',
                                  style: TextStyle(fontSize: 18),
                                ),
                                Text(_exibePropResp())
                              ],
                            ),
                          ],
                        ),
                        TextButton(
                          child: Text(
                            (tAgendado.agenda ?? 'Não Agendado') + '    1°',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 20),
                          ),
                          onPressed: () => {},
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                      flex: 2,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(
                                  tooltip: 'Alterar cor',
                                  color: Colors.black45,
                                  constraints: const BoxConstraints.tightFor(
                                      width: 20, height: 36),
                                  iconSize: 18,
                                  splashRadius: 8,
                                  onPressed: () async =>
                                      await _alteraCor(context, tAgendado),
                                  icon: FaIcon(
                                    FontAwesomeIcons.brush,
                                    color: Color(tAgendado.statusCor),
                                    semanticLabel: 'Altera cor da etiqueta',
                                  )),
                              IconButton(
                                  tooltip: 'Editar veículo',
                                  splashRadius: 15,
                                  onPressed: () => {},
                                  icon: Icon(
                                    Icons.edit,
                                    color: Colors.blue,
                                  )),
                              IconButton(
                                  tooltip: 'Cancelar agendamento',
                                  splashRadius: 5,
                                  onPressed: () => {
                                        showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return CancelaAgendadoWidget(
                                                  tAgendado);
                                            }),
                                      },
                                  icon: Icon(
                                    Icons.close,
                                    color: Colors.red[800],
                                  )),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(
                                  color: Colors.black45,
                                  constraints: const BoxConstraints.tightFor(
                                      width: 20, height: 36),
                                  iconSize: 18,
                                  splashRadius: 8,
                                  onPressed: () async =>
                                      await _alteraCor(context, tAgendado),
                                  icon: FaIcon(
                                    FontAwesomeIcons.p,
                                    color: Color(tAgendado.statusCor),
                                    semanticLabel: 'Altera cor da etiqueta',
                                  )),
                              IconButton(
                                  color: Colors.black45,
                                  constraints: const BoxConstraints.tightFor(
                                      width: 20, height: 36),
                                  iconSize: 18,
                                  splashRadius: 8,
                                  onPressed: () async =>
                                      await _alteraCor(context, tAgendado),
                                  icon: FaIcon(
                                    FontAwesomeIcons.a,
                                    color: Color(tAgendado.statusCor),
                                    semanticLabel: 'Altera cor da etiqueta',
                                  )),
                              IconButton(
                                  color: Colors.black45,
                                  constraints: const BoxConstraints.tightFor(
                                      width: 20, height: 36),
                                  iconSize: 18,
                                  splashRadius: 8,
                                  onPressed: () async =>
                                      await _alteraCor(context, tAgendado),
                                  icon: FaIcon(
                                    FontAwesomeIcons.r,
                                    color: Color(tAgendado.statusCor),
                                    semanticLabel: 'Altera cor da etiqueta',
                                  )),
                              IconButton(
                                  color: Colors.black45,
                                  constraints: const BoxConstraints.tightFor(
                                      width: 20, height: 36),
                                  iconSize: 18,
                                  splashRadius: 8,
                                  onPressed: () async =>
                                      await _alteraCor(context, tAgendado),
                                  icon: FaIcon(
                                    FontAwesomeIcons.e,
                                    color: Color(tAgendado.statusCor),
                                    semanticLabel: 'Altera cor da etiqueta',
                                  )),
                            ],
                          ),
                          TextFormField(
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            textCapitalization: TextCapitalization.characters,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ],
                      ))
                ],
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: Text('Município:'),
                  title: SelectableText('5269   -   Itajaí'),
                ),
                ListTile(
                  leading: Text('Proprietário:'),
                  title: SelectableText(
                      '366   -   01.866.527/0001-56   -   Fulano Belchior'),
                ),
                Text('Serviços....'),
                ListTile(
                  title: SelectableText('N° Inmetro: 65D85'),
                  leading: IconButton(
                    iconSize: 16,
                    icon: Icon(Icons.copy),
                    onPressed: () => {},
                  ),
                ),
                ListTile(
                  leading: Text('Responsável:'),
                  title: SelectableText('Jair Ribeiro Brasil'),
                ),
                ListTile(
                  leading: Text('Organização:'),
                  title: SelectableText('RodoAbril Ribeiro Brasil'),
                ),
                ListTile(
                  leading: Text('E-mails:'),
                  title: SelectableText(
                      'rodoabril@rodoabril.com.br | rodoabril2@rodoabril.com.br | rodoabril3@rodoabril.com.br'),
                ),
              ],
            )
            // ConstrainedBox(
            //   constraints:
            //       const BoxConstraints(maxWidth: LARGURA_MAXIMA_COMPONENTES),
            //   child: Card(
            //     margin: const EdgeInsets.all(1),
            //     child: ListTile(
            //         title: Text('Agendamento'),
            //         subtitle: Text(
            //           tAgendado.agenda ?? 'Não Agendado',
            //         ),
            //         trailing: ElevatedButton(
            //           child: Text('Alterar'),
            //           onPressed: () => {},
            //         )),
            //   ),
            // ),
            // Center(
            //   child: Padding(
            //     padding: const EdgeInsets.all(8),
            //     child: SingleChildScrollView(
            //       controller: scrollControllerLateral,
            //       scrollDirection: Axis.horizontal,
            //       child: SizedBox(
            //         width: 600,
            //         child: tAgendado.bitremAgenda == null
            //             ? Card(elevation: 12, child: cardWidget(context))
            //             : Card(
            //                 elevation: 12,
            //                 child: Column(
            //                   children: [
            //                     cardWidget(context),
            //                     getBitrem(context, tAgendado.bitremAgenda!),
            //                   ],
            //                 )),
            //       ),
            //     ),
            //   ),
            // )
          ],
        ),
      ),
    );
  }

  Widget getBitrem(BuildContext context, String bitrem) {
    return cardWidget(context);
  }

  Widget cardWidget(BuildContext context) {
    //final status = _getCorConfirmacao(tAgendado.statusConfirmacao);
    final isInicial = _isInicial(tAgendado.isNovo);
    final isBitrem = _isInicial(tAgendado.bitremAgenda != null);
    Tanque tanque = tAgendado.tanque;
    return ListTile(
        leading: IconButton(
            splashRadius: 5,
            onPressed: () => {
                  showDialog(
                      barrierDismissible: true,
                      barrierColor: Color.fromRGBO(0, 0, 0, .5),
                      useSafeArea: true,
                      context: context,
                      builder: (_) => VisualizaTanqueAgendadoDialog(tAgendado)),
                },
            icon: Icon(
              Icons.remove_red_eye,
              color: Theme.of(context).primaryColor,
            )),
        title: Row(mainAxisSize: MainAxisSize.min, children: [
          Text(
            '${tanque.placaFormatada}',
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Text(
              '${tanque.capacidadeTotal} L',
              style: TextStyle(fontSize: 12),
            ),
          ),
        ]),
        subtitle: Text(
            'Registrado em ${Constants.formatoData.format(tanque.dataRegistro)}'),
        trailing: ConstrainedBox(
          constraints: BoxConstraints.loose(Size(300, double.infinity)),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              // TextButton(
              //     onPressed: () => showDialog(
              //             context: context,
              //             builder: (BuildContext context) {
              //               return AlteraStatusDialog(tAgendado);
              //             })
              //         .then((_) async =>
              //             await _salvaAlteracoes(context, tAgendado)),
              //     child: Text(
              //       '${status.key}',
              //       style: TextStyle(color: status.value),
              //     )),
              TextButton(
                  onPressed: () => {
                        tAgendado.isNovo = !tAgendado.isNovo,
                        _salvaAlteracoes(context, tAgendado),
                      },
                  child: Text(
                    'Inicial',
                    style: TextStyle(color: isInicial),
                  )),
              TextButton(
                  onPressed: () => showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return SizedBox.shrink();
                        // return SetBitremDialog(
                        //     tAgendado, agenda.tanquesAgendados);
                      })
                  // .then((_) async =>
                  //     await _salvaAlteracoes(context, tAgendado)),
                  ,
                  child: Text(
                    'Bitrem',
                    style: TextStyle(color: isBitrem),
                  )),
              IconButton(
                  splashRadius: 5,
                  onPressed: () => {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('Deseja remover o agendamento?'),
                                content: Text(
                                    'O Veículo ${tAgendado.tanque.placaFormatada} retornará a lista de tanques não agendados'),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () async => {
                                      _excluiTanqueAgendado(tAgendado),
                                      await _salvaAlteracoes(
                                          context, tAgendado),
                                      _notificaPendentes(tAgendado),
                                    },
                                    child: const Text('Sim'),
                                  ),
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context, 'Cancel'),
                                    child: const Text('Não'),
                                  ),
                                ],
                              );
                            }),
                      },
                  icon: Icon(
                    Icons.close,
                    color: Colors.red[800],
                  )),
            ],
          ),
        ));
  }

  // MapEntry<String, Color> _getCorStatusAgenda(StatusAgenda status) {
  //   switch (status) {
  //     case StatusAgenda.Cheia:
  //       return MapEntry('Cheia', Colors.red);
  //     case StatusAgenda.Disponivel:
  //       return MapEntry('Disponível', Colors.green);
  //     case StatusAgenda.Encerrada:
  //       return MapEntry('Encerrada', Colors.black);
  //     case StatusAgenda.Indisponivel:
  //       return MapEntry('Indisponível', Colors.black);
  //   }
  // }

  // MapEntry<String, Color> _getCorConfirmacao(StatusConfirmacao status) {
  //   switch (status) {
  //     case StatusConfirmacao.PreAgendado:
  //       return MapEntry('Pré Agendado', Colors.deepPurple);
  //     case StatusConfirmacao.NaoConfirmado:
  //       return MapEntry('Não Confirmado', Colors.orange);
  //     case StatusConfirmacao.Confirmado:
  //       return MapEntry('Confirmado', Colors.green);
  //     case StatusConfirmacao.Reagendado:
  //       return MapEntry('Reagendado', Colors.blue.shade900);
  //     case StatusConfirmacao.Cancelado:
  //       return MapEntry('Cancelado', Colors.red);
  //   }
  // }

  Color _isInicial(bool value) {
    return value ? Colors.yellow.shade800 : Colors.grey;
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

  Future _salvaTAgendado(BuildContext context) async {
    try {
      await repoTa.save(tAgendado);
      controller.notificaTanqueAgendadoAtualizado(tAgendado);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Não foi possível salvar as alterações')));
    }
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

  Future _showPopupColor(BuildContext context) async {
    return await showDialog<Color>(
        context: context,
        builder: (BuildContext context) {
          return ColorPopupWidget();
        });
  }

  _alteraCor(BuildContext context, TanqueAgendado ta) async {
    Color cor = await _showPopupColor(context) ?? Color(ta.statusCor);
    //print(cor);
    ta.statusCor = cor.value;
    await repoTa.save(ta);
    controller.notificaTanqueAgendadoAtualizado(ta);
    //controller.notifyPropertyChangedListeners(property)
  }

  _exibePropResp() {
    var tanque = tAgendado.tanque;
    var prop = tanque.proprietario == null
        ? 'Sem proprietário associado'
        : tanque.proprietario!.razaoSocial;
    return '$prop (${tAgendado.responsavel.apelido})';
  }
}
