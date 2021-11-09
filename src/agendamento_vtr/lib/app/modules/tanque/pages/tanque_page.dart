import 'package:agendamento_vtr/app/models/compartimento.dart';
import 'package:agendamento_vtr/app/models/tanque.dart';
import 'package:agendamento_vtr/app/modules/tanque/models/arquivo.dart';
import 'package:agendamento_vtr/app/modules/tanque/stores/tanque_store.dart';
import 'package:agendamento_vtr/app/modules/tanque/widgets/compartimento_form.dart';
import 'package:agendamento_vtr/app/modules/tanque/widgets/tanque_page_widgets/doc_widget.dart';
import 'package:agendamento_vtr/app/widgets/base_widgets.dart';
import 'package:agendamento_vtr/app/widgets/input_numero_widget.dart';
import 'package:agendamento_vtr/app/widgets/placa_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class TanquePage extends BaseWidgets {
  final Tanque? tanquePrevio;
  TanquePage({this.tanquePrevio});

  @override
  _TanquePageState createState() => _TanquePageState();
}

class _TanquePageState extends ModularState<TanquePage, TanqueStore> {
  final _formKey = GlobalKey<FormState>();
  final _formKeyCodInmetro = GlobalKey<FormState>();
  late Tanque _tanque;
  late Widget placaWidget;
  late Widget inmetroWidget;
  late Widget docWidget;
  late Widget compartimentoForm;

  //late Disposer _disposer;

  @override
  void initState() {
    super.initState();
    _tanque = widget.tanquePrevio ?? Tanque();
    placaWidget = PlacaWidget(
      placaPrevia: _tanque.placa,
      callback: _setPlaca,
    );
    inmetroWidget = InputNumeroWidget(
      titulo: 'Cod. Inmetro',
      campoPrevio: _tanque.codInmetro,
      input: TipoInput.NumLetras,
      callback: _setInmetro,
      formKey: _formKeyCodInmetro,
    );
    docWidget = DocWidget(
      arquivosPrevio: _tanque.docs,
      callback: _setDocs,
    );
    // tanqueZeroWidget = TanqueZeroWidget(
    //   isZeroPrevio: _tanque.isZero,
    //   callback: _setTanqueZero,
    // );
    compartimentoForm = CompartimentoForm(
      compartimentosPrevio: _tanque.compartimentos,
      callback: _setCompartimentos,
    );

    _configStream();
  }

  @override
  void dispose() {
    super.dispose();
    //_disposer();
  }

