import 'package:flutter/material.dart';

class VisualizaTanqueDialog extends StatelessWidget {
  const VisualizaTanqueDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Dialog(
      child: Container(
        width: size.width * .3,
        height: size.height * .3,
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(12),
              alignment: Alignment.topCenter,
              child: Text('Placa'),
            ),
            Container(
              alignment: Alignment.center,
              padding: EdgeInsets.all(12),
              child: Text('Fulano Deltrano ME'),
            ),
            Container(
              alignment: Alignment.center,
              padding: EdgeInsets.all(12),
              child: Text('ninguem@todos.com.br'),
            ),
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.black, width: 2),
                  borderRadius: BorderRadius.all(Radius.circular(4))),
              child: Column(
                children: [
                  Text('Registrado em 25/05/2021'),
                  Text('Agendado para o dia 30/06/2021'),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
