import 'package:agendamento_vtr/app/modules/agendamento/models/tanque_agendado.dart';
import 'package:flutter/material.dart';
import 'package:collection/collection.dart';

class SetBitremDialog extends StatelessWidget {
  final TanqueAgendado agendado;
  final List<TanqueAgendado> agendados;
  const SetBitremDialog(this.agendado, this.agendados);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('${agendado.tanque.placaFormatada}'),
      content: SingleChildScrollView(
        child: ListBody(
          children: const <Widget>[
            Text('Informe o segundo tanque'),
          ],
        ),
      ),
      actions: _geraOpcoes(context),
    );
  }

  List<Widget> _geraOpcoes(BuildContext context) {
    List<Widget> opcoes = List.empty(growable: true);

    for (var i in agendados) {
      if (i == agendado) continue;
      var widget = TextButton(
        child: Text(
          '${i.tanque.placaFormatada}',
          style: TextStyle(color: Colors.green),
        ),
        onPressed: () {
          agendado.bitremAgenda = i.id;
          i.bitremAgenda = agendado.id;
          Navigator.of(context).pop();
          //ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Veículo confirmado')));
        },
      );
      opcoes.add(widget);
    }

    if (agendado.bitremAgenda != null) {
      var removerBitrem = TextButton(
          child: const Text(
            'Remover Bitrem',
            style: TextStyle(color: Colors.red),
          ),
          onPressed: () {
            _removeBitrem();
            Navigator.of(context).pop();
            //ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Veículo confirmado')));
          });
      opcoes.add(removerBitrem);
    }

    return opcoes;
  }

  _removeBitrem() {
    var ta2 = agendados.firstWhereOrNull((e) => e.id == agendado.bitremAgenda);
    if (ta2 != null) {
      ta2.bitremAgenda = null;
    }
    agendado.bitremAgenda = null;
  }
}
