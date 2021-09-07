import 'package:flutter/material.dart';

class TanqueZeroWidget extends StatefulWidget {
  final Function(bool) callback;
  final String titulo;
  const TanqueZeroWidget(
      {this.titulo = 'Tanque zero?', required this.callback});

  @override
  _TanqueZeroWidgetState createState() => _TanqueZeroWidgetState();
}

class _TanqueZeroWidgetState extends State<TanqueZeroWidget> {
  bool isZero = false;
  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.topCenter,
        padding: const EdgeInsets.all(8),
        child: ToggleButtons(
          selectedBorderColor: Theme.of(context).primaryColor,
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(8),
              child: Text('Tanque Novo'),
            ),
          ],
          onPressed: _alteraValor,
          isSelected: [isZero],
        ));
  }

  _alteraValor(int? valor) {
    setState(() {
      isZero = !isZero;
    });
    widget.callback(isZero);
  }
}
