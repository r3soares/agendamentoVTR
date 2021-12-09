// ignore_for_file: unnecessary_statements

import 'package:agendamento_vtr/app/domain/erros.dart';
import 'package:agendamento_vtr/app/models/tanque.dart';
import 'package:agendamento_vtr/app/modules/agendamento/models/tanque_agendado.dart';
import 'package:agendamento_vtr/app/modules/agendamento/stores/inclui_pendente_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_triple/flutter_triple.dart';

class IncluiPendenteWidget extends StatefulWidget {
  const IncluiPendenteWidget({Key? key}) : super(key: key);

  @override
  _IncluiPendenteWidgetState createState() => _IncluiPendenteWidgetState();
}

class _IncluiPendenteWidgetState extends ModularState<IncluiPendenteWidget, IncluiPendenteStore> {
  final TextEditingController _cPesquisa = TextEditingController();
  final List<Disposer> disposers = List.empty(growable: true);
  bool pesquisando = false;
  bool podePesquisar = false;
  bool pesquisandoPlaca = false;

  @override
  void initState() {
    super.initState();
    var d1 = store.blocPesquisa.observer(onState: setResultado, onError: naoEncontrou);
    var d2 = store.blocAgenda.observer(onState: preAgendou, onError: naoAgendou);
    var d3 = store.blocPendentes.observer(onState: listaFiltrada);
    disposers.addAll([d1, d2, d3]);
  }

  @override
  dispose() {
    disposers.forEach((d) => d());
    super.dispose();
  }

  void setResultado(Tanque t) {
    store.agendaVeiculo(t);
  }

  void naoEncontrou(Falha erro) {
    if (pesquisandoPlaca == true) {
      setState(() {
        pesquisandoPlaca = false;
      });
      store.getVeiculoByInmetro(_cPesquisa.text);
      return;
    }
    erro is NaoEncontrado ? goCadastroTanque() : '';
    resetState();
  }

  goCadastroTanque() {
    if (_cPesquisa.text.isEmpty) return;
    Modular.to.pushNamed('/tanque/cadastroTanque').whenComplete(() => {store.getVeiculoByPlaca(_cPesquisa.text)});
    store.filtraLista('');
    _cPesquisa.clear();
    resetState();
  }

  void naoAgendou(Falha erro) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erro ao agendar: ${erro.msg}')));
    _cPesquisa.clear();
    resetState();
  }

  void preAgendou(TanqueAgendado agendado) {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Veículo pré agendado com sucesso.')));
    store.filtraLista(agendado.tanque.placa);
    resetState();
  }

  void listaFiltrada(List<TanqueAgendado> pendentes) {
    setState(() {
      podePesquisar = pendentes.isEmpty;
    });
  }

  void resetState() {
    setState(() {
      pesquisando = false;
      podePesquisar = false;
      pesquisandoPlaca = false;
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
          store.filtraLista(_cPesquisa.text);
        },
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'Pesquisar ou incluir veículo',
          hintText: 'Informe a placa ou n° inmetro',
          suffixIcon: TextButton(
            child: Text('Incluir'),
            onPressed: pesquisando || !podePesquisar ? null : pesquisaTermo,
          ),
        ),
      ),
    );
  }

  void pesquisaTermo() {
    setState(() {
      pesquisando = true;
      pesquisandoPlaca = true;
    });
    store.getVeiculoByPlaca(_cPesquisa.text);
  }
}
