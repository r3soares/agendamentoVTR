import 'package:agendamento_vtr/app/domain/constantes.dart';
import 'package:agendamento_vtr/app/models/tanque.dart';
import 'package:agendamento_vtr/app/modules/agendamento/models/agenda.dart';
import 'package:agendamento_vtr/app/modules/agendamento/models/tanque_agendado.dart';
import 'package:agendamento_vtr/app/modules/agendamento/pages/reagenda_dialog.dart';
import 'package:agendamento_vtr/app/modules/agendamento/pages/visualiza_tanque_dialog.dart';
import 'package:agendamento_vtr/app/modules/agendamento/stores/agenda_do_dia_store.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class AgendaDoDiaWidget extends StatefulWidget {
  const AgendaDoDiaWidget({Key? key});

  @override
  _AgendaDoDiaWidgetState createState() => _AgendaDoDiaWidgetState();
}

class _AgendaDoDiaWidgetState extends ModularState<AgendaDoDiaWidget, AgendaDoDiaStore> {
  //final List<TanqueAgendado> agendados = List.empty(growable: true);
  //final Map<String, Tanque> tanques = Map();
  Agenda agenda = Agenda('');
  final ScrollController _scrollController = ScrollController();
  @override
  void initState() {
    super.initState();
    //print('AgendaDoDiaWidget: initState');
    agenda = store.agendaDoDia;
    //agendados.addAll(store.agendados);
    print('Agenda do dia ${agenda.data} com ${agenda.tanquesAgendados.length} veículos agendados');
    store.blocDiaSelecionado.observer(onState: _updateAgenda);
    //store.blocTanques.observer(onState: (e) => _updateTanques(e as Map<String, Tanque>));
  }

  _updateAgenda(Agenda a) {
    //print('AgendaDoDiaWidget: Atualizando agenda do dia para ${a.agenda.data}');
    //print('AgendaDoDiaWidget: Esta agenda possui ${a.agendados.length} tanques agendados');
    //tanques.clear();
    if (mounted) {
      setState(() {
        agenda = a;
      });
      //store.getTanques(agendados.map((e) => e.tanque).toList());
    }
  }

  // _updateTanques(Map<String, Tanque> t) {
  //   setState(() {
  //     tanques.addAll(t);
  //   });
  // }

  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Text(
            'Agenda do dia ${agenda.data}',
            style: TextStyle(fontSize: 18),
          ),
        ),
        Container(
            alignment: Alignment.center,
            width: size.width * .36,
            height: size.height * .4,
            child: agenda.tanquesAgendados.isEmpty
                ? Center(
                    child: Text('Sem veículos para este dia'),
                  )
                : Container(
                    alignment: Alignment.topCenter,
                    constraints: BoxConstraints(
                        minHeight: 200, minWidth: 400, maxWidth: size.width * .5, maxHeight: size.height * .4),
                    child: ListView.builder(
                        shrinkWrap: true,
                        dragStartBehavior: DragStartBehavior.start,
                        controller: _scrollController,
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
                                          onPressed: () => _confirmaTanqueAgendado(tAgendado),
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
                        }))),
      ],
    );
  }

  void _confirmaTanqueAgendado(TanqueAgendado ta) {
    Tanque t = ta.tanque;
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('${t.placaFormatada}'),
            content: SingleChildScrollView(
              child: ListBody(
                children: const <Widget>[
                  Text('Confirma comparecimento do veículo para esta data?'),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text(
                  'Sim',
                  style: TextStyle(color: Colors.green),
                ),
                onPressed: () {
                  setState(() {
                    ta.statusConfirmacao = StatusConfirmacao.Confirmado;
                  });
                  Navigator.of(context).pop();
                  //ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Veículo confirmado')));
                },
              ),
              TextButton(
                child: const Text(
                  'Não',
                  style: TextStyle(color: Colors.orange),
                ),
                onPressed: () {
                  setState(() {
                    ta.statusConfirmacao = StatusConfirmacao.NaoConfirmado;
                  });
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: const Text(
                  'Reagendar',
                  style: TextStyle(color: Colors.blue),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                  _reagendaTanque(ta);
                },
              ),
              TextButton(
                child: const Text(
                  'Cancelar Agendamento',
                  style: TextStyle(color: Colors.red),
                ),
                onPressed: () {
                  setState(() {
                    ta.statusConfirmacao = StatusConfirmacao.Cancelado;
                  });
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  void _reagendaTanque(TanqueAgendado ta) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return ReagendaDialog(ta);
        });
  }

  void _excluiTanqueAgendado(TanqueAgendado ta) {}

  MapEntry<Color, IconData> _getCorConfirmacao(StatusConfirmacao status) {
    switch (status) {
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
}
