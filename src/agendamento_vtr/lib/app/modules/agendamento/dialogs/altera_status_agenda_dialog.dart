import 'package:agendamento_vtr/app/modules/agendamento/models/agenda.dart';
import 'package:flutter/material.dart';

class AlteraStatusAgendaDialog extends StatelessWidget {
  final Agenda agenda;
  const AlteraStatusAgendaDialog(this.agenda);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Center(child: Text('Alterando status')),
      content: SingleChildScrollView(
        child: ListBody(
          children: const <Widget>[
            Text('Informe o novo status da agenda'),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: const Text(
            'Disponível',
            style: TextStyle(color: Colors.green),
          ),
          onPressed: () {
            agenda.status = StatusAgenda.Disponivel;
            Navigator.of(context).pop();
            //ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Veículo confirmado')));
          },
        ),
        TextButton(
          child: const Text(
            'Cheia',
            style: TextStyle(color: Colors.red),
          ),
          onPressed: () {
            agenda.status = StatusAgenda.Cheia;
            Navigator.of(context).pop();
          },
        ),
        // TextButton(
        //   child: const Text(
        //     'Encerrada',
        //     style: TextStyle(color: Colors.black),
        //   ),
        //   onPressed: () {
        //     agenda.status = StatusAgenda.Encerrada;
        //     Navigator.of(context).pop();
        //   },
        // ),
        TextButton(
          child: const Text(
            'Indisponível',
            style: TextStyle(color: Colors.black),
          ),
          onPressed: () {
            agenda.status = StatusAgenda.Indisponivel;
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
