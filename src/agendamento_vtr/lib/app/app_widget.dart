import 'package:agendamento_vtr/app/behaviors/custom_scroll_behavior.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class AppWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate
      ],
      supportedLocales: [
        const Locale('pt', 'BR'),
        const Locale('en'),
      ],
      locale: const Locale('pt', 'BR'),
      scrollBehavior: CustomScrollBehavior(),
      debugShowCheckedModeBanner: false,
      title: 'Agendamento VTR',
      theme:
          ThemeData(primarySwatch: Colors.blue, brightness: Brightness.light),
    ).modular();
  }
}
