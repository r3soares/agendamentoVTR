import 'package:agendamento_vtr/app/models/empresa.dart';
import 'package:agendamento_vtr/app/modules/agendamento/models/tanque_agendado.dart';
import 'package:agendamento_vtr/app/modules/agendamento/stores/pesquisa_empresa_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'dart:io' show Platform;

class PesquisaEmpresaDialog extends StatefulWidget {
  final String titulo;
  final TanqueAgendado tAgendado;
  const PesquisaEmpresaDialog(this.titulo, this.tAgendado);

  @override
  State<PesquisaEmpresaDialog> createState() => _PesquisaEmpresaDialogState();
}

class _PesquisaEmpresaDialogState
    extends ModularState<PesquisaEmpresaDialog, PesquisaEmpresaStore> {
  final List<Empresa> empresas = List.empty(growable: true);

  @override
  void initState() {
    super.initState();

    store.empresasStore.observer(
      onState: atualizaLista,
    );
  }

  atualizaLista(List<Empresa> encontradas) {
    setState(() {
      empresas.clear();
      empresas.addAll(encontradas);
      empresas.sort((a, b) => a.razaoSocial.compareTo(b.razaoSocial));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        padding: const EdgeInsets.all(12),
        width: 350,
        height: 200,
        child: Column(
          children: [
            Autocomplete<Empresa>(
              optionsBuilder: (TextEditingValue textEditingValue) {
                if (textEditingValue.text == '' ||
                    textEditingValue.text.length < 3) {
                  return const Iterable<Empresa>.empty();
                }
                textEditingValue.text.startsWith(RegExp(r'^[0-9]'))
                    ? store.getEmpresasByCNPJ(textEditingValue.text)
                    : store.getEmpresasByNome(textEditingValue.text);
                return empresas;
              },
              onSelected: (Empresa selection) {
                if (widget.titulo.startsWith('P')) {
                  widget.tAgendado.tanque.proprietario = selection;
                }
              },
              fieldViewBuilder: (BuildContext context,
                  TextEditingController textEditingController,
                  FocusNode focusNode,
                  VoidCallback onFieldSubmitted) {
                return TextFormField(
                  controller: textEditingController,
                  onChanged: (text) => fixAcentos(textEditingController, text),
                  focusNode: focusNode,
                  decoration: InputDecoration(
                    //icon: Image.asset('assets/images/inmetro.png'),
                    icon: Icon(Icons.person),
                    hintText: 'Informe o nome ou CNPJ do ${widget.titulo}',
                    hintStyle: TextStyle(fontSize: 10),
                    labelText: 'Pesquisa de ${widget.titulo}',
                  ),
                );
              },
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                  onPressed: () => Modular.to.pop(), child: Text('Ok')),
            )
          ],
        ),
      ),
    );
  }

  fixAcentos(TextEditingController controller, String value) {
    if (Platform.isWindows) {
      String newValue = value
          // A
          .replaceAll('????a', '??')
          .replaceAll('\'\'a', '??')
          .replaceAll('``a', '??')
          .replaceAll('^^a', '??')
          .replaceAll('~~a', '??')
          .replaceAll('????A', '??')
          .replaceAll('\'\'A', '??')
          .replaceAll('``A', '??')
          .replaceAll('^^A', '??')
          .replaceAll('~~A', '??')
          // E
          .replaceAll('????e', '??')
          .replaceAll('\'\'e', '??')
          .replaceAll('``e', '??')
          .replaceAll('^^e', '??')
          .replaceAll('????E', '??')
          .replaceAll('\'\'E', '??')
          .replaceAll('``E', '??')
          .replaceAll('^^E', '??')
          // I
          .replaceAll('????i', '??')
          .replaceAll('\'\'i', '??')
          .replaceAll('``i', '??')
          .replaceAll('^^i', '??')
          .replaceAll('????I', '??')
          .replaceAll('\'\'I', '??')
          .replaceAll('``I', '??')
          .replaceAll('^^I', '??')
          // O
          .replaceAll('????o', '??')
          .replaceAll('\'\'o', '??')
          .replaceAll('``o', '??')
          .replaceAll('^^o', '??')
          .replaceAll('~~o', '??')
          .replaceAll('????O', '??')
          .replaceAll('\'\'O', '??')
          .replaceAll('``O', '??')
          .replaceAll('^^O', '??')
          .replaceAll('~~O', '??')
          // U
          .replaceAll('????u', '??')
          .replaceAll('\'\'u', '??')
          .replaceAll('``u', '??')
          .replaceAll('^^u', '??')
          .replaceAll('????U', '??')
          .replaceAll('\'\'U', '??')
          .replaceAll('``U', '??')
          .replaceAll('^^U', '??');

      if (controller.text != newValue) {
        controller.text = newValue;
        int pos = newValue.length;
        controller.selection =
            TextSelection.fromPosition(TextPosition(offset: pos));
      }
    }
  }
}
