import 'package:agendamento_vtr/app/modules/agendamento/agenda_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class AgendaDoDiaWidget extends StatefulWidget {
  const AgendaDoDiaWidget({Key? key}) : super(key: key);

  @override
  _AgendaDoDiaWidgetState createState() => _AgendaDoDiaWidgetState();
}

class _AgendaDoDiaWidgetState extends State<AgendaDoDiaWidget> {
  final agendaStore = Modular.get<AgendaStore>();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text('${agendaStore.state.day}'),
    );
  }
}
