import 'package:agendamento_vtr/app/domain/erros.dart';
import 'package:agendamento_vtr/app/domain/log.dart';
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
import 'package:flutter_triple/flutter_triple.dart';

class TanquePage extends BaseWidgets {
  final Tanque? tanquePrevio;
  TanquePage({this.tanquePrevio});

  @override
  _TanquePageState createState() => _TanquePageState();
}

class _TanquePageState extends ModularState<TanquePage, TanqueStore> {
  final ScrollController scrollController = ScrollController();
  final _formKey = GlobalKey<FormState>();
  final List<Disposer> disposers = List.empty(growable: true);
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
    disposers.forEach((d) => d());
    store.destroy();
    super.dispose();
  }

  void _configStream() {
    var d1 = store.sTanque.observer(
      onState: (_) => _showDialogTanqueSalvo(),
      onLoading: loading,
      onError: (erro) => _exibeErro,
    );
    disposers.add(d1);
    if (widget.tanquePrevio == null) {
      var d2 = store.cPlaca.observer(
        onState: _avisaTanqueExistente,
        //onLoading: loading,
      );
      var d3 = store.cInmetro.observer(
        onState: _avisaTanqueExistente,
        //onLoading: loading,
      );
      disposers.addAll([d2, d3]);
    }
  }

  loading(bool isLoading) {
    widget.loading(isLoading, context);
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('Cadastro de Veículo Tanque'),
      ),
      body: Center(
        child: Container(
          width: size.width * .5,
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //Flexible(flex: 1, child: _titulo()),
                Flexible(flex: 3, child: buildCamposIdentificacao()),
                //Flexible(flex: 2, child: _camposDocumentacao()),
                Expanded(flex: 5, child: buildCompartimentoForm()),
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
        ),
      ),
    );
  }

  // #region Widgets
  Widget buildCamposIdentificacao() {
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
              Flexible(child: buildPlacaWidget()),
              Flexible(child: buildNumInmetroWidget()),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildCamposDocumentacao() {
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
          Flexible(child: buildDocWidget()),
        ],
      ),
    );
  }

  Widget buildTitulo() {
    return Text(
      "Tanque",
      style: TextStyle(fontSize: 20),
    );
  }

  Widget buildPlacaWidget() {
    return Container(
      padding: const EdgeInsets.all(8),
      child: placaWidget,
    );
  }

  Widget buildNumInmetroWidget() {
    return Container(
      padding: const EdgeInsets.all(8),
      child: inmetroWidget,
    );
  }

  Widget buildDocWidget() {
    return docWidget;
  }

  Widget buildCompartimentoForm() {
    return compartimentoForm;
  }

  // #endregion

  // #region Sets Tanque
  void _setPlaca(String placa, bool isValida) {
    print(isValida);
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
    if (!validaDadosPreenchidos()) return;
    store.salva(_tanque);
  }

  void _carregaTanqueExistente(Tanque tExistente) {
    Modular.to.popAndPushNamed('cadastroTanque', arguments: tExistente);
  }

  void _recarregaFormulario() {
    Modular.to.popAndPushNamed('cadastroTanque');
  }

  bool validaDadosPreenchidos() {
    if (_tanque.placa.isEmpty || _tanque.codInmetro.isEmpty) {
      _msgTemporaria('Placa e número do inmetro não podem estar vazios', Colors.yellow.shade900);
      return false;
    }
    if (_formKey.currentState == null) {
      Log.message(this, 'formKey nula');
      return false;
    }
    if (!_formKey.currentState!.validate()) {
      _msgTemporaria('Verifique os campos pendentes', Colors.yellow.shade900);
      return false;
    }
    return true;
  }

  // #endregion

  // #region Dialogs Mensagens

  _exibeErro(Falha erro) {
    Log.message(this, erro.msg);
    switch (erro.runtimeType) {
      case ErroConexao:
        {
          _msgTemporaria('Erro de conexão', Colors.red.shade900);
          break;
        }
      case ErroServidor:
        {
          _msgTemporaria('Erro no servidor', Colors.red.shade900);
          break;
        }
      case TempoExcedido:
        {
          _msgTemporaria('Tempo de conexão excedido', Colors.red.shade900);
          break;
        }
    }
  }

  void _msgTemporaria(String msg, Color cor) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      backgroundColor: cor,
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
