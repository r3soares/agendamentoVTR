import 'package:agendamento_vtr/app/modules/empresa/controllers/empresa_controller.dart';
import 'package:agendamento_vtr/app/modules/tanque/models/empresa.dart';
import 'package:agendamento_vtr/app/modules/util/cnpj.dart';
import 'package:agendamento_vtr/app/modules/util/cpf.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_modular/flutter_modular.dart';

class CnpjWidget extends StatefulWidget {
  final String cnpjPrevio;
  final String titulo;
  //Termo buscado e Resultado
  final void Function(String, Empresa?) callback;
  CnpjWidget(
      {this.cnpjPrevio = '',
      this.titulo = 'CPF ou CNPJ',
      required this.callback});

  @override
  _CnpjWidgetState createState() => _CnpjWidgetState();
}

class _CnpjWidgetState extends ModularState<CnpjWidget, EmpresaController> {
  final TextEditingController _cCnpjCpf = TextEditingController();
  final focusNode = FocusNode();
  String cnpj = '';

  @override
  void initState() {
    super.initState();
    _cCnpjCpf.text = widget.cnpjPrevio;
    focusNode.addListener(buscaEmpresa);
  }

  @override
  Widget build(BuildContext context) {
    final larguraTotal = MediaQuery.of(context).size.width;
    return Row(
      children: [
        Container(
            padding: EdgeInsets.all(8),
            width: larguraTotal * .5,
            child: TextFormField(
              focusNode: focusNode,
              decoration: InputDecoration(
                icon: Icon(Icons.badge),
                hintText: 'Somente números',
                hintStyle: TextStyle(fontSize: 10),
                labelText: widget.titulo,
              ),
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
              ],
              controller: _cCnpjCpf,
              validator: validaCNPJCPF,
            )),
      ],
    );
  }

  String? validaCNPJCPF(String? value) {
    if (value == null || value.isEmpty) return 'Informe o CNPJ ou CPF';
    if (value.length != 14 && value.length != 11) return 'CNPJ ou CPF inválido';
    if (!CPF.isValid(value) && !CNPJ.isValid(value))
      return 'CNPJ ou CPF inválido';
    cnpj = value;
    return null;
  }

  void buscaEmpresa() {
    if (!focusNode.hasFocus && cnpj != '') {
      final empresa = controller.findEmpresa(cnpj: cnpj);
      widget.callback(cnpj, empresa);
      // controller.empresa = empresa ?? Empresa();
      // controller.empresa.cnpj = cnpj;
      //print(controller.empresa.cnpj);
    }
  }
}
