import 'package:agendamento_vtr/app/modules/tanque/pages/pesquisa_dialog.dart';
import 'package:flutter/material.dart';

class ResponsavelWidget extends StatelessWidget {
  const ResponsavelWidget();

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
            child: Text('Ricardo M B Soares'),
          ),
          Container(
            child: TextButton(
              child: Text('Alterar'),
              onPressed: () => {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return PesquisaDialog();
                    })
              },
            ),
          ),
        ],
      ),
    );
  }
}
