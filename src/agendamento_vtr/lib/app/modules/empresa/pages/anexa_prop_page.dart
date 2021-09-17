import 'package:agendamento_vtr/app/models/empresa.dart';
import 'package:agendamento_vtr/app/models/proprietario.dart';
import 'package:agendamento_vtr/app/modules/empresa/controllers/empresa_controller.dart';
import 'package:agendamento_vtr/app/widgets/input_numero_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class AnexaPropPage extends StatefulWidget {
  final Empresa empresa;
  final largura = .5;
  const AnexaPropPage({required this.empresa});

  @override
  _AnexaPropPageState createState() => _AnexaPropPageState();
}

class _AnexaPropPageState
    extends ModularState<AnexaPropPage, EmpresaController> {
  final Proprietario proprietario = Proprietario();
  late Widget inmetroWidget;
  late Widget codMunWidget;

  @override
  void initState() {
    super.initState();
    inmetroWidget = InputNumeroWidget(
      titulo: 'Número Inmetro',
      input: TipoInput.Numeros,
      callback: (codInmetro) => proprietario.cod = codInmetro,
    );
    codMunWidget = InputNumeroWidget(
      titulo: 'Código do Município',
      input: TipoInput.Numeros,
      callback: (codMun) => proprietario.codMun = codMun,
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          title: Text('${widget.empresa.cnpjCpf}'),
        ),
        body: Container(
          padding: EdgeInsets.only(bottom: size.height * .3),
          alignment: Alignment.topCenter,
          child: SizedBox(
            height: size.height * .5,
            width: size.width * .5,
            child: Card(
              shadowColor: Colors.black,
              elevation: 12,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  titulo(),
                  _inmetroWidget(),
                  _codMunWidget(),
                  _btnSalvar()
                ],
              ),
            ),
          ),
        ));
  }

  Widget titulo() {
    return Container(
        padding: EdgeInsets.all(8),
        child: Text(
          "Dados do Proprietário",
          style: TextStyle(fontSize: 20),
        ));
  }

  Widget _inmetroWidget() {
    return Container(
      padding: const EdgeInsets.all(8),
      child: Card(
        elevation: 4,
        shadowColor: Colors.black,
        child: inmetroWidget,
      ),
    );
  }

  Widget _codMunWidget() {
    return Container(
      padding: const EdgeInsets.all(8),
      child: Card(
        elevation: 4,
        shadowColor: Colors.black,
        child: codMunWidget,
      ),
    );
  }

  Widget _btnSalvar() {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              child: Text('Salvar'),
              onPressed: () => _salvaEmpresa(context),
            ),
          ),
        ],
      ),
    );
  }

  bool verificaDadosPreenchidos() {
    if (proprietario.cod <= 0 || proprietario.codMun == 0) return false;
    return true;
  }

  void _insereDadosNaEmpresa() {
    widget.empresa.proprietario = proprietario;
  }

  bool _salvaEmpresa(context) {
    if (!verificaDadosPreenchidos()) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Informe os campos corretamente')));
      return false;
    }
    _insereDadosNaEmpresa();
    controller.salvaEmpresa(widget.empresa);
    print('Proprietário salvo: ' + widget.empresa.cnpjCpf);
    Modular.to.pop();
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Proprietário salvo')));
    return true;
  }
}
