import 'package:agendamento_vtr/app/domain/constantes.dart';
import 'package:agendamento_vtr/app/models/tanque.dart';
import 'package:agendamento_vtr/app/modules/agendamento/models/agenda.dart';
import 'package:agendamento_vtr/app/modules/agendamento/models/agenda_model.dart';
import 'package:agendamento_vtr/app/modules/agendamento/models/blocAgendaModel.dart';
import 'package:agendamento_vtr/app/modules/agendamento/models/tanque_agendado.dart';
import 'package:agendamento_vtr/app/modules/agendamento/pages/reagenda_dialog.dart';
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
  final List<TanqueAgendado> agendados = List.empty(growable: true);
  final Map<String, Tanque> tanques = Map();
  Agenda agenda = Agenda('');
  @override
  void initState() {
    super.initState();
    agenda = widget.blocAgendaModel.state.agenda;
    agendados.addAll(widget.blocAgendaModel.state.agendados);
    print('Agenda do dia ${agenda.data} com ${agendados.length} veículos agendados');
    widget.blocAgendaModel.observer(onState: _updateAgenda);
    store.blocTanques.observer(onState: (e) => _updateTanques(e as Map<String, Tanque>));
  }

  _updateAgenda(AgendaModel a) {
    agendados.clear();
    setState(() {
      agenda = a.agenda;
      agendados.addAll(a.agendados);
    });
    store.getTanques(agendados.map((e) => e.tanque).toList());
  }

  _updateTanques(Map<String, Tanque> t) {
    tanques.clear();
    setState(() {
      tanques.addAll(t);
    });
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
            child: tanques.isEmpty
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
                          Tanque tanque = tanques[tAgendado.tanque]!;
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
                                trailing: SizedBox(
                                  width: size.width * .15,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      TextButton(
                                          onPressed: () => _confirmaTanqueAgendado(tAgendado),
                                          child: Icon(
                                            Icons.check_circle_outline,
                                            color: _getCorConfirmacao(tAgendado.statusConfirmacao),
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

  void _confirmaTanqueAgendado(TanqueAgendado ta) {
    Tanque t = tanques[ta.tanque]!;
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
                child: const Text('Sim'),
                onPressed: () {
                  setState(() {
                    ta.statusConfirmacao = StatusConfirmacao.Confirmado;
                  });
                  Navigator.of(context).pop();
                  //ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Veículo confirmado')));
                },
              ),
              TextButton(
                child: const Text('Não'),
                onPressed: () {
                  setState(() {
                    ta.statusConfirmacao = StatusConfirmacao.NaoConfirmado;
                  });
                  Navigator.of(context).pop();
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

  Color _getCorConfirmacao(StatusConfirmacao status) {
    switch (status) {
      case StatusConfirmacao.NaoConfirmado:
        return Colors.orange;
      case StatusConfirmacao.Confirmado:
        return Colors.green;
      case StatusConfirmacao.Reagendado:
        return Colors.blue.shade900;
      case StatusConfirmacao.Cancelado:
        return Colors.red;
    }
  }
}
