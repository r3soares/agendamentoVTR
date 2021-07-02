import 'package:agendamento_vtr/app/modules/agendamento/agenda_store.dart';
import 'package:agendamento_vtr/app/modules/tanque/models/tanque.dart';
import 'package:agendamento_vtr/app/repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:intl/intl.dart';

class TanquesPendentesWidget extends StatefulWidget {
  const TanquesPendentesWidget({Key? key}) : super(key: key);

  @override
  _TanquesPendentesWidgetState createState() => _TanquesPendentesWidgetState();
}

class _TanquesPendentesWidgetState extends State<TanquesPendentesWidget> {
  final agendaStore = Modular.get<AgendaStore>();
  List<Tanque?> tanques = Modular.get<Repository>()
      .tanques
      .where((t) => t?.agenda == null)
      .toList();

  final formatoData = 'dd/MM/yy HH:mm';

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    tanques.sort((a, b) => a!.dataRegistro.compareTo(b!.dataRegistro));
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Text(
            'Tanques não agendados',
            style: TextStyle(fontSize: 18),
          ),
        ),
        Container(
            alignment: Alignment.center,
            padding: EdgeInsets.all(12),
            width: size.width * .3,
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
                            leading: Icon(Icons.drive_eta_outlined),
                            title: Row(children: [
                              Text(
                                t.placa.replaceRange(3, 3, '-'),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: Text(
                                  '${t.capacidadeTotal.toString()}L (${t.compartimentos.length}C)',
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
    tanques = Modular.get<Repository>()
        .tanques
        .where((t) => t?.agenda == null)
        .toList();
  }

  agendaTanque(Tanque t) {
    setState(() {
      t.agenda = agendaStore.agenda.data;
      agendaStore.agenda.addTanque(t.placa);
      _getTanques();
    });
  }
}
