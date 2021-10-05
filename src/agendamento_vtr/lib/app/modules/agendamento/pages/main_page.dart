import 'package:agendamento_vtr/app/models/bloc.dart';
import 'package:agendamento_vtr/app/models/model_base.dart';
import 'package:agendamento_vtr/app/modules/agendamento/widgets/calendario_widget.dart';
import 'package:agendamento_vtr/app/modules/agendamento/widgets/pesquisa_widget.dart';
import 'package:flutter/material.dart';

class MainPage extends StatelessWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Bloc diaAtual = Bloc(ModelBase(null));

    return Scaffold(
      appBar: AppBar(
        title: Text('Agendamentos'),
      ),
      body: SingleChildScrollView(
        child: Column(children: [
          CalendarioWidget(
            diaAtual: diaAtual,
          ),
          PesquisaWidget(),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              //Card(elevation: 12, child: TanquesPendentesWidget()),
              //Card(elevation: 12, child: AgendaDoDiaWidget()),
              //Card(elevation: 12, child: TanquesAgendadosWidget()),
            ],
          )
        ]),
      ),
    );
  }
}
