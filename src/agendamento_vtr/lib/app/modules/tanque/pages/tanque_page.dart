import 'package:agendamento_vtr/app/models/compartimento.dart';
import 'package:agendamento_vtr/app/models/tanque.dart';
import 'package:agendamento_vtr/app/modules/tanque/models/arquivo.dart';
import 'package:agendamento_vtr/app/modules/tanque/tanque_controller.dart';
import 'package:agendamento_vtr/app/modules/tanque/widgets/compartimento_form.dart';
import 'package:agendamento_vtr/app/modules/tanque/widgets/tanque_page_widgets/doc_widget.dart';
import 'package:agendamento_vtr/app/modules/tanque/widgets/tanque_page_widgets/tanque_zero_widget.dart';
import 'package:agendamento_vtr/app/widgets/input_numero_widget.dart';
import 'package:agendamento_vtr/app/widgets/placa_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class TanquePage extends StatefulWidget {
  const TanquePage({Key? key}) : super(key: key);

  @override
  _TanquePageState createState() => _TanquePageState();
}

class _TanquePageState extends ModularState<TanquePage, TanqueController> {
  final _formKey = GlobalKey<FormState>();
  BuildContext? ctx;
  Tanque _tanque = Tanque();
  late Widget placaWidget;
  late Widget inmetroWidget;
  late Widget docWidget;
  late Widget tanqueZeroWidget;
  late Widget compartimentoForm;

  @override
  void initState() {
    super.initState();
    placaWidget = PlacaWidget(callback: _setPlaca);
    inmetroWidget = InputNumeroWidget(callback: _setInmetro);
    docWidget = DocWidget(callback: _setDocs);
    tanqueZeroWidget = TanqueZeroWidget(callback: _setTanqueZero);
    compartimentoForm = CompartimentoForm(callback: _setCompartimentos);
  }

  @override
  Widget build(BuildContext context) {
    ctx = context;
    final larguraTotal = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text('Cadastro de Veículo Tanque'),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: larguraTotal / 4),
        child: Form(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          key: _formKey,
          child: SingleChildScrollView(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
              margin: EdgeInsets.all(12),
              width: larguraTotal * .6,
              child: Container(
                padding: EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _titulo(),
                    _camposIdentificacao(),
                    _camposDocumentacao(),
                    _compartimentoForm(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        btnSalvar(),
                        btnCancelar(),
                        //exibeBotoes()
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _camposIdentificacao() {
    return Container(
      //width: larguraTotal * .4,
      child: Card(
        elevation: 4,
        shadowColor: Colors.black,
        child: Column(
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
              children: [
                _placaWidget(),
                _numInmetroWidget(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _camposDocumentacao() {
    return Container(
        child: Card(
      elevation: 4,
      shadowColor: Colors.black,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            alignment: Alignment.centerLeft,
            child: Text(
              'Documentação',
              style: TextStyle(fontSize: 20),
            ),
          ),
          Row(
            children: [
              _tanqueZeroWidget(),
              _docWidget(),
            ],
          ),
        ],
      ),
    ));
  }

  Widget btnSalvar() {
    return Container(
      padding: EdgeInsets.all(8),
      child: ElevatedButton(
        child: Text('Salvar'),
        onPressed: () => {},
      ),
    );
  }

  Widget btnCancelar() {
    return Container(
      padding: EdgeInsets.all(8),
      child: TextButton(
        child: Text('Cancelar'),
        onPressed: () => {},
      ),
    );
  }

  Widget _titulo() {
    return Container(
        padding: EdgeInsets.all(8),
        child: Text(
          "Tanque",
          style: TextStyle(fontSize: 20),
        ));
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
    return Container(
      padding: const EdgeInsets.all(8),
      child: docWidget,
    );
  }

  Widget _tanqueZeroWidget() {
    return Container(
      padding: const EdgeInsets.all(8),
      child: tanqueZeroWidget,
    );
  }

  Widget _compartimentoForm() {
    return Container(
      child: compartimentoForm,
    );
  }

  bool verificaDadosPreenchidos() {
    if (_formKey.currentState == null) return false;
    return _formKey.currentState!.validate();
  }

  void _setPlaca(String placa, bool isValida) {
    if (!isValida) return;
    final Tanque? tanqueExistente = controller.findTanqueByPlaca(placa);
    if (tanqueExistente != null) {
      _avisaTanqueExistente(tanqueExistente);
    }
    _tanque.placa = placa;
  }

  void _setInmetro(int num) {
    if (num < 1) return;
    final Tanque? tanqueExistente = controller.findTanqueByinmetro(num);
    if (tanqueExistente != null) {
      _avisaTanqueExistente(tanqueExistente);
    }
    _tanque.numInmetro = num;
  }

  void _setDocs(List<Arquivo> arquivos) {
    _tanque.docs.clear();
    _tanque.docs.addAll(arquivos);
  }

  void _setTanqueZero(bool isZero) {
    _tanque.isZero = isZero;
  }

  void _setCompartimentos(List<Compartimento> compartimentos) {
    _tanque.compartimentos.clear();
    _tanque.compartimentos.addAll(compartimentos);
  }

  void _avisaTanqueExistente(Tanque tExistente) {
    ScaffoldMessenger.of(ctx!).showSnackBar(SnackBar(
      content: Text('Veículo ${tExistente.placa} já existe'),
      duration: Duration(seconds: 5),
    ));
  }
  // void _populaTanqueExistente(Tanque tExistente) {
  //   setState(() {
  //     _tanque = tExistente;
  //     placaWidget = PlacaWidget(
  //       callback: _setPlaca,
  //       placaPrevia: tExistente.placa,
  //     );
  //     inmetroWidget = InputNumeroWidget(
  //       callback: _setInmetro,
  //       numeroPrevio: tExistente.numInmetro,
  //     );
  //     docWidget = DocWidget(
  //       callback: _setDocs,
  //       arquivosPrevio: tExistente.docs,
  //     );
  //     tanqueZeroWidget = TanqueZeroWidget(
  //       callback: _setTanqueZero,
  //       isZeroPrevio: tExistente.isZero,
  //     );
  //       compartimentoForm = CompartimentoForm(
  //       callback: _setCompartimentos,
  //       compartimentosPrevio: tExistente.compartimentos,
  //     );
  //   });
  // }
}
