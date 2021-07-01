import 'package:agendamento_vtr/app/modules/agendamento/agenda_store.dart';
import 'package:agendamento_vtr/app/modules/agendamento/widgets/agenda_do_dia_widget.dart';
import 'package:agendamento_vtr/app/modules/agendamento/widgets/calendario_widget.dart';
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
    return Scaffold(
      appBar: AppBar(
        title: Text('Agendamentos'),
      ),
      body: Column(children: [
        CalendarioWidget(),
        ScopedBuilder(
          store: agendaStore,
          onState: (_, state) => AgendaDoDiaWidget(),
        )
      ]),
    );
  }
}
