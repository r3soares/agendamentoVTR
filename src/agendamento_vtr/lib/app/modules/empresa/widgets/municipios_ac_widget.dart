import 'package:agendamento_vtr/app/domain/log.dart';
import 'package:agendamento_vtr/app/modules/agendamento/models/municipio.dart';
import 'package:agendamento_vtr/app/modules/empresa/stores/municipios_ac_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_triple/flutter_triple.dart';
import 'dart:io' show Platform;

class MunicipiosACWidget extends StatefulWidget {
  final int campoPrevio;
  final String titulo;
  final Function(Municipio) callback;
  const MunicipiosACWidget({Key? key, this.titulo = '', required this.campoPrevio, required this.callback})
      : super(key: key);
  @override
  State<MunicipiosACWidget> createState() => _MunicipiosACWidgetState();
}

class _MunicipiosACWidgetState extends ModularState<MunicipiosACWidget, MunicipiosACStore> {
  final List<Municipio> _kOptions = List<Municipio>.empty(growable: true);
  final List<Disposer> disposers = [];
  TextEditingValue previo = TextEditingValue.empty;

  @override
  void initState() {
    super.initState();
    if (widget.campoPrevio != 0) {
      store.consultaCod(widget.campoPrevio);
    }
    var d2 = store.storeLista.observer(onState: atualizaResultado);
    disposers.add(d2);
  }

  @override
  dispose() {
    for (var d in disposers) {
      d();
    }
    super.dispose();
  }

  atualizaResultado(List<Municipio> lista) {
    setState(() {
      _kOptions.clear();
      lista.sort((a, b) => a.noMunicipio.compareTo(b.noMunicipio));
      _kOptions.addAll(lista);
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScopedBuilder(
        store: store.storeMun,
        onState: (context, state) => buildAutoComplete(state as Municipio),
        onLoading: (context) => const CircularProgressIndicator(),
        onError: (context, erro) {
          return buildAutoComplete(null);
        });
  }

  Widget buildAutoComplete(Municipio? m) {
    return Autocomplete<Municipio>(
      initialValue: TextEditingValue(text: m == null ? '' : m.toString()),
      optionsBuilder: (TextEditingValue textEditingValue) {
        if (textEditingValue.text == '' || textEditingValue.text.length < 3) {
          return const Iterable<Municipio>.empty();
        }
        Log.message(this, '${_kOptions.length}');
        store.consultaNome(textEditingValue.text);
        return _kOptions;
      },
      onSelected: (Municipio selection) {
        Log.message(this, selection.toString());
        widget.callback(selection);
      },
      fieldViewBuilder: (BuildContext context, TextEditingController textEditingController, FocusNode focusNode,
          VoidCallback onFieldSubmitted) {
        return TextFormField(
          validator: validaLetras,
          controller: textEditingController,
          onChanged: (text) => fixAcentos(textEditingController, text),
          focusNode: focusNode,
          decoration: InputDecoration(
            //icon: Image.asset('assets/images/inmetro.png'),
            icon: Icon(Icons.maps_home_work),
            hintText: 'Informe o nome da cidade',
            hintStyle: TextStyle(fontSize: 10),
            labelText: widget.titulo,
          ),
        );
      },
    );
  }

  String? validaLetras(String? num) {
    if (num == null || num.isEmpty) return 'Insira um nome válido';
    return null;
  }

  showErro(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$msg'), backgroundColor: Colors.red[900]));
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
