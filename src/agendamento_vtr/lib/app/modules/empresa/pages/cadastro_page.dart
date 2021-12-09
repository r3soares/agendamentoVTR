import 'dart:async';

import 'package:agendamento_vtr/app/domain/erros.dart';
import 'package:agendamento_vtr/app/models/bloc.dart';
import 'package:agendamento_vtr/app/models/empresa.dart';
import 'package:agendamento_vtr/app/models/proprietario.dart';
import 'package:agendamento_vtr/app/modules/empresa/stores/empresa_store.dart';
import 'package:agendamento_vtr/app/modules/empresa/widgets/municipios_ac_widget.dart';
import 'package:agendamento_vtr/app/modules/empresa/widgets/telefone_widget.dart';
import 'package:agendamento_vtr/app/widgets/base_widgets.dart';
import 'package:agendamento_vtr/app/widgets/cnpj_widget.dart';
import 'package:agendamento_vtr/app/widgets/input_numero_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_triple/flutter_triple.dart';

class CadastroPage extends BaseWidgets {
  final Empresa? preCadastro;
  final largura = .5;
  CadastroPage({this.preCadastro});

  @override
  _CadastroPageState createState() => _CadastroPageState();
}

class _CadastroPageState extends ModularState<CadastroPage, EmpresaStore> {
  final _formKey = GlobalKey<FormState>();
  final List<Disposer> disposers = List.empty(growable: true);

  late Empresa _empresa;

  final TextEditingController _cRazaSocialProp = TextEditingController();
  final TextEditingController _cEmail = TextEditingController();

  final Bloc blocTelefone = Bloc('');

  bool isProprietario = false;

  late Widget cnpjProprietarioWidget;
  late Widget _telefoneWidget;

  late Widget _inmetroWidget;
  late Widget _codMunWidget;

  @override
  void initState() {
    super.initState();
    _empresa = widget.preCadastro ?? Empresa();
    isProprietario = _empresa.proprietario != null;
    _empresa.proprietario = _empresa.proprietario ?? Proprietario();
    _cEmail.text = _empresa.email;
    _cRazaSocialProp.text = _empresa.razaoSocial;

    cnpjProprietarioWidget = CnpjWidget(
      cnpjPrevio: _empresa.cnpjCpf,
      callback: _atualizaDadosEmpresa,
    );

    _telefoneWidget = TelefoneWidget(bloc: blocTelefone);

    _inmetroWidget = InputNumeroWidget(
      titulo: 'Número Inmetro',
      input: TipoInput.Numeros,
      callback: (codInmetro) => _empresa.proprietario!.cod = int.tryParse(codInmetro) ?? 0,
      campoPrevio: _empresa.proprietario!.cod == 0 ? '' : _empresa.proprietario!.cod.toString(),
    );
    _codMunWidget = MunicipiosACWidget(
        titulo: 'Município',
        callback: (municipio) => _empresa.proprietario!.codMun = municipio.cdMunicipio,
        campoPrevio: _empresa.proprietario!.codMun);

    _configStream();
  }

  void _configStream() {
    var d1 = store.cEmpresa.observer(
      onState: (e) => Modular.to.popAndPushNamed('cadastro', arguments: e),
      onLoading: loading,
      onError: _showErro,
    );
    var d2 = store.sEmpresa.observer(
      onState: (e) => _showDialogContinuar(),
      onLoading: loading,
      onError: _showErro,
    );

    var d3 = blocTelefone.observer(
        onState: (telefone) => {
              _empresa.telefones.clear(),
              _empresa.telefones.add(telefone as String),
            });
    disposers.addAll([d1, d2, d3]);
  }

  @override
  dispose() {
    disposers.forEach((d) {
      d();
    });
    store.destroy();
    super.dispose();
  }

  loading(bool isLoading) {
    widget.loading(isLoading, context);
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
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  buildTitulo(),
                  buildIsProprietario(),
                  buildCNPJWidget(),
                  buildRazaoSocial(),
                  buildTelefone(),
                  buildEmail(),
                  isProprietario ? buildInmetro() : SizedBox.shrink(),
                  isProprietario ? buildCodMun() : SizedBox.shrink(),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [widget.btnsalvar(onPressed: _salvaEmpresa), widget.btnVoltar()],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildCNPJWidget() {
    return Container(
      padding: const EdgeInsets.all(8),
      child: cnpjProprietarioWidget,
    );
  }

  Widget buildTitulo() {
    return Container(
        child: Text(
      "Dados da Empresa",
      style: TextStyle(fontSize: 20),
    ));
  }

  Widget buildRazaoSocial() {
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
          onChanged: (razaoSocial) => _empresa.razaoSocial = razaoSocial,
        ));
  }

  Widget buildTelefone() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: _telefoneWidget,
    );
  }

  Widget buildEmail() {
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
        onChanged: (email) => _empresa.email = email,
      ),
    );
  }

  Widget buildInmetro() {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: _inmetroWidget,
    );
  }

  Widget buildCodMun() {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: _codMunWidget,
    );
  }

  Widget buildIsProprietario() {
    return Row(
      children: [Text('Proprietário?'), Checkbox(value: isProprietario, onChanged: (value) => setDeleteProprietario())],
    );
  }

  setDeleteProprietario() {
    setState(() {
      isProprietario = !isProprietario;
    });
  }

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) return 'Informe um e-mail';
    return store.validaEmail(value) ? null : 'E-mail inválido';
  }

  bool verificaDadosPreenchidos() {
    if (_formKey.currentState == null) return false;
    return _formKey.currentState!.validate();
  }

  Future<void> _showDialogContinuar() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Empresa salva com sucesso'),
          content: SingleChildScrollView(
              child: Container(
            child: Text('Deseja incluir mais empresas?'),
          )),
          actions: <Widget>[
            TextButton(
              child: const Text('Sim'),
              onPressed: () {
                Navigator.of(context).pop();
                Modular.to.popAndPushNamed('/empresa/cadastro');
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

  _atualizaDadosEmpresa(String cnpj, bool valido) async {
    if (!valido) return;
    _empresa.cnpjCpf = cnpj;
    store.consulta(cnpj);
  }

  _showErro(Falha erro) {
    if (!verificaDadosPreenchidos()) return;
    switch (erro.runtimeType) {
      case ErroConexao:
        {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Não foi possível salvar os dados. Erro de conexão'),
            backgroundColor: Colors.red[900],
          ));
          break;
        }
      case Falha:
        {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('Não foi possível salvar os dados. ${erro.msg}'), backgroundColor: Colors.red[900]));
          break;
        }
    }
  }

  _salvaEmpresa() {
    if (!verificaDadosPreenchidos()) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Verifique os dados pendentes')));
      return;
    }
    _empresa.proprietario = isProprietario ? _empresa.proprietario : null;
    store.salva(_empresa);
    print('Salvando empresa: ' + _empresa.cnpjCpf);
  }
}
