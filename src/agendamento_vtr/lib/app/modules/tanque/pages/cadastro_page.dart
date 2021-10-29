import 'package:agendamento_vtr/app/models/tanque.dart';
import 'package:agendamento_vtr/app/modules/tanque/stores/tanque_store.dart';
import 'package:agendamento_vtr/app/widgets/base_widgets.dart';
import 'package:agendamento_vtr/app/widgets/cnpj_widget.dart';
import 'package:agendamento_vtr/app/widgets/placa_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:collection/collection.dart';

class CadastroPage extends BaseWidgets {
  CadastroPage({Key? key});

  @override
  _CadastroPageState createState() => _CadastroPageState();
}

class _CadastroPageState extends ModularState<CadastroPage, TanqueStore> {
  final _formKey = GlobalKey<FormState>();
  final _scrollController = ScrollController();
  final _cPesquisaPlaca = TextEditingController();
  final List<Tanque> tanques = List.empty(growable: true);
  Size? _size;
  String cnpjProprietario = '';
  //late Disposer _disposer;

  late Widget proprietarioWidget = CnpjWidget(
    titulo: 'CNPJ ou CPF',
    callback: (cnpj, valido) => _setProprietario(cnpj, valido),
  );
  late Widget placaWidget = PlacaWidget(
    titulo: 'Buscar placa',
    callback: _getTanque,
  );

  @override
  void initState() {
    super.initState();
    _configStream();
  }

