import 'dart:async';

import 'package:agendamento_vtr/app/models/empresa.dart';
import 'package:agendamento_vtr/app/modules/empresa/controllers/empresa_controller.dart';
import 'package:agendamento_vtr/app/widgets/cnpj_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:rxdart/rxdart.dart';

class CadastroPage extends StatefulWidget {
  final String preCadastro;
  final largura = .5;
  const CadastroPage({this.preCadastro = ''});

  @override
  _CadastroPageState createState() => _CadastroPageState();
}

class _CadastroPageState extends ModularState<CadastroPage, EmpresaController> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _cRazaSocialProp = TextEditingController();

  final TextEditingController _cTelefone = TextEditingController();

  final TextEditingController _cEmail = TextEditingController();

  late StreamController<String> pesquisaEmpresa;
  late StreamController<BuildContext> salvaEmpresa;

  Empresa _empresa = Empresa();

  late Widget cnpjProprietarioWidget = CnpjWidget(
    cnpjPrevio: widget.preCadastro,
    callback: _atualizaDadosEmpresa,
  );

  @override
  void initState() {
    super.initState();
    _empresa.cnpjCpf = widget.preCadastro;
    _configStream();
  }

  void _configStream() {
    pesquisaEmpresa = BehaviorSubject<String>();
    pesquisaEmpresa.stream.listen((cnpj) async {
      Empresa? e = await controller.findEmpresa(cnpj: cnpj);
      _empresa = e ?? Empresa();
      _empresa.cnpjCpf = cnpj;
      if (e != null) {
        setState(() {
          _cRazaSocialProp.text = _empresa.razaoSocial;
          _cTelefone.text = _empresa.telefones.isEmpty ? '' : _empresa.telefones[0];
          _cEmail.text = _empresa.email;
        });
      }
    });

    salvaEmpresa = BehaviorSubject<BuildContext>();
    salvaEmpresa.stream.listen((ctx) async {
      if (!verificaDadosPreenchidos()) {
        ScaffoldMessenger.of(ctx).showSnackBar(const SnackBar(content: Text('Verifique os dados pendentes')));
        return;
      }
      _insereDadosNaEmpresa();
      bool salvou = await controller.salvaEmpresa(_empresa);
      print('Salvando empresa: ' + _empresa.cnpjCpf);
      salvou
          ? ScaffoldMessenger.of(ctx).showSnackBar(const SnackBar(content: Text('Empresa Salva')))
          : ScaffoldMessenger.of(ctx)
              .showSnackBar(const SnackBar(content: Text('Não foi possível salvar os dados. Servidor indisponível')));
      if (salvou) _showDialogAnexaProprietario();
    });
  }

  @override
  void dispose() {
    super.dispose();
    pesquisaEmpresa.close();
    salvaEmpresa.close();
  }

  @override
  Widget build(BuildContext context) {
    final larguraTotal = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text('Nova Empresa'),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: larguraTotal / 4),
        child: Form(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          key: _formKey,
          child: SingleChildScrollView(
            child: Container(
              width: larguraTotal * .5,
              child: StreamBuilder<String>(
                  stream: pesquisaEmpresa.stream,
                  builder: (context, snapshot) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        titulo(),
                        cnpjProprietarioWidget,
                        razaoSocial(),
                        telefone(),
                        email(),
                        btnSalvar(context),
                      ],
                    );
                  }),
            ),
          ),
        ),
      ),
    );
  }

  Widget titulo() {
    return Container(
        child: Text(
      "Dados da Empresa",
      style: TextStyle(fontSize: 20),
    ));
  }

  Widget razaoSocial() {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextFormField(
          decoration: const InputDecoration(
            icon: Icon(Icons.person),
            labelText: 'Nome ou Razão Social',
          ),
          controller: _cRazaSocialProp,
          validator: (String? value) {
            return (value != null && value.length > 0) ? null : 'Informe um nome';
          },
        ));
  }

  Widget telefone() {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextFormField(
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            icon: Icon(Icons.phone),
            hintStyle: TextStyle(fontSize: 10),
            labelText: 'Telefone para contato, se houver',
          ),
          controller: _cTelefone,
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
          ],
        ));
  }

  Widget email() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        decoration: const InputDecoration(
          icon: Icon(Icons.email),
          hintStyle: TextStyle(fontSize: 10),
          labelText: 'E-mail para contato',
        ),
        keyboardType: TextInputType.emailAddress,
        controller: _cEmail,
        validator: validateEmail,
        onSaved: (String? value) {
          // This optional block of code can be used to run
          // code when the user saves the form.
        },
      ),
    );
  }

  Widget btnSalvar(BuildContext ctx) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: StreamBuilder<BuildContext>(
                stream: salvaEmpresa.stream,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.active) {
                    return CircularProgressIndicator();
                  }
                  return ElevatedButton(
                    child: Text('Salvar'),
                    onPressed: () => salvaEmpresa.add(ctx),
                  );
                }),
          ),
        ],
      ),
    );
  }

  void _atualizaDadosEmpresa(String cnpj, bool valido) async {
    if (!valido) return;
    pesquisaEmpresa.add(cnpj);
  }

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) return 'Informe um e-mail';
    String pattern = r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]"
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

  void _insereDadosNaEmpresa() {
    //controller.empresa.cnpj = _cCnpjCpf.text;
    _empresa.email = _cEmail.text;
    _empresa.telefones.clear();
    _empresa.telefones.add(_cTelefone.text);
    _empresa.razaoSocial = _cRazaSocialProp.text;
  }

  void _goAnexaProprietarioPage() {
    Modular.to.popAndPushNamed('anexa_proprietario', arguments: _empresa);
  }

  Future<void> _showDialogAnexaProprietario() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Proprietário'),
          content: SingleChildScrollView(
              child: Container(
            child: Text('Deseja incluir código do proprietário?'),
          )),
          actions: <Widget>[
            TextButton(
              child: const Text('Sim'),
              onPressed: () {
                Navigator.of(context).pop();
                _goAnexaProprietarioPage();
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
}
