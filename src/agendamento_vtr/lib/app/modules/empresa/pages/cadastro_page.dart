import 'dart:async';

import 'package:agendamento_vtr/app/domain/erros.dart';
import 'package:agendamento_vtr/app/models/bloc.dart';
import 'package:agendamento_vtr/app/models/empresa.dart';
import 'package:agendamento_vtr/app/models/model_base.dart';
import 'package:agendamento_vtr/app/modules/empresa/stores/empresa_store.dart';
import 'package:agendamento_vtr/app/modules/empresa/widgets/telefone_widget.dart';
import 'package:agendamento_vtr/app/widgets/base_widgets.dart';
import 'package:agendamento_vtr/app/widgets/cnpj_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

  late Empresa _empresa;

  final TextEditingController _cRazaSocialProp = TextEditingController();
  final TextEditingController _cEmail = TextEditingController();

  late Disposer _disposer;
  late Disposer _disposerTel;

  final Bloc blocTelefone = Bloc('');

  late Widget cnpjProprietarioWidget;
  late Widget _telefoneWidget;

  @override
  void initState() {
    super.initState();
    _empresa = widget.preCadastro ?? Empresa();
    _cEmail.text = _empresa.email;
    _cRazaSocialProp.text = _empresa.razaoSocial;

    cnpjProprietarioWidget = CnpjWidget(
      cnpjPrevio: _empresa.cnpjCpf,
      callback: _atualizaDadosEmpresa,
    );

    _telefoneWidget = TelefoneWidget(bloc: blocTelefone);
    _configStream();
  }

  void _configStream() {
    _disposer = store.observer(
        onState: (e) => {
              print('onState: $e'),
              if (e.status == Status.Consulta)
                {
                  Modular.to.popAndPushNamed('cadastro', arguments: e.model),
                }
              else if (e.status == Status.Salva)
                {
                  _showDialogAnexaProprietario(),
                }
            },
        onLoading: (isLoading) {
          if (store.isLoading) {
            Overlay.of(context)?.insert(widget.loadingOverlay);
          } else {
            widget.loadingOverlay.remove();
          }
        },
        onError: (error) {
          _showErro(error);
        });

    _disposerTel = blocTelefone.observer(
        onState: (telefone) => {
              _empresa.telefones.clear(),
              _empresa.telefones.add(telefone as String),
            });
  }

  @override
  void dispose() {
    super.dispose();
    _disposer();
    _disposerTel();
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
                  _buildCNPJWidget(),
                  buildRazaoSocial(),
                  buildTelefone(),
                  buildEmail(),
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

  Widget _buildCNPJWidget() {
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

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) return 'Informe um e-mail';
    return store.validaEmail(value) ? null : 'E-mail inválido';
  }

  bool verificaDadosPreenchidos() {
    if (_formKey.currentState == null) return false;
    return _formKey.currentState!.validate();
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

  _atualizaDadosEmpresa(String cnpj, bool valido) async {
    if (!valido) return;
    _empresa.cnpjCpf = cnpj;
    store.consulta(cnpj);
  }

  _goAnexaProprietarioPage() {
    Modular.to.popAndPushNamed('anexa_proprietario', arguments: _empresa);
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
    store.salva(_empresa);
    print('Salvando empresa: ' + _empresa.cnpjCpf);
  }
}
