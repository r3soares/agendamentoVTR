import 'package:agendamento_vtr/app/models/tanque.dart';
import 'package:agendamento_vtr/app/modules/agendamento/stores/store_data.dart';
import 'package:agendamento_vtr/app/modules/gru/widgets/lista_veiculos_widget.dart';
import 'package:agendamento_vtr/app/modules/gru/widgets/pesquisa_tanque.dart';
import 'package:flutter/material.dart';

class MainPage extends StatelessWidget {
  final StoreData<Tanque> resultadoPesquisa = StoreData(Tanque());
  final List<Tanque> lista = List.empty(growable: true);

  MainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('GRU'),
        ),
        body: SizedBox.expand(
            child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  PesquisaTanqueWidget(resultadoPesquisa),
                  ListaVeiculosWidget(resultadoPesquisa, lista),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: ElevatedButton(
                      child: Text('Gerar Relatório'),
                      onPressed: () => {},
                    ),
                  )
                ],
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Visualizar Relatório'),
                    ),
                  )
                ],
              ),
            )
          ],
        )));
  }

  addResultadoPesquisa(Tanque t) {}
}
