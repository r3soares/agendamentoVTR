import 'package:agendamento_vtr/app/domain/validacoes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class CnpjWidget extends StatefulWidget {
  final String cnpjPrevio;
  final String titulo;
  //Termo buscado e Resultado
  final Function(String, bool) callback;
  CnpjWidget({this.cnpjPrevio = '', this.titulo = 'CPF ou CNPJ', required this.callback});

  @override
  _CnpjWidgetState createState() => _CnpjWidgetState();
}

class _CnpjWidgetState extends State<CnpjWidget> {
  final Validacoes _valida = Validacoes();
  final TextEditingController _controller = TextEditingController();
  final MaskTextInputFormatter _maskInicial =
      new MaskTextInputFormatter(mask: '###############', filter: {"#": RegExp(r'[0-9]')});
  final String _maskCPF = '###.###.###-##';
  final String _maskCNPJ = '##.###.###/####-##';
  final _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _controller.text = widget.cnpjPrevio;
    _focusNode.addListener(notificaListeners);
  }

  @override
  Widget build(BuildContext context) {
    final larguraTotal = MediaQuery.of(context).size.width;
    return Row(
      children: [
        Container(
            padding: EdgeInsets.all(8),
            width: larguraTotal * .4,
            child: TextFormField(
              focusNode: _focusNode,
              decoration: InputDecoration(
                icon: Icon(Icons.badge),
                hintText: 'Somente números',
                hintStyle: TextStyle(fontSize: 10),
                labelText: widget.titulo,
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [_maskInicial],
              controller: _controller,
              validator: validaCNPJCPF,
            )),
      ],
    );
  }

  String? validaCNPJCPF(String? value) {
    if (value == null || value.isEmpty) return 'Informe o CNPJ ou CPF';
    if (value.length != 14 && value.length != 11) return 'CNPJ ou CPF inválido';
    if (!_valida.validaCPF_CNPJ(value)) return 'CNPJ ou CPF inválido';
    return null;
  }

  void notificaListeners() {
    if (_focusNode.hasFocus) {
      _controller.value = _maskInicial.updateMask(mask: '###############');
    } else {
      setState(() {
        _controller.value = _maskInicial.getUnmaskedText().length > 11
            ? _maskInicial.updateMask(mask: _maskCNPJ)
            : _maskInicial.updateMask(mask: _maskCPF);
      });
      widget.callback(_controller.text, validaCNPJCPF(_maskInicial.getUnmaskedText()) == null);
    }
  }

  // void buscaEmpresa() {
  //   if (!focusNode.hasFocus && cnpj != '') {
  //     final empresa = controller.findEmpresa(cnpj: cnpj);
  //     widget.callback(cnpj, empresa);
  //     // controller.empresa = empresa ?? Empresa();
  //     // controller.empresa.cnpj = cnpj;
  //     //print(controller.empresa.cnpj);
  //   }
  // }
}
