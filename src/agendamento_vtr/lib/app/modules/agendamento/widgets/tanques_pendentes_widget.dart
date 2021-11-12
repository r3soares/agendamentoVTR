import 'package:agendamento_vtr/app/behaviors/custom_scroll_behavior.dart';
import 'package:agendamento_vtr/app/domain/erros.dart';
import 'package:agendamento_vtr/app/models/tanque.dart';
import 'package:agendamento_vtr/app/modules/agendamento/controllers/agendaController.dart';
import 'package:agendamento_vtr/app/modules/agendamento/dialogs/visualiza_tanque_agendado_dialog.dart';
import 'package:agendamento_vtr/app/modules/agendamento/models/agenda.dart';
import 'package:agendamento_vtr/app/modules/agendamento/models/tanque_agendado.dart';
import 'package:agendamento_vtr/app/modules/agendamento/widgets/inclui_pendente_widget.dart';
import 'package:agendamento_vtr/app/repositories/repository_agenda.dart';
import 'package:agendamento_vtr/app/repositories/repository_tanque_agendado.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:intl/intl.dart';

class TanquesPendentesWidget extends StatelessWidget {
  final List<TanqueAgendado> pendentes;
  final formatoData = 'dd/MM/yy HH:mm';
  final ScrollController scrollController = ScrollController();
  final repoAgenda = Modular.get<RepositoryAgenda>();
  final repoTa = Modular.get<RepositoryTanqueAgendado>();
  final controller = Modular.get<AgendaController>();
  TanquesPendentesWidget(this.pendentes);

  @override
  Widget build(BuildContext context) {
    pendentes.sort((a, b) => a.dataRegistro.compareTo(b.dataRegistro));
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Text(
            '${pendentes.length} Tanques não agendados',
            style: TextStyle(fontSize: 18),
          ),
        ),
        Expanded(
          flex: 1,
          child: IncluiPendenteWidget(),

          ///Para incluir tanque
        ),
        pendentes.isNotEmpty
            ? Expanded(
                flex: 4,
                child: ScrollConfiguration(
                  behavior: CustomScrollBehavior(),
                  child: ListView.builder(
                    itemExtent: 90,
                    cacheExtent: 900,
                    physics: const ClampingScrollPhysics(),
                    controller: scrollController,
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    itemCount: pendentes.length,
                    itemBuilder: (BuildContext context, int index) {
                      Tanque t = pendentes.elementAt(index).tanque;
                      final data = DateFormat(formatoData).format(t.dataRegistro);
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Card(
                          elevation: 12,
                          child: ListTile(
                              leading: IconButton(
                                splashRadius: 5,
                                icon: Icon(
                                  Icons.remove_red_eye,
                                  color: Theme.of(context).primaryColor,
                                ),
                                onPressed: () => {
                                  showDialog(
                                      barrierDismissible: true,
                                      barrierColor: Color.fromRGBO(0, 0, 0, .5),
                                      useSafeArea: true,
                                      context: context,
                                      builder: (_) => VisualizaTanqueAgendadoDialog(pendentes.elementAt(index))),
                                },
                              ),
                              title: Row(mainAxisSize: MainAxisSize.min, children: [
                                Text(
                                  t.placa.replaceRange(3, 3, '-'),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: Text(
                                    '${t.capacidadeTotal.toString()}L (${t.compartimentos.length}C ${t.totalSetas}S)',
                                    style: TextStyle(fontSize: 12),
                                  ),
                                ),
                              ]),
                              subtitle: Text('$data'),
                              trailing: ConstrainedBox(
                                constraints: BoxConstraints.loose(Size(230, double.infinity)),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    TextButton(
                                      child: const Text('Agendar'),
                                      onPressed: () async =>
                                          {await agendaTanque(context, pendentes.elementAt(index), index)},
                                    ),
                                    IconButton(
                                      splashRadius: 5,
                                      icon: Icon(
                                        Icons.close,
                                        color: Colors.red[800],
                                      ),
                                      onPressed: () async =>
                                          {await removeTanque(context, pendentes.elementAt(index), index)},
                                    ),
                                  ],
                                ),
                              )),
                        ),
                      );
                    },
                  ),
                ),
              )
            : Expanded(flex: 4, child: Text('Não há tanques pendentes de agendamento'))
      ],
    );
  }

  salvaAgenda(Agenda a) async {
    try {
      await repoAgenda.save(a);
    } on Falha catch (e) {
      throw e;
    }
  }

  agendaTanque(BuildContext context, TanqueAgendado ta, int index) async {
    try {
      Agenda diaSelecionado = controller.storeDiaAtualizado.lastState.state;
      ta.agenda = diaSelecionado.data;
      ta.statusConfirmacao = StatusConfirmacao.NaoConfirmado;
      diaSelecionado.tanquesAgendados.add(ta);
      pendentes.removeAt(index);
      await salvaAgenda(diaSelecionado);
      controller.notificaPendentes(pendentes);
      controller.notificaDiaAtualizado(diaSelecionado);
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Não foi possível salvar as alterações: ${e.toString()}')));
    }
  }

  removeTanque(BuildContext context, TanqueAgendado ta, int index) async {
    try {
      pendentes.removeAt(index);
      await repoTa.remove(ta.id);
      controller.notificaPendentes(pendentes);
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Erro ao processar a operação: ${e.toString()}')));
    }
  }
}
