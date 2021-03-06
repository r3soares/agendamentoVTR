import 'package:agendamento_vtr/app/models/tanque.dart';
import 'package:agendamento_vtr/app/modules/agendamento/stores/store_data.dart';
import 'package:agendamento_vtr/app/modules/gru/stores/tanque_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'dart:io' show Platform;

class PesquisaTanqueWidget extends StatefulWidget {
  final StoreData callback;
  const PesquisaTanqueWidget(this.callback);

  @override
  State<PesquisaTanqueWidget> createState() => _PesquisaTanqueWidgetState();
}

class _PesquisaTanqueWidgetState extends ModularState<PesquisaTanqueWidget, TanqueStore> {
  final List<Tanque> tanques = List.empty(growable: true);

  @override
  void initState() {
    super.initState();

    store.tanquesStore.observer(
      onState: atualizaLista,
    );
  }

  atualizaLista(List<Tanque> encontrados) {
    setState(() {
      tanques.clear();
      tanques.addAll(encontrados);
      tanques.sort((a, b) => a.placa.compareTo(b.placa));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      width: 350,
      height: 100,
      child: Autocomplete<Tanque>(
        optionsBuilder: (textEditingValue) {
          if (textEditingValue.text == '' || textEditingValue.text.length < 3) {
            return const Iterable<Tanque>.empty();
          }
          textEditingValue.text.toUpperCase().startsWith(RegExp(r'^[A-Z]{2,*}'))
              ? store.getTanquesByPlaca(textEditingValue.text)
              : store.getTanquesByInmetro(textEditingValue.text);
          return tanques;
        },
        onSelected: (Tanque selection) => {widget.callback.update(selection)},
        fieldViewBuilder: (BuildContext context, TextEditingController textEditingController, FocusNode focusNode,
            VoidCallback onFieldSubmitted) {
          return TextFormField(
            controller: textEditingController,
            onChanged: (text) => fixAcentos(textEditingController, text),
            focusNode: focusNode,
            decoration: InputDecoration(
                //icon: Image.asset('assets/images/inmetro.png'),
                icon: Icon(Icons.person),
                hintText: 'Informe a placa ou inmetro do ve??culo',
                hintStyle: TextStyle(fontSize: 10),
                labelText: 'Pesquisa de ve??culos',
                suffixIcon: IconButton(
                  icon: Icon(Icons.clear),
                  onPressed: () => {textEditingController.clear()},
                )),
          );
        },
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

      if (controller.text != newValue.toUpperCase()) {
        controller.text = newValue.toUpperCase();
        int pos = newValue.length;
        controller.selection = TextSelection.fromPosition(TextPosition(offset: pos));
      }
    }
  }
}
