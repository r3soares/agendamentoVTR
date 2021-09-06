import 'package:agendamento_vtr/app/modules/empresa/controllers/empresa_controller.dart';
import 'package:agendamento_vtr/app/widgets/cnpj_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class CadastroPage extends StatefulWidget {
  final largura = .5;
  const CadastroPage({Key? key}) : super(key: key);

  @override
  _CadastroPageState createState() => _CadastroPageState();
}

class _CadastroPageState extends ModularState<CadastroPage, EmpresaController> {
  final _formKey = GlobalKey<FormState>();
  String cnpjProprietario = '';
  String cnpjResponsavel = '';
  bool podeInserirTanque = false;
  late Widget proprietarioWidget = CnpjWidget(
    titulo: 'CNPJ ou CPF do Proprietário',
    callback: (cnpj, valido) => cnpjProprietario = valido ? cnpj : '',
  );
  late Widget responsavelWidget = CnpjWidget(
    titulo: 'CNPJ ou CPF do Responsável pelo Agendamento',
    callback: (cnpj, valido) => cnpjResponsavel = valido ? cnpj : '',
  );

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
                  proprietarioWidget,
                  responsavelWidget,
                  Row(
                    children: [
                      btnSalvar(context),
                      btnTanque(context),
                      //exibeBotoes()
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
          "Proprietário e Responsável",
          style: TextStyle(fontSize: 20),
        ));
  }

  Widget btnSalvar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton(
            child: Text('Salvar'),
            onPressed: () => _salvaDados(context),
          ),
        ),
      ),
    );
  }

  Widget btnTanque(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton(
            child: Text('Novo Tanque'),
            onPressed: podeInserirTanque ? () => _novoTanque(context) : null,
          ),
        ),
      ),
    );
  }

  void _salvaDados(BuildContext ctx) {
    if (!_validaForm()) {
      setState(() {
        podeInserirTanque = false;
      });

      exibeAvisoCamposInvalidos(ctx, 'Há campos inválidos');
      return;
    }
    setState(() {
      podeInserirTanque = true;
    });
  }

  void _novoTanque(BuildContext ctx) {
    if (!podeInserirTanque) {
      exibeAvisoCamposInvalidos(ctx, 'Salve os dados antes de continuar');
      return;
    }
    Modular.to.pushNamed('cadastroTanque');
  }

  void exibeAvisoCamposInvalidos(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  // String? validateEmail(String? value) {
  //   if (value == null || value.isEmpty) return 'Informe um e-mail';
  //   String pattern =
  //       r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]"
  //       r"{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]"
  //       r"{0,253}[a-zA-Z0-9])?)*$";
  //   RegExp regex = new RegExp(pattern);
  //   if (!regex.hasMatch(value)) return 'E-mail inválido';
  //   return null;
  // }

  bool _validaForm() {
    if (_formKey.currentState == null) return false;
    return _formKey.currentState!.validate();
  }
}
