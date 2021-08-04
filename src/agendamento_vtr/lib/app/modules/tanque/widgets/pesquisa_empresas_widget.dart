import 'package:agendamento_vtr/app/modules/tanque/models/empresa.dart';
import 'package:agendamento_vtr/app/modules/util/cnpj.dart';
import 'package:agendamento_vtr/app/modules/util/cpf.dart';
import 'package:agendamento_vtr/app/pesquisa_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class PesquisaEmpresaWidget extends StatefulWidget {
  const PesquisaEmpresaWidget();

  @override
  _PesquisaEmpresaWidgetState createState() => _PesquisaEmpresaWidgetState();
}

class _PesquisaEmpresaWidgetState extends State<PesquisaEmpresaWidget> {
  final TextEditingController _cPesquisa = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String? erroNaoLocalizado;
  final controller = Modular.get<PesquisaController>();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Align(
      alignment: Alignment.center,
      child: Container(
        padding: EdgeInsets.all(12),
        width: size.width * .3,
        child: ListTile(
          title: Form(
            key: _formKey,
            child: TextFormField(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              controller: _cPesquisa,
              validator: validaCNPJCPF,
              onFieldSubmitted: buscaTermo,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Pesquisar',
                hintText: 'Informe o CPF ou CNPJ',
                errorText: erroNaoLocalizado,
                prefixIcon: IconButton(
                  onPressed: limpaTermo,
                  icon: Icon(Icons.clear),
                ),
                suffixIcon: IconButton(
                  onPressed: () => buscaTermo(_cPesquisa.text),
                  icon: Icon(Icons.arrow_forward),
                ),
              ),
            ),
          ),
          trailing: TextButton(
              onPressed: () => abreCadastroNovaEmpresa(), child: Text('Novo')),
        ),
      ),
    );
  }

  String? validaCNPJCPF(String? value) {
    if (value == null || value.isEmpty) return 'Informe o CNPJ ou CPF';
    if (value.length != 14 && value.length != 11) return '';
    if (!CPF.isValid(value) && !CNPJ.isValid(value))
      return 'CNPJ ou CPF inválido';
    return null;
  }

  void buscaTermo(String termo) {
    if (_formKey.currentState != null && _formKey.currentState!.validate()) {
      final resultado = controller.pesquisaEmpresa(termo);
      setState(() {
        erroNaoLocalizado = resultado ? null : 'Não localizado';
      });
    }
  }

  void limpaTermo() {
    setState(() {
      erroNaoLocalizado = null;
    });
    _cPesquisa.clear();
    controller.resetPesquisa();
  }

  void abreCadastroNovaEmpresa() {}
}
