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
  double _larguraTotal = 0;
  String cnpjProprietario = '';
  BuildContext? ctx;

  late Widget proprietarioWidget = CnpjWidget(
    titulo: 'CNPJ ou CPF',
    callback: (cnpj, valido) => cnpjProprietario = valido ? cnpj : '',
  );
  late Widget placaWidget = PlacaWidget(
    titulo: 'Informe a placa, se cadastrado',
    callback: _getTanque,
  );

  @override
  Widget build(BuildContext context) {
    ctx = context;
    _larguraTotal = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text('Cadastro de Veículo Tanque'),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: _larguraTotal / 4),
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
              child: titulo('Tanques'),
            ),
            Column(
              children: [
                _placaWidget(),
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

  // Widget _btnIncluirTanque() {
  //   return Container(
  //       child: ElevatedButton(
  //     child: Icon(Icons.add),
  //     onPressed: _incluiTanque,
  //   ));
  // }

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
            onPressed: _novoTanque,
          ),
        ),
      ),
    );
  }

  Widget _placaWidget() {
    return Container(
      alignment: Alignment.centerLeft,
      child: placaWidget,
    );
  }

  Widget _listaTanques() {
    return Container(
        width: _larguraTotal * .5,
        height: 150,
        child: tanques.isEmpty
            ? SizedBox.shrink()
            : ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: tanques.length,
                itemBuilder: (BuildContext context, int index) {
                  return _tanqueWidget(index);
                },
              ));
  }

  Widget _tanqueWidget(int index) {
    return Container(
      child: Card(
        elevation: 10,
        shadowColor: Colors.black,
        child: Container(
          padding: const EdgeInsets.all(4),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                child: Text(
                  tanques[index].placa.replaceRange(3, 3, '-'),
                  style: TextStyle(fontSize: 20),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(4),
                child: Text('${tanques[index].capacidadeTotal}L'),
              ),
              Container(
                padding: const EdgeInsets.all(4),
                child: Text('${tanques[index].compartimentos.length}C ${_somaSetas(tanques[index])}SS'),
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

  int _somaSetas(Tanque t) {
    return t.compartimentos.fold(0, (previousValue, element) => previousValue + element.setas);
  }

  void _salvaDados(BuildContext ctx) {
    if (!_validaForm()) {
      _msgTemporaria('Há campos inválidos');
      return;
    }
  }

  void _novoTanque() {
    Modular.to.pushNamed('cadastroTanque');
  }

  void _incluiTanque(Tanque t) {
    if (!tanques.contains(t)) {
      setState(() {
        tanques.add(t);
      });
    }
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
      _incluiTanque(t);
    }
  }

  void _removeTanque(int index) {
    setState(() {
      tanques.removeAt(index);
    });
  }
}
