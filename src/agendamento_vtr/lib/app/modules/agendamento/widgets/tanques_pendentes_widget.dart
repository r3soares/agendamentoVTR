import 'package:agendamento_vtr/app/models/tanque.dart';
import 'package:agendamento_vtr/app/modules/agendamento/dialogs/visualiza_tanque_dialog.dart';
import 'package:agendamento_vtr/app/modules/agendamento/models/tanque_agendado.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TanquesPendentesWidget extends StatelessWidget {
  final List<TanqueAgendado> pendentes;
  final formatoData = 'dd/MM/yy HH:mm';
  final ScrollController scrollController = ScrollController();
  TanquesPendentesWidget(this.pendentes);

  @override
  Widget build(BuildContext context) {
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
        pendentes.isNotEmpty
            ? Expanded(
                flex: 4,
                child: ListView.builder(
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
                          leading: TextButton(
                              onPressed: () => {
                                    showDialog(
                                        barrierDismissible: true,
                                        barrierColor: Color.fromRGBO(0, 0, 0, .5),
                                        useSafeArea: true,
                                        context: context,
                                        builder: (_) => VisualizaTanqueDialog(t)),
                                  },
                              child: Icon(Icons.remove_red_eye)),
                          title: Row(children: [
                            Text(
                              t.placa.replaceRange(3, 3, '-'),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              child: Text(
                                '${t.capacidadeTotal.toString()}L (${t.compartimentos.length}C ${t.totalSetas}S)',
                                style: TextStyle(fontSize: 12),
                              ),
                            ),
                          ]),
                          subtitle: Text('$data'),
                          trailing: TextButton(
                            child: Text('Agendar'),
                            onPressed: () => {pendentes.elementAt(index)},
                          ),
                        ),
                      ),
                    );
                  },
                ),
              )
            : Expanded(flex: 4, child: Text('Não há tanques pendentes de agendamento'))
      ],
    );
  }
}
