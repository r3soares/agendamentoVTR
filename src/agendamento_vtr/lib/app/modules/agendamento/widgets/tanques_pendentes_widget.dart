import 'package:agendamento_vtr/app/models/tanque.dart';
import 'package:agendamento_vtr/app/modules/agendamento/agenda_store.dart';
import 'package:agendamento_vtr/app/modules/agendamento/pages/visualiza_tanque_dialog.dart';
import 'package:agendamento_vtr/app/repositories/repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:intl/intl.dart';

class TanquesPendentesWidget extends StatefulWidget {
  const TanquesPendentesWidget({Key? key}) : super(key: key);

  @override
  _TanquesPendentesWidgetState createState() => _TanquesPendentesWidgetState();
}

class _TanquesPendentesWidgetState
    extends ModularState<TanquesPendentesWidget, AgendaStore> {
  final List<Tanque?> tanques = List.empty(growable: true);

  final formatoData = 'dd/MM/yy HH:mm';

  @override
  void initState() {
    super.initState();
    _getTanques();
    store.addListener(() {
      if (store.statusTanque == 2)
        setState(() {
          _getTanques();
        });
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    tanques.sort((a, b) => a!.dataRegistro.compareTo(b!.dataRegistro));
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Text(
            '${tanques.length} Tanques não agendados',
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
                      final data =
                          DateFormat(formatoData).format(t.dataRegistro);
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Card(
                          elevation: 12,
                          child: ListTile(
                            leading: TextButton(
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
                            title: Row(children: [
                              Text(
                                t.placa.replaceRange(3, 3, '-'),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: Text(
                                  '${t.capacidadeTotal.toString()}L (${t.compartimentos.length}C ${_somaSetas(t)}S)',
                                  style: TextStyle(fontSize: 12),
                                ),
                              ),
                            ]),
                            subtitle: Text('$data'),
                            trailing: TextButton(
                              child: Text('Agendar'),
                              onPressed: () => {agendaTanque(t)},
                            ),
                          ),
                        ),
                      );
                    },
                  )
                : Text('Não há tanques pendentes de agendamento'))
      ],
    );
  }

  _getTanques() {
    tanques.clear();
    tanques.addAll(Modular.get<Repository>()
        .tanques
        .where((t) => t?.agenda == null)
        .toList());
  }

  agendaTanque(Tanque t) {
    setState(() {
      t.agenda = store.agenda.data;
      store.addTanque(t.placa);
      _getTanques();
    });
  }

  _somaSetas(Tanque t) {
    return t.compartimentos
        .fold(0, (int previousValue, element) => previousValue + element.setas);
  }
}
