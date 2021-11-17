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

class _PesquisaEmpresaDialogState extends ModularState<PesquisaEmpresaDialog, PesquisaEmpresaStore> {
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
                if (textEditingValue.text == '' || textEditingValue.text.length < 3) {
                  return const Iterable<Empresa>.empty();
                }
                store.getEmpresasByNome(textEditingValue.text);
                return empresas;
              },
              onSelected: (Empresa selection) {
                if (widget.titulo.startsWith('P')) {
                  widget.tAgendado.tanque.proprietario = selection;
                } else {
                  widget.tAgendado.responsavel = selection;
                }
              },
              fieldViewBuilder: (BuildContext context, TextEditingController textEditingController, FocusNode focusNode,
                  VoidCallback onFieldSubmitted) {
                return TextFormField(
                  controller: textEditingController,
                  onChanged: (text) => fixAcentos(textEditingController, text),
                  focusNode: focusNode,
                  decoration: InputDecoration(
                    //icon: Image.asset('assets/images/inmetro.png'),
                    icon: Icon(Icons.maps_home_work),
                    hintText: 'Informe o nome ou CNPJ do ${widget.titulo}',
                    hintStyle: TextStyle(fontSize: 10),
                    labelText: 'Pesquisa de ${widget.titulo}',
                  ),
                );
              },
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(onPressed: () => Modular.to.pop(), child: Text('Ok')),
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
          .replaceAll('´´a', 'á')
          .replaceAll('\'\'a', 'á')
          .replaceAll('``a', 'à')
          .replaceAll('^^a', 'â')
          .replaceAll('~~a', 'ã')
          .replaceAll('´´A', 'Á')
          .replaceAll('\'\'A', 'Á')
          .replaceAll('``A', 'À')
          .replaceAll('^^A', 'Â')
          .replaceAll('~~A', 'Ã')
          // E
          .replaceAll('´´e', 'é')
          .replaceAll('\'\'e', 'é')
          .replaceAll('``e', 'è')
          .replaceAll('^^e', 'ê')
          .replaceAll('´´E', 'É')
          .replaceAll('\'\'E', 'É')
          .replaceAll('``E', 'È')
          .replaceAll('^^E', 'Ê')
          // I
          .replaceAll('´´i', 'í')
          .replaceAll('\'\'i', 'í')
          .replaceAll('``i', 'ì')
          .replaceAll('^^i', 'î')
          .replaceAll('´´I', 'Í')
          .replaceAll('\'\'I', 'Í')
          .replaceAll('``I', 'Ì')
          .replaceAll('^^I', 'î')
          // O
          .replaceAll('´´o', 'ó')
          .replaceAll('\'\'o', 'ó')
          .replaceAll('``o', 'ò')
          .replaceAll('^^o', 'ô')
          .replaceAll('~~o', 'õ')
          .replaceAll('´´O', 'Ó')
          .replaceAll('\'\'O', 'Ó')
          .replaceAll('``O', 'Ò')
          .replaceAll('^^O', 'Ô')
          .replaceAll('~~O', 'Õ')
          // U
          .replaceAll('´´u', 'ú')
          .replaceAll('\'\'u', 'ú')
          .replaceAll('``u', 'ù')
          .replaceAll('^^u', 'û')
          .replaceAll('´´U', 'Ú')
          .replaceAll('\'\'U', 'Ú')
          .replaceAll('``U', 'Ù')
          .replaceAll('^^U', 'Û');

      if (controller.text != newValue) {
        controller.text = newValue;
        int pos = newValue.length;
        controller.selection = TextSelection.fromPosition(TextPosition(offset: pos));
      }
    }
  }
}
