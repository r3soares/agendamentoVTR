import 'package:agendamento_vtr/app/domain/erros.dart';
import 'package:agendamento_vtr/app/models/empresa.dart';
import 'package:agendamento_vtr/app/models/proprietario.dart';
import 'package:agendamento_vtr/app/modules/empresa/stores/empresa_store.dart';
import 'package:agendamento_vtr/app/widgets/input_numero_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_triple/flutter_triple.dart';

class AnexaPropPage extends StatefulWidget {
  final Empresa empresa;
  final largura = .5;
  const AnexaPropPage({required this.empresa});

  @override
  _AnexaPropPageState createState() => _AnexaPropPageState();
}

class _AnexaPropPageState extends ModularState<AnexaPropPage, EmpresaStore> {
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
      campoPrevio: '${widget.empresa.proprietario?.cod}',
    );
    codMunWidget = InputNumeroWidget(
        titulo: 'Código do Município',
        input: TipoInput.Numeros,
        callback: (codMun) => proprietario.codMun = codMun,
        campoPrevio: '${widget.empresa.proprietario?.codMun}');
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          title: Text('${widget.empresa.cnpjCpf}'),
        ),
        body: Container(
          padding: EdgeInsets.only(top: 50),
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
                  ScopedBuilder<EmpresaStore, Falha, Object>(
                      store: store,
                      onState: (ctx, state) => Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [_btnSalvar(), _btnVoltar()],
                            ),
                          ),
                      onLoading: (ctx) => CircularProgressIndicator(),
                      onError: (ctx, error) => _exibeMsg(ctx, error!.msg)),
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

  Widget _btnVoltar() {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              child: Text('Voltar'),
              onPressed: () => Modular.to.pop(),
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

  _salvaEmpresa(context) {
    if (!verificaDadosPreenchidos()) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Informe os campos corretamente')));
    }
    _insereDadosNaEmpresa();
    store.salva(widget.empresa);
  }

  Widget _exibeMsg(BuildContext ctx, String msg) {
    ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(content: Text(msg)));
    return _btnVoltar();
  }
}
