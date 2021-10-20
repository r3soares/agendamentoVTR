// ignore_for_file: unnecessary_statements

import 'package:agendamento_vtr/app/domain/erros.dart';
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

class _PesquisaWidgetState extends ModularState<PesquisaWidget, PesquisaAgendaDoDiaStore> {
  final TextEditingController _cPesquisa = TextEditingController();
  final List<Disposer> disposers = List.empty(growable: true);
  //TanqueAgendado? _tanqueResultadoPesquisa;
  //Color? color = Colors.grey;

  @override
  void initState() {
    super.initState();
    var d1 = store.blocPesquisa.observer(onState: setResultado, onError: naoEncontrou);
    var d2 = store.blocAgenda.observer(onState: agendou, onError: naoAgendou);
    disposers.addAll([d1, d2]);
  }

  @override
  dispose() {
    disposers.forEach((d) => d());
    super.dispose();
  }

  void setResultado(Object mb) {
    agendaVeiculo(mb as TanqueAgendado);
  }

  void naoEncontrou(Falha erro) {
    erro is NaoEncontrado
        ? ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Veículo não encontrado')))
        : '';
  }

  void naoAgendou(Falha erro) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erro ao agendar: ${erro.msg}')));
  }

  void agendou(Object mb) {
    setState(() {
      _cPesquisa.text = '';
    });
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
            child: Text('Incluir'),
            onPressed: pesquisaTermo,
          ),
        ),
      ),
    );
  }

  void pesquisaTermo() {
    if (_cPesquisa.text.isNotEmpty) store.getVeiculo(_cPesquisa.text);
  }

  agendaVeiculo(TanqueAgendado ta) => store.agendaVeiculo(ta);
}
