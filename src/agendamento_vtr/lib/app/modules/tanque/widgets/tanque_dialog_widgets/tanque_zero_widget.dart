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
    return Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              widget.titulo,
              style: TextStyle(fontSize: 18),
            ),
            Checkbox(
              value: isZero,
              onChanged: _alteraValor,
            )
          ],
        ));
  }

  _alteraValor(bool? valor) {
    setState(() {
      isZero = valor == true;
    });
    widget.callback(isZero);
  }
}
