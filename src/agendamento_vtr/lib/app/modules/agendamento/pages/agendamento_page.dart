import 'package:flutter/material.dart';

class AgendamentoPage extends StatefulWidget {
  final String title;
  const AgendamentoPage({Key? key, this.title = 'Agendamentos'})
      : super(key: key);
  @override
  AgendamentoPageState createState() => AgendamentoPageState();
}

class AgendamentoPageState extends State<AgendamentoPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.all(12),
            alignment: Alignment.topLeft,
            child: Container(),
          )
        ],
      ),
    );
  }
}
