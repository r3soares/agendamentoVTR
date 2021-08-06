import 'package:agendamento_vtr/app/modules/empresa/controllers/empresa_controller.dart';
import 'package:agendamento_vtr/app/modules/empresa/widgets/proprietario_page_widgets/cnpj_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class CadastroPage extends StatefulWidget {
  final largura = .5;
  const CadastroPage({Key? key}) : super(key: key);

  @override
  _CadastroPageState createState() => _CadastroPageState();
}

class _CadastroPageState extends State<CadastroPage> {
  final _formKey = GlobalKey<FormState>();
  final controller = Modular.get<EmpresaController>();
  bool precisaCadProprietario = false;
  bool podeSalvar = false;

  @override
  void initState() {
    super.initState();
    controller.addListener(verificaSeProprietarioExiste);
  }

  @override
  Widget build(BuildContext context) {
    final larguraTotal = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text('Novo Tanque'),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: larguraTotal / 4),
        child: Form(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          key: _formKey,
          child: SingleChildScrollView(
            child: Container(
              width: larguraTotal * .5,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  titulo(),
                  CnpjWidget(),
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(8),
                        child: btnSalvar(),
                      ),
                      precisaCadProprietario
                          ? Container(
                              padding: EdgeInsets.all(8),
                              child: btnCadProprietario(),
                            )
                          : SizedBox.shrink()
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget titulo() {
    return Container(
        padding: EdgeInsets.all(8),
        child: Text(
          "Dados do Tanque",
          style: TextStyle(fontSize: 20),
        ));
  }

  Widget btnSalvar() {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              child: Text('Salvar'),
              onPressed:
                  !precisaCadProprietario && podeSalvar ? () => {} : null,
            ),
          ),
        ],
      ),
    );
  }

  Widget btnCadProprietario() {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              child: Text('Cadastrar Proprietário'),
              onPressed: () => goCadastroEmpresa(),
            ),
          ),
        ],
      ),
    );
  }

  void verificaSeProprietarioExiste() {
    if (!mounted) return;
    controller.findEmpresa() == null
        ? setState(() {
            precisaCadProprietario = true;
          })
        : setState(() {
            precisaCadProprietario = false;
          });
  }

  void goCadastroEmpresa() {
    controller.removeListener(verificaSeProprietarioExiste);
    Modular.to
        .pushNamed('/empresa/cadastro', arguments: controller.empresa.cnpj)
        .whenComplete(
            () => controller.addListener(verificaSeProprietarioExiste));
  }

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) return 'Informe um e-mail';
    String pattern =
        r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]"
        r"{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]"
        r"{0,253}[a-zA-Z0-9])?)*$";
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value)) return 'E-mail inválido';
    return null;
  }

  bool verificaDadosPreenchidos() {
    if (_formKey.currentState == null) return false;
    return _formKey.currentState!.validate();
  }
}
