// ignore_for_file: unnecessary_statements

import 'package:agendamento_vtr/app/domain/erros.dart';
import 'package:agendamento_vtr/app/models/model_base.dart';
import 'package:agendamento_vtr/app/modules/agendamento/models/tanque_agendado.dart';
import 'package:agendamento_vtr/app/modules/agendamento/stores/pesquisa_agenda_do_dia_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_triple/flutter_triple.dart';

class PesquisaWidget extends StatefulWidget {
  const PesquisaWidget({Key? key}) : super(key: key);

  @override
  _PesquisaWidgetState createState() => _PesquisaWidgetState();
}

class _PesquisaWidgetState extends ModularState<PesquisaWidget, PesquisaAgendaDoDiaStore>
    with SingleTickerProviderStateMixin {
  final TextEditingController _cPesquisa = TextEditingController();
  final List<Disposer> disposers = List.empty(growable: true);
  TanqueAgendado? _tanqueResultadoPesquisa;

  var controllerAnim;
  late Animation animation;
  Color? color;

  @override
  void initState() {
    super.initState();
    _cPesquisa.addListener(limpaResultado);
    var d1 = store.observer(
        onState: setResultado,
        onError: (error) => {error is NaoEncontrado ? setState(() => _tanqueResultadoPesquisa = null) : ''});
    disposers.add(d1);

    controllerAnim = AnimationController(vsync: this, duration: Duration(seconds: 1));
    animation = ColorTween(begin: Colors.grey, end: Colors.green[700]).animate(controllerAnim);

    animation.addListener(() {
      setState(() {
        color = animation.value;
      });
    });
  }

  @override
  dispose() {
    disposers.forEach((d) => d());
    super.dispose();
  }

  void setResultado(TanqueAgendado ta) {
    setState(() {
      _tanqueResultadoPesquisa = ta;
    });
    controllerAnim.forward();
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: TextFormField(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        controller: _cPesquisa,
        textCapitalization: TextCapitalization.characters,
        onChanged: (value) {
          _cPesquisa.value = TextEditingValue(text: value.toUpperCase(), selection: _cPesquisa.selection);
        },
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'Incluir tanque',
          hintText: 'Informe a placa ou n° inmetro',
          suffixIcon: TextButton(
            child: Text('Pesquisar'),
            onPressed: pesquisaTermo,
          ),
        ),
      ),
      trailing: TextButton(
        child: Text(
          'Incluir',
          style: TextStyle(color: color, fontSize: 18),
        ),
        onPressed: _tanqueResultadoPesquisa == null ? null : _adicionaVeiculo,
      ),
    );
  }

  void limpaResultado() {
    if (_tanqueResultadoPesquisa != null)
      setState(() => {
            _tanqueResultadoPesquisa = null,
            controllerAnim.reset(),
          });
  }

  void pesquisaTermo() {
    store.getVeiculo(_cPesquisa.text);
  }

  void _adicionaVeiculo() {
    store.agendaVeiculo(_tanqueResultadoPesquisa!);
  }
}
