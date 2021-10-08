import 'package:agendamento_vtr/app/models/tanque.dart';
import 'package:agendamento_vtr/app/modules/agendamento/models/agenda.dart';
import 'package:agendamento_vtr/app/modules/agendamento/models/blocAgendaModel.dart';
import 'package:agendamento_vtr/app/modules/agendamento/models/tanque_agendado.dart';
import 'package:agendamento_vtr/app/modules/agendamento/pages/visualiza_tanque_dialog.dart';
import 'package:agendamento_vtr/app/modules/agendamento/stores/agenda_do_dia_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class AgendaDoDiaWidget extends StatefulWidget {
  final BlocAgendaModel blocAgendaModel;
  const AgendaDoDiaWidget({Key? key, required this.blocAgendaModel});

  @override
  _AgendaDoDiaWidgetState createState() => _AgendaDoDiaWidgetState();
}

class _AgendaDoDiaWidgetState extends ModularState<AgendaDoDiaWidget, AgendaDoDiaStore> {
  List<TanqueAgendado> agendados = List.empty();
  Agenda agenda = Agenda('');
  @override
  void initState() {
    super.initState();
    agenda = widget.blocAgendaModel.state.agenda;
    agendados = widget.blocAgendaModel.state.agendados;
    print('Agenda do dia ${agenda.data} com ${agendados.length} veículos agendados');
    widget.blocAgendaModel.observer(
        onState: (e) => setState(() {
              agenda = e.agenda;
              agendados = e.agendados;
            }));
  }

  Widget build(BuildContext context) {
    print('Build Agenda do dia');
    final size = MediaQuery.of(context).size;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Text(
            'Agenda do dia ${widget.blocAgendaModel.state.agenda.data}',
            style: TextStyle(fontSize: 18),
          ),
        ),
        Container(
            alignment: Alignment.center,
            width: size.width * .36,
            height: size.height * .4,
            child: agendados.isEmpty
                ? Center(
                    child: Text('Sem veículos para este dia'),
                  )
                : Container(
                    width: size.width * .35,
                    child: ListView.builder(
                        scrollDirection: Axis.vertical,
                        itemCount: agendados.length,
                        itemBuilder: (BuildContext ctx, int index) {
                          TanqueAgendado tAgendado = agendados.elementAt(index);
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
                                              builder: (_) => VisualizaTanqueDialog(Tanque())),
                                        },
                                    child: Icon(Icons.remove_red_eye)),
                                title: Row(children: [
                                  Text(
                                    'Placa',
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 20),
                                    child: Text(
                                      'Capacidade',
                                      style: TextStyle(fontSize: 12),
                                    ),
                                  ),
                                ]),
                                subtitle: Text('Data do Registro'),
                                trailing: SizedBox(
                                  width: size.width * .15,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      TextButton(
                                          onPressed: () => _confirmaTanque(Tanque()),
                                          child: Icon(
                                            Icons.check_circle_outline,
                                            color: tAgendado.statusConfirmacao == StatusConfirmacao.Confirmado
                                                ? Colors.green
                                                : Colors.orange,
                                          )),
                                      TextButton(
                                          onPressed: () => _reagendaTanque(tAgendado),
                                          child: Icon(Icons.calendar_today_outlined)),
                                      TextButton(
                                          onPressed: () => _excluiTanqueAgendado(tAgendado), child: Icon(Icons.close)),
                                    ],
                                  ),
                                )),
                          );
                        }))),
      ],
    );
  }

  void _confirmaTanque(Tanque T) {}
  void _reagendaTanque(TanqueAgendado ta) {}
  void _excluiTanqueAgendado(TanqueAgendado ta) {}
}
