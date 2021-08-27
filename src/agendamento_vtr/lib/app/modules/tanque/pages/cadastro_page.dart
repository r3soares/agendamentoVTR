import 'package:agendamento_vtr/app/models/empresa.dart';
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
    callback: _verificaSeProprietarioExiste,
  );
  late Widget responsavelWidget = CnpjWidget(
    titulo: 'CNPJ ou CPF do Responsável pelo Agendamento',
    callback: _verificaSeResponsavelExiste,
  );
  bool precisaCadProprietario = false;
  bool precisaCadResponsavel = false;
  bool podeSalvar = false;

  String cnpjProprietario = '';
  String cnpjResponsavel = '';

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
                        child: btnSalvar(),
                      ),
                      precisaCadProprietario || precisaCadResponsavel
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
              child: Text(precisaCadProprietario
                  ? 'Novo Proprietário'
                  : 'Novo Responsável'),
              onPressed: () => goCadastroEmpresa(),
            ),
          ),
        ],
      ),
    );
  }

  void _verificaSeProprietarioExiste(String cnpj, Empresa? proprietario) {
    cnpjProprietario = cnpj;
    if (!mounted) return;
    proprietario == null
        ? setState(() {
            precisaCadProprietario = true;
          })
        : setState(() {
            precisaCadProprietario = false;
          });
  }

  void _verificaSeResponsavelExiste(String cnpj, Empresa? responsavel) {
    cnpjResponsavel = cnpj;
    if (!mounted) return;
    responsavel == null
        ? setState(() {
            precisaCadResponsavel = true;
          })
        : setState(() {
            precisaCadResponsavel = false;
          });
  }

  void exibeAvisoCadProprietario(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content:
            Text('Proprietário não localizado. Cadastre-o para continuar')));
  }

  void goCadastroEmpresa() {
    Modular.to
        .pushNamed('/empresa/cadastro',
            arguments:
                precisaCadProprietario ? cnpjProprietario : cnpjResponsavel)
        .whenComplete(() => _validaCadastro());
  }

  _validaCadastro() {
    precisaCadProprietario
        ? _verificaSeProprietarioExiste(
            cnpjProprietario, controller.findEmpresa(cnpj: cnpjProprietario))
        : _verificaSeResponsavelExiste(
            cnpjResponsavel, controller.findEmpresa(cnpj: cnpjResponsavel));
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
