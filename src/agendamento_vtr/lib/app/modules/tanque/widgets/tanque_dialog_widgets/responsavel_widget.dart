import 'package:agendamento_vtr/app/message_controller.dart';
import 'package:agendamento_vtr/app/modules/tanque/models/empresa.dart';
import 'package:agendamento_vtr/app/modules/tanque/pages/pesquisa_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class ResponsavelWidget extends StatefulWidget {
  final messageControler = Modular.get<MessageController>();
  ResponsavelWidget();

  @override
  _ResponsavelWidgetState createState() => _ResponsavelWidgetState();
}

class _ResponsavelWidgetState extends State<ResponsavelWidget> {
  Empresa responsavel =
      Modular.get<MessageController>().mensagem('proprietario');
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Text(
              'Agendado por',
              style: TextStyle(fontSize: 18),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: Text(responsavel.razaoSocial),
          ),
          Container(
            child: TextButton(
              child: Text('Alterar'),
              onPressed: () => {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return PesquisaDialog();
                    }).whenComplete(() => _atualizaResponsavel())
              },
            ),
          ),
        ],
      ),
    );
  }

  _atualizaResponsavel() {
    final resultadoPesquisa = widget.messageControler.mensagem('empresa');
    if (resultadoPesquisa != null) {
      setState(() {
        responsavel = resultadoPesquisa;
      });
    }
  }
}
