import 'package:agendamento_vtr/app/modules/tanque/models/empresa.dart';
import 'package:agendamento_vtr/app/pesquisa_controller.dart';
import 'package:agendamento_vtr/app/repository_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class PesquisaEmpresaWidget extends StatefulWidget {
  final String titulo;
  final Empresa? valorInicial;
  const PesquisaEmpresaWidget(this.titulo, {this.valorInicial});

  @override
  _PesquisaEmpresaWidgetState createState() => _PesquisaEmpresaWidgetState();
}

class _PesquisaEmpresaWidgetState extends State<PesquisaEmpresaWidget> {
  final controller = Modular.get<PesquisaController>();
  TextEditingController _cPesquisaResponsavel = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _cPesquisaResponsavel.text = widget.valorInicial?.razaoSocial ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: TextFormField(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        controller: _cPesquisaResponsavel,
        validator: buscaTermo,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: widget.titulo,
          hintText: 'Informe o CPF/CNPJ',
          suffixIcon: IconButton(
            onPressed: limpaTermo,
            icon: Icon(Icons.clear),
          ),
        ),
      ),
    );
  }

  String? buscaTermo(String? termo) {
    if (termo == null || termo.isEmpty) return null;
    return 'Não localizado';
  }

  void limpaTermo() {
    _cPesquisaResponsavel.clear();
  }
}
