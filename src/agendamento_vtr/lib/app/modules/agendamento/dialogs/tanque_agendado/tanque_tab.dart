import 'package:agendamento_vtr/app/behaviors/custom_scroll_behavior.dart';
import 'package:agendamento_vtr/app/models/compartimento.dart';
import 'package:agendamento_vtr/app/models/tanque.dart';
import 'package:agendamento_vtr/app/modules/agendamento/models/tanque_agendado.dart';
import 'package:flutter/material.dart';

class TanqueTab extends StatelessWidget {
  final TanqueAgendado tAgendado;
  final ScrollController scrollControlller = ScrollController();
  TanqueTab(this.tAgendado);

  @override
  Widget build(BuildContext context) {
    Tanque tanque = tAgendado.tanque;
    return buildCompatimentosWidget(tanque.compartimentos);
  }

  Widget buildTitulo(String texto) {
    return Container(
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.all(8),
        child: Text(
          "$texto",
          style: TextStyle(fontSize: 20),
        ));
  }

  Widget buildCompatimentosWidget(List<Compartimento> compartimentos) {
    if (compartimentos.isEmpty) {
      return TextButton(
        onPressed: () => {},
        child: Text(
          'Sem compartimentos cadastrados',
          style: TextStyle(fontSize: 18, color: Colors.blueAccent),
        ),
      );
    }
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(
          flex: 1,
          child: Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.all(8),
            child: Text(
              'Compartimentos\n${tAgendado.tanque.capacidadeTotal} L',
              textAlign: TextAlign.center,
            ),
          ),
        ),
        Expanded(flex: 4, child: buildListaCompartimentos(compartimentos)),
      ],
    );
  }

  Widget buildListaCompartimentos(List<Compartimento> compartimentos) {
    return ScrollConfiguration(
      behavior: CustomScrollBehavior(),
      child: ListView.builder(
          itemExtent: 80,
          physics: const ClampingScrollPhysics(),
          controller: scrollControlller,
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemCount: compartimentos.length,
          itemBuilder: (BuildContext context, int i) {
            Compartimento c = compartimentos.elementAt(i);
            return Card(
              elevation: 4,
              shadowColor: Colors.black,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('${c.capacidade} L'),
                    c.setas > 0 ? Text('${c.setas} SS') : const SizedBox.shrink(),
                  ],
                ),
              ),
            );
          }),
    );
  }
}
