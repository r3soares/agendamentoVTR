import 'package:agendamento_vtr/app/modules/agendamento/agenda_store.dart';
import 'package:agendamento_vtr/app/modules/agendamento/pages/reagenda_dialog.dart';
import 'package:agendamento_vtr/app/modules/agendamento/pages/visualiza_tanque_dialog.dart';
import 'package:agendamento_vtr/app/modules/tanque/models/tanque.dart';
import 'package:agendamento_vtr/app/repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:intl/intl.dart';

class AgendaDoDiaWidget extends StatefulWidget {
  const AgendaDoDiaWidget({Key? key}) : super(key: key);

  @override
  _AgendaDoDiaWidgetState createState() => _AgendaDoDiaWidgetState();
}

class _AgendaDoDiaWidgetState
    extends ModularState<AgendaDoDiaWidget, AgendaStore> {
  //final agendaStore = Modular.get<AgendaStore>();
  final tanquesRepo = Modular.get<Repository>();
  final formatoData = 'dd/MM/yy';
  final List<Tanque?> tanquesDoDia = List.empty(growable: true);
  String data = '';

  @override
  initState() {
    super.initState();
    store.addListener(() {
      _getTanques();
    });
    _getTanques();
    print('Tanques do dia ${tanquesDoDia.length}');
  }

  _getTanques() {
    tanquesDoDia.clear();
    setState(() {
      tanquesDoDia.addAll(tanquesRepo.tanques
          .where((t) => store.agenda.tanques.contains(t?.placa))
          .toList());
    });
  }

  @override
  Widget build(BuildContext context) {
    print('Build Agenda do dia');
    final size = MediaQuery.of(context).size;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Text(
            'Agenda do dia ${DateFormat(formatoData).format(store.agenda.data)}',
            style: TextStyle(fontSize: 18),
          ),
        ),
        Container(
            alignment: Alignment.center,
            width: size.width * .55,
            height: size.height * .4,
            child: tanquesDoDia.isEmpty
                ? Center(
                    child: Text('Sem veículos para este dia'),
                  )
                : Container(
                    width: size.width * .4,
                    child: ListView.builder(
                        scrollDirection: Axis.vertical,
                        itemCount: tanquesDoDia.length,
                        itemBuilder: (BuildContext ctx, int index) {
                          Tanque t = tanquesDoDia.elementAt(index)!;
                          final data =
                              DateFormat(formatoData).format(t.dataRegistro);
                          return Card(
                            elevation: 12,
                            child: ListTile(
                                leading: Icon(Icons.drive_eta_outlined),
                                title: Row(children: [
                                  Text(
                                    t.placa.replaceRange(3, 3, '-'),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20),
                                    child: Text(
                                      '${t.capacidadeTotal.toString()}L (${t.compartimentos.length}C)',
                                      style: TextStyle(fontSize: 12),
                                    ),
                                  ),
                                ]),
                                subtitle: Text('$data'),
                                trailing: SizedBox(
                                  width: size.width * .15,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      TextButton(
                                          onPressed: () => {
                                                showDialog(
                                                    barrierDismissible: true,
                                                    barrierColor:
                                                        Color.fromRGBO(
                                                            0, 0, 0, .5),
                                                    useSafeArea: true,
                                                    context: context,
                                                    builder: (_) =>
                                                        VisualizaTanqueDialog(
                                                            t)),
                                              },
                                          child: Icon(Icons.remove_red_eye)),
                                      TextButton(
                                          onPressed: () =>
                                              reagendaTanqueDialog(context, t),
                                          child: Icon(
                                              Icons.calendar_today_outlined)),
                                      TextButton(
                                          onPressed: () =>
                                              excluiTanqueDialog(context, t),
                                          child: Icon(Icons.close)),
                                    ],
                                  ),
                                )),
                          );
                        }))),
      ],
    );
  }

  void excluiTanqueDialog(BuildContext ctx, Tanque t) {
    showDialog(
        context: ctx,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(t.placa.replaceRange(3, 3, '-')),
            content: SingleChildScrollView(
              child: ListBody(
                children: const <Widget>[
                  Text(
                      'O tanque será excluído da agenda do dia e retornará para o final da fila.'),
                  Text('\nConfirma ação?'),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('Sim'),
                onPressed: () {
                  setState(() {
                    t.agenda = null;
                    t.dataRegistro = DateTime.now();
                    store.removeTanque(t.placa);
                  });
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: const Text('Não'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  void reagendaTanqueDialog(BuildContext ctx, Tanque t) {
    showDialog(
        context: ctx,
        builder: (BuildContext context) {
          return ReagendaDialog(t);
        });
  }
}
