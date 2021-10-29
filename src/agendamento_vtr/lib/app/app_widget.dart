import 'package:agendamento_vtr/app/behaviors/custom_scroll_behavior.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class AppWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scrollBehavior: CustomScrollBehavior(),
      debugShowCheckedModeBanner: false,
      title: 'Agendamento VTR',
      theme: ThemeData(primarySwatch: Colors.blue, brightness: Brightness.dark),
    ).modular();
  }
}
