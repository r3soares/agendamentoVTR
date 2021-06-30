import 'package:agendamento_vtr/app/modules/agendamento/widgets/calendario_widget.dart';
import 'package:flutter/material.dart';

class AgendamentoPage extends StatelessWidget {
  const AgendamentoPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Agendamentos'),
      ),
      body: Column(children: [
        CalendarioWidget(),
      ]),
    );
  }
}
