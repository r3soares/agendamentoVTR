import 'package:agendamento_vtr/app/modules/agendamento/widgets/agenda_do_dia_widget.dart';
import 'package:agendamento_vtr/app/modules/agendamento/widgets/calendario_widget.dart';
import 'package:agendamento_vtr/app/modules/agendamento/widgets/tanques_pendentes_widget.dart';
import 'package:flutter/material.dart';

class AgendamentoPage extends StatelessWidget {
  const AgendamentoPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Agendamentos'),
      ),
      body: SingleChildScrollView(
        child: Column(children: [
          CalendarioWidget(),
          Row(
            children: [
              Card(elevation: 12, child: TanquesPendentesWidget()),
              Card(elevation: 12, child: AgendaDoDiaWidget()),
            ],
          )
        ]),
      ),
    );
  }
}