  void _configStream() {
    store.sTanque.observer(
        onState: (_) => _showDialogTanqueSalvo(),
        onError: (erro) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Não foi possível salvar os dados. ${erro.msg}'), backgroundColor: Colors.red[900])));

    if (widget.tanquePrevio == null) {
      store.cPlaca.observer(
        onState: _avisaTanqueExistente,
        onLoading: loading,
      );
      store.cInmetro.observer(
        onState: _avisaTanqueExistente,
        onLoading: loading,
      );
    }
  }

  loading(bool isLoading) {
    widget.loading(isLoading, context);
  }

  @override
  Widget build(BuildContext context) {
    final larguraTotal = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text('Cadastro de Veículo Tanque'),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: larguraTotal / 4),
        // decoration: BoxDecoration(
        //   color: Colors.white,
        //   borderRadius: BorderRadius.only(
        //       topLeft: Radius.circular(10),
        //       topRight: Radius.circular(10),
        //       bottomLeft: Radius.circular(10),
        //       bottomRight: Radius.circular(10)),
        //   boxShadow: [
        //     BoxShadow(
        //       color: Colors.grey.withOpacity(0.5),
        //       spreadRadius: 5,
        //       blurRadius: 7,
        //       offset: Offset(0, 3), // changes position of shadow
        //     ),
        //   ],
        // ),
        // margin: EdgeInsets.all(12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(flex: 1, child: _titulo()),
            Flexible(flex: 3, child: _camposIdentificacao()),
            Flexible(flex: 2, child: _camposDocumentacao()),
            Expanded(flex: 5, child: _compartimentoForm()),
            Flexible(
              flex: 1,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  widget.btnsalvar(onPressed: _salvaDados),
                  widget.btnVoltar(),
                  //exibeBotoes()
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  // #region Widgets
  Widget _camposIdentificacao() {
    return Card(
      elevation: 4,
      shadowColor: Colors.black,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.all(12),
            child: Text(
              'Identificação',
              style: TextStyle(fontSize: 20),
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(child: _placaWidget()),
              Flexible(child: _numInmetroWidget()),
            ],
          ),
        ],
      ),
    );
  }

  Widget _camposDocumentacao() {
    return Card(
      elevation: 4,
      shadowColor: Colors.black,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            alignment: Alignment.centerLeft,
            child: Text(
              'Documentação',
              style: TextStyle(fontSize: 20),
            ),
          ),
          Flexible(child: _docWidget()),
        ],
      ),
    );
  }

  Widget _titulo() {
    return Text(
      "Tanque",
      style: TextStyle(fontSize: 20),
    );
  }

  Widget _placaWidget() {
    return Container(
      padding: const EdgeInsets.all(8),
      child: placaWidget,
    );
  }

  Widget _numInmetroWidget() {
    return Container(
      padding: const EdgeInsets.all(8),
      child: inmetroWidget,
    );
  }

  Widget _docWidget() {
    return docWidget;
  }

  Widget _compartimentoForm() {
    return compartimentoForm;
  }

  // #endregion

  // #region Sets Tanque
  void _setPlaca(String placa, bool isValida) {
    if (!isValida) return;
    _tanque.placa = placa;
    store.consultaPlaca(placa);
  }

  void _setInmetro(String campo) {
    if (campo.isEmpty) return;
    _tanque.codInmetro = campo;
    store.consultaInmetro(campo);
  }

  void _setDocs(List<Arquivo> arquivos) {
    _tanque.docs.clear();
    _tanque.docs.addAll(arquivos);
  }

  // void _setTanqueZero(bool isZero) {
  //   _tanque.isZero = isZero;
  // }

  void _setCompartimentos(List<Compartimento> compartimentos) {
    _tanque.compartimentos.clear();
    _tanque.compartimentos.addAll(compartimentos);
    _tanque.custo = store.getCusto(compartimentos);
  }

  // #endregion

  // #region Altera Formulario
  _salvaDados() {
    print('Salvando em TanquePage...');
    if (_formKey.currentState == null || _formKeyCodInmetro.currentState == null) return;
    if (!_formKey.currentState!.validate() && !_formKeyCodInmetro.currentState!.validate()) {
      _msgTemporaria('Verifique os campos pendentes');
      return;
    }
    store.salva(_tanque);
  }

  void _carregaTanqueExistente(Tanque tExistente) {
    Modular.to.popAndPushNamed('cadastroTanque', arguments: tExistente);
  }

  void _recarregaFormulario() {
    Modular.to.popAndPushNamed('cadastroTanque');
  }

  bool verificaDadosPreenchidos() {
    if (_formKey.currentState == null) return false;
    return _formKey.currentState!.validate();
  }

  // #endregion

  // #region Dialogs Mensagens
  void _msgTemporaria(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      duration: Duration(seconds: 3),
    ));
  }

  void _avisaTanqueExistente(Tanque tExistente) async {
    await _showDialogTanqueExistente(tExistente);
  }

  Future<void> _showDialogTanqueExistente(Tanque tExistente) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Veículo ${tExistente.placa} já existe'),
          content: SingleChildScrollView(
              child: Container(
            child: Text('Deseja alterar este veículo?'),
          )),
          actions: <Widget>[
            TextButton(
              child: const Text('Sim'),
              onPressed: () {
                Modular.to.pop();
                _carregaTanqueExistente(tExistente);
              },
            ),
            TextButton(
              child: const Text('Não'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _showDialogTanqueSalvo() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Veículo ${_tanque.placa} salvo com sucesso'),
          content: SingleChildScrollView(
              child: Container(
            child: Text('Deseja incluir mais veículos?'),
          )),
          actions: <Widget>[
            TextButton(
              child: const Text('Sim'),
              onPressed: () {
                Navigator.of(context).pop();
                _recarregaFormulario();
              },
            ),
            TextButton(
              child: const Text('Não'),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
  // #endregion
}