  void _configStream() {
    store.cPlaca.observer(
        onState: (t) => {_incluiTanque(t), limpaTermo(), _msgTemporaria('${t.placa} adicionado.')},
        onLoading: loading,
        onError: (_) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Não localizado.'))));

    store.cProprietario.observer(
        onState: (lista) => {
              for (var t in lista)
                {
                  _incluiTanque(t),
                },
              _msgTemporaria('Encontrado veículo(s) associados a este proprietário.'),
            },
        onLoading: loading);

    store.sTanques.observer(
      onState: (t) => _showDialogTanquesSalvos(),
      onLoading: loading,
      onError: (erro) => ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Não foi possível salvar os dados. ${erro.msg}'), backgroundColor: Colors.red[900])),
    );
  }

  @override
  Widget build(BuildContext context) {
    _size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('Cadastro de Veículo Tanque'),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: _size!.width / 4),
        child: SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _camposPropResp(),
                _camposTanques(),
                _camposBotoes(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  loading(bool isLoading) {
    widget.loading(isLoading, context);
  }

  Widget _camposPropResp() {
    return Container(
      margin: EdgeInsets.only(top: 30),
      //width: larguraTotal * .4,
      child: Card(
        elevation: 4,
        shadowColor: Colors.black,
        child: Column(
          children: [
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.all(4),
              child: titulo('Proprietário'),
            ),
            _buildCNPJWidget()
          ],
        ),
      ),
    );
  }

  Widget _buildCNPJWidget() {
    return Container(
      padding: EdgeInsets.only(bottom: 15, left: 12, right: MediaQuery.of(context).size.width * .3),
      child: Form(
        child: proprietarioWidget,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        key: _formKey,
      ),
    );
  }

  Widget _camposBotoes() {
    return Row(
      children: [
        widget.btnsalvar(onPressed: _salvaDados),
        widget.btnVoltar(),
      ],
    );
  }

  Widget _camposTanques() {
    return Container(
      //width: larguraTotal * .4,
      child: Card(
        elevation: 4,
        shadowColor: Colors.black,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.all(4),
              child: titulo('Tanques'),
            ),
            Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _pesquisaPlaca(), //_placaWidget(),
                    btnTanque(),
                  ],
                ),
                _listaTanques(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget titulo(String titulo) {
    return Container(
        padding: EdgeInsets.all(8),
        child: Text(
          titulo,
          style: TextStyle(fontSize: 20),
        ));
  }

  Widget btnTanque() {
    return Container(
      padding: const EdgeInsets.all(8),
      child: TextButton(
        child: Text('Novo Tanque'),
        onPressed: _goTanquePage,
      ),
    );
  }

  Widget _pesquisaPlaca() {
    return Container(
      width: 250,
      padding: const EdgeInsets.all(8),
      child: ListTile(
          title: TextFormField(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        controller: _cPesquisaPlaca,
        textCapitalization: TextCapitalization.characters,
        onChanged: (value) {
          _cPesquisaPlaca.value = TextEditingValue(text: value.toUpperCase(), selection: _cPesquisaPlaca.selection);
        },
        maxLength: 7,
        validator: _validaPlaca,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'Pesquisar',
          hintText: 'Informe a placa',
          suffixIcon: IconButton(
            onPressed: limpaTermo,
            icon: Icon(Icons.clear),
            splashRadius: 5,
          ),
        ),
      )),
    );
  }

  Widget _listaTanques() {
    return Container(
        width: _size!.width * .5,
        height: 170,
        child: tanques.isEmpty
            ? SizedBox.shrink()
            : Scrollbar(
                interactive: true,
                isAlwaysShown: true,
                controller: _scrollController,
                child: ListView.builder(
                  controller: _scrollController,
                  scrollDirection: Axis.horizontal,
                  itemCount: tanques.length,
                  shrinkWrap: true,
                  itemBuilder: (BuildContext context, int index) {
                    return _tanqueWidget(index);
                  },
                ),
              ));
  }

  Widget _tanqueWidget(int index) {
    Tanque t = tanques[index];
    return Container(
      padding: const EdgeInsets.all(8),
      child: Card(
        elevation: 10,
        shadowColor: Colors.black,
        child: Container(
          padding: const EdgeInsets.all(4),
          child: Column(
            children: [
              Container(
                  padding: const EdgeInsets.all(8),
                  child: TextButton(
                    child: Text(
                      t.placa.replaceRange(3, 3, '-'),
                      style: TextStyle(fontSize: 20),
                    ),
                    onPressed: () => _goTanquePage(tExistente: t),
                  )),
              Container(
                padding: const EdgeInsets.all(4),
                child: t.capacidadeTotal > 0 ? Text('${t.capacidadeTotal}L') : Text('Capacidade'),
              ),
              Container(
                padding: const EdgeInsets.all(4),
                child: t.capacidadeTotal > 0
                    ? Text('${t.compartimentos.length}C ${formataExibicaoSetas(t)}')
                    : Text('não informada'),
              ),
              Container(
                child: IconButton(
                  splashRadius: 10,
                  icon: Icon(
                    Icons.close,
                    color: Colors.red[900],
                  ),
                  onPressed: () => _removeTanque(index),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _setProprietario(String cnpj, bool valido) {
    cnpjProprietario = valido ? cnpj : '';
    // if (valido) {
    //   store.consultaProprietario(cnpj);
    // }
  }

  int _somaSetas(Tanque t) {
    return t.compartimentos.fold(0, (previousValue, element) => previousValue + element.setas);
  }

  String formataExibicaoSetas(Tanque t) {
    int setas = _somaSetas(t);
    return setas > 0 ? '${setas}SS' : '';
  }

  _salvaDados() {
    if (!_validaForm()) {
      _msgTemporaria('Há campos inválidos');
      return;
    }
    _associaPropAosTanques();
  }

  void _associaPropAosTanques() {
    for (var t in tanques) {
      t.proprietario = cnpjProprietario;
    }
    store.salvaMuitos(tanques);
  }

  void _goTanquePage({Tanque? tExistente}) {
    Modular.to.pushNamed('cadastroTanque', arguments: tExistente);
  }

  void _incluiTanque(Tanque t) {
    Tanque? tExiste = tanques.firstWhereOrNull((element) => element.codInmetro == t.codInmetro);
    if (tExiste == null) {
      setState(() {
        tanques.add(t);
      });
    }
  }

  void _msgTemporaria(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  bool _validaForm() {
    if (_formKey.currentState == null) return false;
    return _formKey.currentState!.validate();
  }

  void _getTanque(String placa, bool valido) async {
    if (valido) {
      store.consultaPlaca(placa);
    }
  }

  void _removeTanque(int index) {
    Tanque t = tanques.removeAt(index);
    t.proprietario = null;
    store.salva(t);
    setState(() {});
  }

  Future<void> _showDialogTanquesSalvos() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Salvo com sucesso!'),
          content: SingleChildScrollView(
              child: Container(
            child: Text(tanques.length > 1
                ? '${tanques.length} veículos foram associados ao proprietário $cnpjProprietario.'
                : '${tanques[0].placa} foi associado ao proprietário $cnpjProprietario.'),
          )),
          actions: <Widget>[
            TextButton(
              child: const Text('ok'),
              onPressed: () {
                Modular.to.pop();
              },
            ),
          ],
        );
      },
    );
  }

  String? _validaPlaca(String? value) {
    if (value == null || value.isEmpty) return null;
    if (value.length != 7) return 'Placa inválida';
    if (!store.validaPlaca(value)) return 'Placa inválida';
    _getTanque(value, true);
    return null;
  }

  void limpaTermo() {
    _cPesquisaPlaca.clear();
  }
}
