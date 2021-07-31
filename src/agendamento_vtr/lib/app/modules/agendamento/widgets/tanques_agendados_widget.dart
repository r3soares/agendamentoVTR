import 'package:agendamento_vtr/app/modules/agendamento/agenda_store.dart';
import 'package:agendamento_vtr/app/modules/agendamento/pages/visualiza_tanque_dialog.dart';
import 'package:agendamento_vtr/app/modules/tanque/models/tanque.dart';
import 'package:agendamento_vtr/app/repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:intl/intl.dart';

class TanquesAgendadosWidget extends StatefulWidget {
  const TanquesAgendadosWidget({Key? key}) : super(key: key);

  @override
  _TanquesAgendadosWidgetState createState() => _TanquesAgendadosWidgetState();
}

class _TanquesAgendadosWidgetState
    extends ModularState<TanquesAgendadosWidget, AgendaStore> {
  final List<Tanque?> tanques = List.empty(growable: true);

  final formatoData = 'dd/MM/yy HH:mm';

  @override
  void initState() {
    super.initState();
    _getTanques();
    store.addListener(() {
      if (store.statusTanque == 1)
        setState(() {
          _getTanques();
        });
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    tanques.sort((a, b) => a!.agenda!.compareTo(b!.agenda!));
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Text(
            'Confirmados',
            style: TextStyle(fontSize: 18),
          ),
        ),
        Container(
            alignment: Alignment.center,
            padding: EdgeInsets.all(12),
            width: size.width * .30,
            height: size.height * .4,
            child: tanques.isNotEmpty
                ? ListView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: tanques.length,
                    itemBuilder: (BuildContext context, int index) {
                      Tanque t = tanques.elementAt(index)!;
                      final data = DateFormat(formatoData).format(t.agenda!);
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Card(
                          elevation: 12,
                          child: ListTile(
                            leading: Container(
                              width: size.width * .1,
                              child: Row(
                                children: [
                                  TextButton(
                                      onPressed: () => {
                                            showDialog(
                                                barrierDismissible: true,
                                                barrierColor:
                                                    Color.fromRGBO(0, 0, 0, .5),
                                                useSafeArea: true,
                                                context: context,
                                                builder: (_) =>
                                                    VisualizaTanqueDialog(t)),
                                          },
                                      child: Icon(Icons.remove_red_eye)),
                                  Text(
                                    '$data',
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                            title: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    t.placa.replaceRange(3, 3, '-'),
                                  ),
                                  Text(
                                    '${t.capacidadeTotal.toString()}L (${t.compartimentos.length}C ${_somaSetas(t)}S)',
                                    style: TextStyle(
                                        fontSize: 12, color: Colors.grey),
                                  )
                                ]),
                            trailing: TextButton(
                              child: Text('Remover'),
                              onPressed: () => {},
                            ),
                          ),
                        ),
                      );
                    },
                  )
                : Text('Sem veículos agendados'))
      ],
    );
  }

  _getTanques() {
    tanques.clear();
    tanques.addAll(Modular.get<Repository>()
        .tanques
        .where((t) => t?.agenda != null)
        .toList());
  }

  _somaSetas(Tanque t) {
    return t.compartimentos
        .fold(0, (int previousValue, element) => previousValue + element.setas);
  }
}
