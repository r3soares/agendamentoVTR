// ignore_for_file: unnecessary_statements

import 'package:agendamento_vtr/app/domain/erros.dart';
import 'package:agendamento_vtr/app/modules/agendamento/models/tanque_agendado.dart';
import 'package:agendamento_vtr/app/modules/agendamento/stores/inclui_agendado_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_triple/flutter_triple.dart';

class IncluiAgendadoWidget extends StatefulWidget {
  const IncluiAgendadoWidget({Key? key}) : super(key: key);

  @override
  _IncluiAgendadoWidgetState createState() => _IncluiAgendadoWidgetState();
}

class _IncluiAgendadoWidgetState extends ModularState<IncluiAgendadoWidget, IncluiAgendadoStore> {
  final TextEditingController _cPesquisa = TextEditingController();
  final List<Disposer> disposers = List.empty(growable: true);
  bool pesquisando = false;

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
    setState(() {
      _cPesquisa.text = '';
      pesquisando = false;
    });
  }

  void agendou(Object mb) {
    setState(() {
      _cPesquisa.text = '';
      pesquisando = false;
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
            onPressed: pesquisando ? null : pesquisaTermo,
          ),
        ),
      ),
    );
  }

  void pesquisaTermo() {
    if (_cPesquisa.text.isNotEmpty) {
      setState(() {
        pesquisando = true;
      });
      store.getVeiculo(_cPesquisa.text);
    }
  }

  agendaVeiculo(TanqueAgendado ta) => store.agendaVeiculo(ta);
}
