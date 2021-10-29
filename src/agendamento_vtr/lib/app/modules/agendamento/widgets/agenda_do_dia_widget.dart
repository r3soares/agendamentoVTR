import 'package:agendamento_vtr/app/behaviors/custom_scroll_behavior.dart';
import 'package:agendamento_vtr/app/domain/constantes.dart';
import 'package:agendamento_vtr/app/models/tanque.dart';
import 'package:agendamento_vtr/app/modules/agendamento/controllers/agendaController.dart';
import 'package:agendamento_vtr/app/modules/agendamento/dialogs/altera_status_agenda_dialog.dart';
import 'package:agendamento_vtr/app/modules/agendamento/dialogs/altera_status_dialog.dart';
import 'package:agendamento_vtr/app/modules/agendamento/dialogs/visualiza_tanque_dialog.dart';
import 'package:agendamento_vtr/app/modules/agendamento/models/agenda.dart';
import 'package:agendamento_vtr/app/modules/agendamento/models/tanque_agendado.dart';
import 'package:agendamento_vtr/app/modules/agendamento/widgets/inclui_agendado_widget.dart';
import 'package:agendamento_vtr/app/repositories/repository_agenda.dart';
import 'package:agendamento_vtr/app/repositories/repository_tanque_agendado.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class AgendaDoDiaWidget extends StatelessWidget {
  final Agenda agenda;
  final repoAgenda = Modular.get<RepositoryAgenda>();
  final repoTa = Modular.get<RepositoryTanqueAgendado>();
  final controller = Modular.get<AgendaController>();
  AgendaDoDiaWidget(this.agenda);

  Widget build(BuildContext context) {
    var statusAgenda = _getCorStatusAgenda(agenda.status);
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Text(
            'Agenda do dia ${agenda.data}',
            style: TextStyle(fontSize: 18),
          ),
        ),
        Expanded(
          flex: 1,
          child: TextButton(
            child: Text(
              statusAgenda.key,
              style: TextStyle(
                color: statusAgenda.value,
                fontSize: 20,
              ),
            ),
            onPressed: () => showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlteraStatusAgendaDialog(agenda);
                }).then((_) async => await _salvaAgenda(context)),
          ),
        ),
        agenda.status != StatusAgenda.Disponivel
            ? SizedBox.shrink()
            : Expanded(
                flex: 3,
                child: IncluiAgendadoWidget(),
              ),
        agenda.tanquesAgendados.isEmpty
            ? Expanded(
                flex: 6,
                child: Text('Sem veículos para este dia'),
              )
            : Expanded(
                flex: 6,
                child: ScrollConfiguration(
                  behavior: CustomScrollBehavior(),
                  child: ListView.builder(
                      shrinkWrap: true,
                      dragStartBehavior: DragStartBehavior.start,
                      scrollDirection: Axis.vertical,
                      itemCount: agenda.tanquesAgendados.length,
                      itemBuilder: (BuildContext ctx, int index) {
                        TanqueAgendado tAgendado = agenda.tanquesAgendados.elementAt(index);
                        final status = _getCorConfirmacao(tAgendado.statusConfirmacao);
                        final isNovo = _isNovo(tAgendado.isNovo);
                        Tanque tanque = tAgendado.tanque;
                        return Card(
                          elevation: 12,
                          child: ListTile(
                              leading: TextButton(
                                  onPressed: () => {
                                        showDialog(
                                            barrierDismissible: true,
                                            barrierColor: Color.fromRGBO(0, 0, 0, .5),
                                            useSafeArea: true,
                                            context: context,
                                            builder: (_) => VisualizaTanqueDialog(tanque)),
                                      },
                                  child: Icon(Icons.remove_red_eye)),
                              title: Row(children: [
                                Text(
                                  '${tanque.placaFormatada}',
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 20),
                                  child: Text(
                                    '${tanque.capacidadeTotal} L',
                                    style: TextStyle(fontSize: 12),
                                  ),
                                ),
                              ]),
                              subtitle: Text('Registrado em ${Constants.formatoData.format(tanque.dataRegistro)}'),
                              trailing: ConstrainedBox(
                                constraints: BoxConstraints.loose(Size(200, double.infinity)),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    TextButton(
                                        onPressed: () => showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlteraStatusDialog(tAgendado);
                                            }).then((_) async => await _salvaAlteracoes(context, tAgendado)),
                                        child: Icon(
                                          status.value,
                                          color: status.key,
                                        )),
                                    TextButton(
                                        onPressed: () => {
                                              tAgendado.isNovo = !tAgendado.isNovo,
                                              _salvaAlteracoes(context, tAgendado),
                                            },
                                        child: Text(
                                          'Zero',
                                          style: TextStyle(color: isNovo),
                                        )),
                                    TextButton(
                                        onPressed: () => {
                                              _excluiTanqueAgendado(tAgendado),
                                              _salvaAlteracoes(context, tAgendado),
                                              _notificaPendentes(tAgendado),
                                            },
                                        child: Icon(Icons.close)),
                                  ],
                                ),
                              )),
                        );
                      }),
                )),
      ],
    );
  }

  MapEntry<String, Color> _getCorStatusAgenda(StatusAgenda status) {
    switch (status) {
      case StatusAgenda.Cheia:
        return MapEntry('Cheia', Colors.red);
      case StatusAgenda.Disponivel:
        return MapEntry('Disponível', Colors.green);
      case StatusAgenda.Encerrada:
        return MapEntry('Encerrada', Colors.black);
      case StatusAgenda.Indisponivel:
        return MapEntry('Indisponível', Colors.black);
    }
  }

  MapEntry<Color, IconData> _getCorConfirmacao(StatusConfirmacao status) {
    switch (status) {
      case StatusConfirmacao.PreAgendado:
        return MapEntry(Colors.deepPurple, Icons.help_outline);
      case StatusConfirmacao.NaoConfirmado:
        return MapEntry(Colors.orange, Icons.info_outline);
      case StatusConfirmacao.Confirmado:
        return MapEntry(Colors.green, Icons.check_circle_outline);
      case StatusConfirmacao.Reagendado:
        return MapEntry(Colors.blue.shade900, Icons.outbond_outlined);
      case StatusConfirmacao.Cancelado:
        return MapEntry(Colors.red, Icons.cancel_outlined);
    }
  }

  Color _isNovo(bool value) {
    return value ? Colors.yellow.shade800 : Colors.grey;
  }

  Future _salvaAlteracoes(BuildContext context, TanqueAgendado tAgendado) async {
    try {
      await repoTa.save(tAgendado);
      await repoAgenda.save(agenda);
      controller.notificaDiaAtualizado(agenda);
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Não foi possível salvar as alterações')));
    }
  }

  Future _salvaAgenda(BuildContext context) async {
    try {
      await repoAgenda.save(agenda);
      controller.notificaDiaAtualizado(agenda);
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Não foi possível salvar as alterações')));
    }
  }

  void _notificaPendentes(TanqueAgendado ta) {
    var lista = controller.storePendentes.lastState.state;
    lista.add(ta);
    controller.notificaPendentes(lista);
  }

  void _excluiTanqueAgendado(TanqueAgendado ta) {
    ta.statusConfirmacao = StatusConfirmacao.PreAgendado;
    agenda.tanquesAgendados.remove(ta);
  }
}
