import 'package:agendamento_vtr/app/models/empresa.dart';
import 'package:agendamento_vtr/app/models/tanque.dart';
import 'package:agendamento_vtr/app/modules/empresa/controllers/empresa_controller.dart';
import 'package:agendamento_vtr/app/modules/tanque/tanque_controller.dart';
import 'package:agendamento_vtr/app/widgets/cnpj_widget.dart';
import 'package:agendamento_vtr/app/widgets/placa_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class CadastroPage extends StatefulWidget {
  const CadastroPage({Key? key}) : super(key: key);

  @override
  _CadastroPageState createState() => _CadastroPageState();
}

class _CadastroPageState extends ModularState<CadastroPage, EmpresaController> {
  final tanqueController = Modular.get<TanqueController>();
  final _formKey = GlobalKey<FormState>();
  final List<Tanque> tanques = List.empty(growable: true);
  Size? _size;
  String cnpjProprietario = '';
  BuildContext? ctx;

  late Widget proprietarioWidget = CnpjWidget(
    titulo: 'CNPJ ou CPF',
    callback: (cnpj, valido) => cnpjProprietario = valido ? cnpj : '',
  );
  late Widget placaWidget = PlacaWidget(
    titulo: 'Informe a placa',
    callback: _getTanque,
  );

  @override
  Widget build(BuildContext context) {
    ctx = context;
    _size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('Cadastro de Veículo Tanque'),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: _size!.width / 4),
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
                  _camposTanques(),
                  _camposBotoes(),
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
                Row(
                  children: [
                    _placaWidget(),
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
          child: TextButton(
            child: Text('Novo Tanque'),
            onPressed: _goTanquePage,
          ),
        ),
      ),
    );
  }

  Widget _placaWidget() {
    return Container(
      padding: const EdgeInsets.all(8),
      alignment: Alignment.centerLeft,
      child: Card(
        elevation: 4,
        shadowColor: Colors.black,
        child: placaWidget,
      ),
    );
  }

  Widget _listaTanques() {
    return SingleChildScrollView(
      child: Container(
          width: _size!.width * .5,
          height: 170,
          child: tanques.isEmpty
              ? SizedBox.shrink()
              : ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: tanques.length,
                  itemBuilder: (BuildContext context, int index) {
                    return _tanqueWidget(index);
                  },
                )),
    );
  }

  Widget _tanqueWidget(int index) {
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
                      tanques[index].placa.replaceRange(3, 3, '-'),
                      style: TextStyle(fontSize: 20),
                    ),
                    onPressed: () => _goTanquePage(tExistente: tanques[index]),
                  )),
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
    _associaPropAosTanques();
    _msgTemporaria('Dados salvos');
    Modular.to.pop();
  }

  void _associaPropAosTanques() async {
    Empresa? e = await controller.findEmpresa(cnpj: cnpjProprietario);

    for (var t in tanques) {
      t.proprietario = cnpjProprietario;
      tanqueController.salvaTanque(t);
      e?.addTanque(t.placa);
    }
  }

  void _goTanquePage({Tanque? tExistente}) {
    Modular.to.pushNamed('cadastroTanque', arguments: tExistente);
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

  void _getTanque(String placa, bool valido) async {
    if (valido) {
      final t = await tanqueController.findTanqueByPlaca(placa);
      if (t == null) {
        _msgTemporaria('Placa não localizada. Cadastre novo tanque');
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
