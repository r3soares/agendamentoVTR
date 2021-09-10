import 'package:agendamento_vtr/app/models/tanque.dart';
import 'package:agendamento_vtr/app/modules/empresa/controllers/empresa_controller.dart';
import 'package:agendamento_vtr/app/modules/tanque/tanque_controller.dart';
import 'package:agendamento_vtr/app/widgets/cnpj_widget.dart';
import 'package:agendamento_vtr/app/widgets/placa_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class CadastroPage extends StatefulWidget {
  final largura = .5;
  const CadastroPage({Key? key}) : super(key: key);

  @override
  _CadastroPageState createState() => _CadastroPageState();
}

class _CadastroPageState extends ModularState<CadastroPage, EmpresaController> {
  final tanqueController = Modular.get<TanqueController>();
  final _formKey = GlobalKey<FormState>();
  final List<Tanque> tanques = List.empty(growable: true);

  String cnpjProprietario = '';
  String cnpjResponsavel = '';
  bool podeInserirTanque = false;
  BuildContext? ctx;

  late Widget proprietarioWidget = CnpjWidget(
    titulo: 'CNPJ ou CPF',
    callback: (cnpj, valido) => cnpjProprietario = valido ? cnpj : '',
  );
  late Widget responsavelWidget = CnpjWidget(
    titulo: 'CNPJ ou CPF do Responsável pelo Agendamento',
    callback: (cnpj, valido) => cnpjResponsavel = valido ? cnpj : '',
  );
  late Widget placaWidget = PlacaWidget(
    titulo: 'Informe a placa, se cadastrado',
    callback: _getTanque,
  );

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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _camposPropResp(),
                  _camposBotoes(),
                  _camposTanques(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _camposPropResp() {
    return Container(
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
            Column(
              children: [
                proprietarioWidget,
                //responsavelWidget,
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _camposBotoes() {
    return Row(
      children: [
        btnSalvar(),
        btnTanque(),

        //exibeBotoes()
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
              child: titulo('Tanques do proprietário'),
            ),
            Column(
              children: [
                _placaWidget(),
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

  Widget btnSalvar() {
    return Container(
      padding: const EdgeInsets.all(8),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton(
            child: Text('Salvar'),
            onPressed: () => _salvaDados(ctx!),
          ),
        ),
      ),
    );
  }

  Widget btnTanque() {
    return Container(
      padding: const EdgeInsets.all(8),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton(
            child: Text('Novo Tanque'),
            onPressed: podeInserirTanque ? () => _novoTanque(ctx!) : null,
          ),
        ),
      ),
    );
  }

  Widget _placaWidget() {
    return Container(
      child: placaWidget,
    );
  }

  void _salvaDados(BuildContext ctx) {
    if (!_validaForm()) {
      setState(() {
        podeInserirTanque = false;
      });

      _msgTemporaria('Há campos inválidos');
      return;
    }
    setState(() {
      podeInserirTanque = true;
    });
  }

  void _novoTanque(BuildContext ctx) {
    if (!podeInserirTanque) {
      _msgTemporaria('Salve os dados antes de continuar');
      return;
    }
    Modular.to.pushNamed('cadastroTanque');
  }

  void _msgTemporaria(String msg) {
    ScaffoldMessenger.of(ctx!).showSnackBar(SnackBar(content: Text(msg)));
  }

  bool _validaForm() {
    if (_formKey.currentState == null) return false;
    return _formKey.currentState!.validate();
  }

  void _getTanque(String placa, bool valido) {
    if (valido) {
      final t = tanqueController.findTanqueByPlaca(placa);
      if (t == null) {
        _msgTemporaria('Placa não localizada');
        return;
      }
      setState(() {
        tanques.add(t);
      });
    }
  }

  void removeTanque(int index) {
    setState(() {
      tanques.removeAt(index);
    });
  }
}
