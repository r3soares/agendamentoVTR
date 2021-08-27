import 'package:agendamento_vtr/app/message_controller.dart';
import 'package:agendamento_vtr/app/pesquisa_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class ResultadoPesquisaWidget extends StatefulWidget {
  const ResultadoPesquisaWidget({Key? key}) : super(key: key);

  @override
  _ResultadoPesquisaWidgetState createState() =>
      _ResultadoPesquisaWidgetState();
}

class _ResultadoPesquisaWidgetState extends State<ResultadoPesquisaWidget> {
  final controller = Modular.get<PesquisaController>();

  _ResultadoPesquisaWidgetState() {
    controller.addListener(() {
      atualizaEmpresa();
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return controller.resultado == null
        ? SizedBox.shrink()
        : Container(
            width: size.width * .25,
            child: Card(
              elevation: 12,
              child: ListTile(
                  title: Text(
                    controller.resultado.razaoSocial,
                  ),
                  subtitle: Text('${controller.resultado.cnpj}'),
                  trailing: TextButton(
                      onPressed: () => selecionaEmpresa(),
                      child: Text('Selecionar'))),
            ),
          );
  }

  void atualizaEmpresa() {
    setState(() {});
  }

  void selecionaEmpresa() {
    Modular.get<MessageController>()
        .setMensagem('empresa', controller.resultado);
    Navigator.of(context).pop();
  }
}
