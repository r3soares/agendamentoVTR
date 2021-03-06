import 'package:agendamento_vtr/app/domain/validacoes.dart';
import 'package:flutter/material.dart';
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
  late MaskTextInputFormatter _maskInicial;
  final String _maskCPF = '###.###.###-##';
  final String _maskCNPJ = '##.###.###/####-##';
  final _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _maskInicial = new MaskTextInputFormatter(
        mask: '###############', filter: {"#": RegExp(r'[0-9]')}, initialText: widget.cnpjPrevio);
    if (widget.cnpjPrevio.isNotEmpty) {
      widget.cnpjPrevio.length > 11
          ? _maskInicial.updateMask(mask: _maskCNPJ)
          : _maskInicial.updateMask(mask: _maskCPF);
    }
    _controller.text = _maskInicial.getMaskedText();
    _focusNode.addListener(notificaListeners);
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
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
    );
  }

  String? validaCNPJCPF(String? value) {
    if (value == null || value.isEmpty) return 'Informe o CNPJ ou CPF';
    if (_maskInicial.getUnmaskedText().length != 14 && _maskInicial.getUnmaskedText().length != 11)
      return 'CNPJ ou CPF inválido';
    if (!_valida.validaCPF(_maskInicial.getUnmaskedText()) && !_valida.validaCNPJ(_maskInicial.getUnmaskedText()))
      return 'CNPJ ou CPF inválido';
    return null;
  }

  void notificaListeners() {
    if (_focusNode.hasFocus) {
      _controller.value = _maskInicial.updateMask(mask: '###############');
    } else {
      _controller.value = _maskInicial.getUnmaskedText().length > 11
          ? _maskInicial.updateMask(mask: _maskCNPJ)
          : _maskInicial.updateMask(mask: _maskCPF);
      _controller.text = _maskInicial.getMaskedText();
      widget.callback(_maskInicial.getUnmaskedText(), validaCNPJCPF(_maskInicial.getUnmaskedText()) == null);
    }
  }
}
