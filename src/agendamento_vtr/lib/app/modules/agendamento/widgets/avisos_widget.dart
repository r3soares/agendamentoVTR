import 'package:flutter/material.dart';

class AvisosWidget extends StatefulWidget {
  const AvisosWidget({Key? key}) : super(key: key);

  @override
  _AvisosWidgetState createState() => _AvisosWidgetState();
}

class _AvisosWidgetState extends State<AvisosWidget> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Text(
            'Quadro de Avisos',
            style: TextStyle(fontSize: 18),
          ),
        ),
        Expanded(
          child: SizedBox.shrink(),
        ),
      ],
    );
  }
}
