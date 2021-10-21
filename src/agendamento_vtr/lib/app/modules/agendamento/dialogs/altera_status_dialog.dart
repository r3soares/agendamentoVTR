import 'package:agendamento_vtr/app/modules/agendamento/dialogs/reagenda_dialog.dart';
import 'package:agendamento_vtr/app/modules/agendamento/models/tanque_agendado.dart';
import 'package:flutter/material.dart';

class AlteraStatusDialog extends StatelessWidget {
  final TanqueAgendado tAgendado;
  const AlteraStatusDialog(this.tAgendado);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('${tAgendado.tanque.placaFormatada}'),
      content: SingleChildScrollView(
        child: ListBody(
          children: const <Widget>[
            Text('Confirma comparecimento do veículo para esta data?'),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: const Text(
            'Sim',
            style: TextStyle(color: Colors.green),
          ),
          onPressed: () {
            tAgendado.statusConfirmacao = StatusConfirmacao.Confirmado;
            Navigator.of(context).pop();
            //ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Veículo confirmado')));
          },
        ),
        TextButton(
          child: const Text(
            'Não',
            style: TextStyle(color: Colors.orange),
          ),
          onPressed: () {
            tAgendado.statusConfirmacao = StatusConfirmacao.NaoConfirmado;
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: const Text(
            'Reagendar',
            style: TextStyle(color: Colors.blue),
          ),
          onPressed: () {
            Navigator.of(context).pop();
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return ReagendaDialog(tAgendado);
                });
          },
        ),
        TextButton(
          child: const Text(
            'Cancelar Agendamento',
            style: TextStyle(color: Colors.red),
          ),
          onPressed: () {
            tAgendado.statusConfirmacao = StatusConfirmacao.Cancelado;
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
