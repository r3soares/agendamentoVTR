import 'package:agendamento_vtr/app/modules/agendamento/models/municipio.dart';
import 'package:agendamento_vtr/app/modules/empresa/stores/municipios_ac_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_triple/flutter_triple.dart';

class MunicipiosACWidget extends StatefulWidget {
  final int campoPrevio;
  final String titulo;
  final formKey;
  final Function(Municipio) callback;
  const MunicipiosACWidget(
      {Key? key, this.titulo = '', required this.campoPrevio, required this.callback, required this.formKey})
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
      var d1 = store.storeMun.observer(onState: setCampoPrevio);
      store.consultaCod(widget.campoPrevio);
      disposers.add(d1);
    }
    var d2 = store.observer(onState: atualizaResultado);
    disposers.add(d2);
  }

  @override
  dispose() {
    for (var d in disposers) {
      d();
    }
    super.dispose();
  }

  setCampoPrevio(Municipio m) {
    previo = TextEditingValue(text: m.toString());
  }

  atualizaResultado(List<Municipio> lista) {
    _kOptions.clear();
    _kOptions.addAll(lista);
  }

  @override
  Widget build(BuildContext context) {
    return Autocomplete<Municipio>(
      initialValue: previo,
      optionsBuilder: (TextEditingValue textEditingValue) {
        if (textEditingValue.text == '') {
          return const Iterable<Municipio>.empty();
        }
        store.consultaNome(textEditingValue.text);
        return _kOptions;
      },
      onSelected: (Municipio selection) {
        widget.callback(selection);
      },
      fieldViewBuilder: (BuildContext context, TextEditingController textEditingController, FocusNode focusNode,
          VoidCallback onFieldSubmitted) {
        return Form(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            key: widget.formKey,
            child: TextFormField(
              controller: textEditingController,
              focusNode: focusNode,
              decoration: InputDecoration(
                //icon: Image.asset('assets/images/inmetro.png'),
                icon: Icon(Icons.looks_one),
                hintText: 'Informe o nome da cidade',
                hintStyle: TextStyle(fontSize: 10),
                labelText: widget.titulo,
              ),
            ));
      },
    );
  }
}
