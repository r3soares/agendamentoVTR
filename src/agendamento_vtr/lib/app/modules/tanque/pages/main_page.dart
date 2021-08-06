import 'package:agendamento_vtr/app/modules/tanque/pages/tanque_page.dart';
import 'package:flutter/material.dart';

class MainPage extends StatefulWidget {
  final String title;
  const MainPage({Key? key, this.title = 'Cadastrar Tanque'}) : super(key: key);
  @override
  MainPageState createState() => MainPageState();
}

class MainPageState extends State<MainPage> {
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
            child: const TanquePage(),
          )
        ],
      ),
    );
  }
}
