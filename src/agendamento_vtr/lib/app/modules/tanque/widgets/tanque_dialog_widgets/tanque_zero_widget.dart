import 'package:agendamento_vtr/app/modules/tanque/models/tanque.dart';
import 'package:flutter/material.dart';

class TanqueZeroWidget extends StatefulWidget {
  final Tanque tanque;
  const TanqueZeroWidget(this.tanque);

  @override
  _TanqueZeroWidgetState createState() => _TanqueZeroWidgetState();
}

class _TanqueZeroWidgetState extends State<TanqueZeroWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              'Tanque zero?',
              style: TextStyle(fontSize: 18),
            ),
            Checkbox(
              value: widget.tanque.isZero,
              onChanged: (value) =>
                  setState(() => widget.tanque.isZero = value),
            )
          ],
        ));
  }
}
