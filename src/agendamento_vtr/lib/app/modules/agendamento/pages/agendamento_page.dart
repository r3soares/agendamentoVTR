import 'package:agendamento_vtr/app/modules/agendamento/agenda_store.dart';
import 'package:agendamento_vtr/app/modules/agendamento/widgets/agenda_do_dia_widget.dart';
import 'package:agendamento_vtr/app/modules/agendamento/widgets/calendario_widget.dart';
import 'package:agendamento_vtr/app/modules/agendamento/widgets/tanques_pendentes_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_triple/flutter_triple.dart';

class AgendamentoPage extends StatefulWidget {
  const AgendamentoPage({Key? key}) : super(key: key);

  @override
  _AgendamentoPageState createState() => _AgendamentoPageState();
}

class _AgendamentoPageState extends State<AgendamentoPage> {
  final agendaStore = Modular.get<AgendaStore>();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('Agendamentos'),
      ),
      body: Column(children: [
        CalendarioWidget(),
        Expanded(
          child: Row(
            children: [
              Card(
                elevation: 12,
                child: Column(
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
                        child: TanquesPendentesWidget())
                  ],
                ),
              ),
              Card(
                elevation: 12,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Text(
                        'Agenda do dia ${agendaStore.agendaDoDia.data}',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                    ScopedBuilder(
                      store: agendaStore,
                      onState: (_, state) => Container(
                          alignment: Alignment.center,
                          width: size.width * .6,
                          height: size.height * .4,
                          child: AgendaDoDiaWidget()),
                    ),
                  ],
                ),
              )
            ],
          ),
        )
      ]),
    );
  }
}
