import 'package:flutter/material.dart';

class ColorPopupWidget extends StatelessWidget {
  const ColorPopupWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            mainAxisSize: MainAxisSize.min,
            children: [
              _colorButton(context, Colors.red),
              _colorButton(context, Colors.red.shade200),
              _colorButton(context, Colors.deepOrange),
              _colorButton(context, Colors.amber.shade400),
              _colorButton(context, Colors.green),
              _colorButton(context, Colors.green.shade900),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            mainAxisSize: MainAxisSize.min,
            children: [
              _colorButton(context, Colors.blue.shade300),
              _colorButton(context, Colors.blue.shade900),
              _colorButton(context, Colors.deepPurple.shade200),
              _colorButton(context, Colors.deepPurple),
              _colorButton(context, Colors.blueGrey),
              _colorButton(context, Colors.white),
            ],
          ),
        ]),
      ),
    );
  }

  _colorButton(BuildContext context, Color cor) {
    return IconButton(
        splashRadius: 10,
        onPressed: () => Navigator.pop(context, cor),
        icon: Icon(
          Icons.circle,
          color: cor,
        ));
  }
}
