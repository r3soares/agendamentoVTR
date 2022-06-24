// ignore_for_file: unnecessary_statements

import 'package:agendamento_vtr/app/domain/erros.dart';
import 'package:agendamento_vtr/app/models/responsavel.dart';
import 'package:agendamento_vtr/app/models/tanque.dart';
import 'package:agendamento_vtr/app/modules/agendamento/models/tanque_agendado.dart';
import 'package:agendamento_vtr/app/modules/agendamento/stores/inclui_pendente_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_triple/flutter_triple.dart';
import 'package:uuid/uuid.dart';

class IncluiPendenteWidget extends StatefulWidget {
  const IncluiPendenteWidget({Key? key}) : super(key: key);

  @override
  _IncluiPendenteWidgetState createState() => _IncluiPendenteWidgetState();
}

class _IncluiPendenteWidgetState
    extends ModularState<IncluiPendenteWidget, IncluiPendenteStore> {
  final TextEditingController _cPesquisa = TextEditingController();
  final List<Disposer> disposers = List.empty(growable: true);
  bool pesquisaInmetro = false;

  @override
  void initState() {
    super.initState();
    var d1 = store.blocPesquisa
        .observer(onState: setResultado, onError: naoEncontrou);
    var d2 =
        store.blocAgenda.observer(onState: preAgendou, onError: naoAgendou);
    var d3 = store.blocPendentes.observer(onState: listaFiltrada);
    disposers.addAll([d1, d2, d3]);
  }

  @override
  dispose() {
    disposers.forEach((d) => d());
    super.dispose();
  }

  void setResultado(Tanque t) {
    store.agendaVeiculo(t, Responsavel(Uuid().v1(), ""));
    setState(() {});
  }

  void naoEncontrou(Falha erro) {
    if (!pesquisaInmetro) {
      store.getVeiculoByInmetro(_cPesquisa.text);
      pesquisaInmetro = true;
      return;
    }
    if (erro is NaoEncontrado) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Veículo não encontrado'),
              content: Text('Deseja cadastrar este veículo?'),
              actions: <Widget>[
                TextButton(
                  onPressed: () async => {
                    Navigator.pop(context, 'OK'),
                    Modular.to
                        .pushNamed('/tanque/cadastroTanque')
                        .whenComplete(() => {
                              store.getVeiculoByPlaca(_cPesquisa.text),
                            })
                  },
                  child: const Text('Sim'),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context, 'Cancel'),
                  child: const Text('Não'),
                ),
              ],
            );
          });
    }
    resetState();
  }

  goCadastroTanque() {
    if (_cPesquisa.text.isEmpty) return;
    Modular.to
        .pushNamed('/tanque/cadastroTanque')
        .whenComplete(() => {store.getVeiculoByPlaca(_cPesquisa.text)});
    store.filtraLista('');
    _cPesquisa.clear();
    resetState();
  }

  void naoAgendou(Falha erro) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('Erro ao agendar: ${erro.msg}')));
    _cPesquisa.clear();
    resetState();
  }

  void preAgendou(TanqueAgendado agendado) {
    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veículo pré agendado com sucesso.')));
    store.filtraLista(agendado.tanque.placa);
    resetState();
  }

  void listaFiltrada(List<TanqueAgendado> pendentes) {}

  void resetState() {
    setState(() {
      pesquisaInmetro = false;
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
          _cPesquisa.value = TextEditingValue(
              text: value.toUpperCase(), selection: _cPesquisa.selection);
        },
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'Pesquisar ou incluir veículo',
          hintText: 'Informe a placa ou n° inmetro',
          suffixIcon: TextButton(
            child: Text('Buscar'),
            onPressed: store.blocPesquisa.isLoading ? null : pesquisaTermo,
          ),
        ),
      ),
    );
  }

  void pesquisaTermo() {
    if (_cPesquisa.text.isEmpty) return;
    store.getVeiculoByPlaca(_cPesquisa.text);
  }
}
