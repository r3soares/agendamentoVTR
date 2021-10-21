import 'package:agendamento_vtr/app/domain/constantes.dart';
import 'package:agendamento_vtr/app/models/tanque.dart';
import 'package:agendamento_vtr/app/modules/agendamento/dialogs/altera_status_dialog.dart';
import 'package:agendamento_vtr/app/modules/agendamento/dialogs/visualiza_tanque_dialog.dart';
import 'package:agendamento_vtr/app/modules/agendamento/models/agenda.dart';
import 'package:agendamento_vtr/app/modules/agendamento/models/tanque_agendado.dart';
import 'package:agendamento_vtr/app/modules/agendamento/widgets/pesquisa_agenda_do_dia_widget.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class AgendaDoDiaWidget extends StatelessWidget {
  final Agenda agenda;
  const AgendaDoDiaWidget(this.agenda);

  Widget build(BuildContext context) {
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
          child: PesquisaWidget(),
        ),
        agenda.tanquesAgendados.isEmpty
            ? Expanded(
                flex: 4,
                child: Text('Sem veículos para este dia'),
              )
            : Expanded(
                flex: 4,
                child: ListView.builder(
                    shrinkWrap: true,
                    dragStartBehavior: DragStartBehavior.start,
                    scrollDirection: Axis.vertical,
                    itemCount: agenda.tanquesAgendados.length,
                    itemBuilder: (BuildContext ctx, int index) {
                      TanqueAgendado tAgendado = agenda.tanquesAgendados.elementAt(index);
                      final status = _getCorConfirmacao(tAgendado.statusConfirmacao);
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
                              constraints: BoxConstraints.loose(Size(120, double.infinity)),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  TextButton(
                                      onPressed: () => showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlteraStatusDialog(tAgendado);
                                          }),
                                      child: Icon(
                                        status.value,
                                        color: status.key,
                                      )),
                                  // TextButton(
                                  //     onPressed: () => _reagendaTanque(tAgendado),
                                  //     child: Icon(Icons.calendar_today_outlined)),
                                  TextButton(
                                      onPressed: () => _excluiTanqueAgendado(tAgendado), child: Icon(Icons.close)),
                                ],
                              ),
                            )),
                      );
                    })),
      ],
    );
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

  void _excluiTanqueAgendado(TanqueAgendado ta) {}
}
