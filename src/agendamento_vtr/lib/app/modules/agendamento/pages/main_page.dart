import 'package:agendamento_vtr/app/modules/agendamento/widgets/agenda_do_dia_widget.dart';
import 'package:agendamento_vtr/app/modules/agendamento/widgets/avisos_widget.dart';
import 'package:agendamento_vtr/app/modules/agendamento/widgets/calendario_widget.dart';
import 'package:agendamento_vtr/app/modules/agendamento/widgets/tanques_pendentes_widget.dart';
import 'package:flutter/material.dart';

class MainPage extends StatelessWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //print('Reconstruindo Main Page');
    return Scaffold(
      appBar: AppBar(
        title: Text('Agendamentos'),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              flex: 1,
              child: CalendarioWidget(),
            ),
            //PesquisaWidget(),
            Flexible(
              flex: 1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Expanded(child: Card(elevation: 12, child: TanquesPendentesWidget())),
                  Expanded(child: Card(elevation: 12, child: AgendaDoDiaWidget())),
                  Expanded(child: Card(elevation: 12, child: AvisosWidget())),
                  //Card(elevation: 12, child: TanquesAgendadosWidget()),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
