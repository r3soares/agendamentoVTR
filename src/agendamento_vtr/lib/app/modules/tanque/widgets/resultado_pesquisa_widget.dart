import 'package:agendamento_vtr/app/pesquisa_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class ResultadoPesquisaWidget extends StatefulWidget {
  const ResultadoPesquisaWidget({Key? key}) : super(key: key);

  @override
  _ResultadoPesquisaWidgetState createState() =>
      _ResultadoPesquisaWidgetState();
}

class _ResultadoPesquisaWidgetState
    extends ModularState<ResultadoPesquisaWidget, PesquisaController> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return controller.resultado == null
        ? SizedBox.shrink()
        : Container(
            child: Card(
              elevation: 12,
              child: ListTile(
                  title: Text(
                    controller.resultado.razaoSocial,
                  ),
                  subtitle: Text('${controller.resultado.cnpj}'),
                  trailing: SizedBox(
                    width: size.width * .15,
                    child: TextButton(
                        onPressed: () => selecionaEmpresa(),
                        child: Text('Selecionar')),
                  )),
            ),
          );
  }

  void atualizaEmpresa() {
    print('AtualizaEmpresa');
    if (controller.status == 1) {
      print('Desenha Resultado Pesquisa');
    }
  }

  void selecionaEmpresa() {}
}
