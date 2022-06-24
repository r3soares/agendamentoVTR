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
              _colorButton(context, Color.fromARGB(255, 213, 0, 0)),
              _colorButton(context, Color.fromARGB(255, 230, 124, 115)),
              _colorButton(context, Color.fromARGB(255, 244, 81, 30)),
              _colorButton(context, Color.fromARGB(255, 246, 191, 38)),
              _colorButton(context, Color.fromARGB(255, 51, 182, 121)),
              _colorButton(context, Color.fromARGB(255, 11, 128, 67)),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            mainAxisSize: MainAxisSize.min,
            children: [
              _colorButton(context, Color.fromARGB(255, 3, 155, 229)),
              _colorButton(context, Color.fromARGB(255, 63, 81, 181)),
              _colorButton(context, Color.fromARGB(255, 121, 134, 203)),
              _colorButton(context, Color.fromARGB(255, 142, 36, 170)),
              _colorButton(context, Color.fromARGB(255, 97, 97, 97)),
              _colorButton(context, Color.fromARGB(255, 210, 210, 210)),
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
