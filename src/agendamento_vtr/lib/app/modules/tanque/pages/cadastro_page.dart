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

class _CadastroPageState extends ModularState<CadastroPage, EmpresaController> {
  final _formKey = GlobalKey<FormState>();
  late Widget proprietarioWidget = CnpjWidget(
    titulo: 'CNPJ ou CPF do Proprietário',
    callback: (_, valido) => null,
  );
  late Widget responsavelWidget = CnpjWidget(
    titulo: 'CNPJ ou CPF do Responsável pelo Agendamento',
    callback: (_, valido) => null,
  );
  bool proprietarioValido = false;
  bool responsavelValido = false;

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
                      Container(
                        padding: EdgeInsets.all(8),
                        child: btnSalvar(context),
                      ),
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
          "Dados do Tanque",
          style: TextStyle(fontSize: 20),
        ));
  }

  Widget btnSalvar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                child: Text('Salvar'),
                onPressed: () => _salvaDados(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _salvaDados(BuildContext ctx) {
    if (!_validaForm()) {
      exibeAvisoCadProprietario(ctx);
      return;
    }
  }

  void exibeAvisoCadProprietario(BuildContext context) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('Há campos inválidos')));
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

  bool _validaForm() {
    if (_formKey.currentState == null) return false;
    return _formKey.currentState!.validate();
  }
}
