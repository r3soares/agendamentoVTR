import 'package:flutter/material.dart';

class TanquePage extends StatefulWidget {
  final String title;
  const TanquePage({Key? key, this.title = 'TanquePage'}) : super(key: key);
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
        children: <Widget>[],
      ),
    );
  }
}