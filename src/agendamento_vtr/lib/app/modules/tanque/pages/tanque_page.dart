import 'package:agendamento_vtr/app/modules/tanque/widgets/proprietario_widget.dart';
import 'package:flutter/material.dart';

class TanquePage extends StatefulWidget {
  final String title;
  const TanquePage({Key? key, this.title = 'Inserir Tanque'}) : super(key: key);
  @override
  TanquePageState createState() => TanquePageState();
}

class TanquePageState extends State<TanquePage> {
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
            child: const ProprietarioWidget(),
          )
        ],
      ),
    );
  }
}
