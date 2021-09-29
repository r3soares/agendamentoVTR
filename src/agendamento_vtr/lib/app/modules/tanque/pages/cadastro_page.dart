import 'package:agendamento_vtr/app/domain/erros.dart';
import 'package:agendamento_vtr/app/models/model_base.dart';
import 'package:agendamento_vtr/app/models/tanque.dart';
import 'package:agendamento_vtr/app/modules/tanque/stores/tanque_store.dart';
import 'package:agendamento_vtr/app/widgets/cnpj_widget.dart';
import 'package:agendamento_vtr/app/widgets/placa_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_triple/flutter_triple.dart';
import 'package:collection/collection.dart';

class CadastroPage extends StatefulWidget {
  const CadastroPage({Key? key}) : super(key: key);

  @override
  _CadastroPageState createState() => _CadastroPageState();
}

class _CadastroPageState extends ModularState<CadastroPage, TanqueStore> {
  final _formKey = GlobalKey<FormState>();
  final _scrollController = ScrollController();
  final _cPesquisaPlaca = TextEditingController();
  final List<Tanque> tanques = List.empty(growable: true);
  Size? _size;
  String cnpjProprietario = '';
  late Disposer _disposer;

  late Widget proprietarioWidget = CnpjWidget(
    titulo: 'CNPJ ou CPF',
    callback: (cnpj, valido) => _setProprietario(cnpj, valido),
  );
  late Widget placaWidget = PlacaWidget(
    titulo: 'Buscar placa',
    callback: _getTanque,
  );

  late OverlayEntry loadingOverlay = OverlayEntry(builder: (_) {
    return Container(
      alignment: Alignment.center,
      color: Colors.black38,
      child: CircularProgressIndicator(),
    );
  });

  @override
  void initState() {
    super.initState();
    _configStream();
  }

  @override
  void dispose() {
    super.dispose();
    _disposer();
  }

  void _configStream() {
    _disposer = store.observer(
        onState: (ModelBase t) => {
              if (t.status == Status.ConsultaPlaca)
                {_incluiTanque(t.model), limpaTermo(), _msgTemporaria('${(t.model as Tanque).placa} adicionado.')}
              else if (store.status == TanqueStoreState.SalvandoMuitos)
                {
                  _showDialogTanquesSalvos(),
                }
              else if (t.status == Status.ConsultaMuitos)
                {
                  for (var t in (t.model as List<Tanque>))
                    {
                      _incluiTanque(t),
                    },
                  _msgTemporaria('Encontrado veículo(s) associados a este proprietário.')
                }
            },
        onLoading: (isLoading) {
          if (store.isLoading) {
            Overlay.of(context)?.insert(loadingOverlay);
          } else {
            loadingOverlay.remove();
          }
        },
        onError: (error) {
          _showErro(error);
        });
  }

  @override
  Widget build(BuildContext context) {
    _size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('Cadastro de Veículo Tanque'),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: _size!.width / 4),
        child: SingleChildScrollView(
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _camposPropResp(),
                _camposTanques(),
                _camposBotoes(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _camposPropResp() {
    return Container(
      margin: EdgeInsets.only(top: 30),
      //width: larguraTotal * .4,
      child: Card(
        elevation: 4,
        shadowColor: Colors.black,
        child: Column(
          children: [
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.all(4),
              child: titulo('Proprietário'),
            ),
            Column(
              children: [
                Form(
                  child: proprietarioWidget,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  key: _formKey,
                ),
                //responsavelWidget,
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _camposBotoes() {
    return Row(
      children: [
        btnSalvar(),
        btnVoltar(),
      ],
    );
  }

  Widget _camposTanques() {
    return Container(
      //width: larguraTotal * .4,
      child: Card(
        elevation: 4,
        shadowColor: Colors.black,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.all(4),
              child: titulo('Tanques'),
            ),
            Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _pesquisaPlaca(), //_placaWidget(),
                    btnTanque(),
                  ],
                ),
                _listaTanques(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget titulo(String titulo) {
    return Container(
        padding: EdgeInsets.all(8),
        child: Text(
          titulo,
          style: TextStyle(fontSize: 20),
        ));
  }

  Widget btnSalvar() {
    return Container(
      padding: const EdgeInsets.all(8),
      child: ElevatedButton(
        child: Text('Salvar'),
        onPressed: () => _salvaDados(),
      ),
    );
  }

  Widget btnVoltar() {
    return Container(
      padding: const EdgeInsets.all(8),
      child: ElevatedButton(
        child: Text('Voltar'),
        onPressed: () => Modular.to.pop(),
      ),
    );
  }

  Widget btnTanque() {
    return Container(
      padding: const EdgeInsets.all(8),
      child: TextButton(
        child: Text('Novo Tanque'),
        onPressed: _goTanquePage,
      ),
    );
  }

  Widget _pesquisaPlaca() {
    return Container(
      width: 250,
      padding: const EdgeInsets.all(8),
      child: ListTile(
          title: TextFormField(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        controller: _cPesquisaPlaca,
        textCapitalization: TextCapitalization.characters,
        onChanged: (value) {
          _cPesquisaPlaca.value = TextEditingValue(text: value.toUpperCase(), selection: _cPesquisaPlaca.selection);
        },
        maxLength: 7,
        validator: _validaPlaca,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'Pesquisar',
          hintText: 'Informe a placa',
          suffixIcon: IconButton(
            onPressed: limpaTermo,
            icon: Icon(Icons.clear),
            splashRadius: 5,
          ),
        ),
      )),
    );
  }

  Widget _placaWidget() {
    return Container(
      padding: const EdgeInsets.all(8),
      alignment: Alignment.centerLeft,
      child: Card(
        elevation: 4,
        shadowColor: Colors.black,
        child: placaWidget,
      ),
    );
  }

  Widget _listaTanques() {
    return Container(
        width: _size!.width * .5,
        height: 170,
        child: tanques.isEmpty
            ? SizedBox.shrink()
            : Scrollbar(
                isAlwaysShown: true,
                controller: _scrollController,
                child: ListView.builder(
                  controller: _scrollController,
                  scrollDirection: Axis.horizontal,
                  itemCount: tanques.length,
                  shrinkWrap: true,
                  itemBuilder: (BuildContext context, int index) {
                    return _tanqueWidget(index);
                  },
                ),
              ));
  }

  Widget _tanqueWidget(int index) {
    return Container(
      padding: const EdgeInsets.all(8),
      child: Card(
        elevation: 10,
        shadowColor: Colors.black,
        child: Container(
          padding: const EdgeInsets.all(4),
          child: Column(
            children: [
              Container(
                  padding: const EdgeInsets.all(8),
                  child: TextButton(
                    child: Text(
                      tanques[index].placa.replaceRange(3, 3, '-'),
                      style: TextStyle(fontSize: 20),
                    ),
                    onPressed: () => _goTanquePage(tExistente: tanques[index]),
                  )),
              Container(
                padding: const EdgeInsets.all(4),
                child: Text('${tanques[index].capacidadeTotal}L'),
              ),
              Container(
                padding: const EdgeInsets.all(4),
                child: Text('${tanques[index].compartimentos.length}C ${formataExibicaoSetas(tanques[index])}'),
              ),
              Container(
                child: IconButton(
                  splashRadius: 10,
                  icon: Icon(
                    Icons.close,
                    color: Colors.red[900],
                  ),
                  onPressed: () => _removeTanque(index),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _setProprietario(String cnpj, bool valido) {
    cnpjProprietario = valido ? cnpj : '';
    // if (valido) {
    //   store.consultaProprietario(cnpj);
    // }
  }

  int _somaSetas(Tanque t) {
    return t.compartimentos.fold(0, (previousValue, element) => previousValue + element.setas);
  }

  String formataExibicaoSetas(Tanque t) {
    int setas = _somaSetas(t);
    return setas > 0 ? '${setas}SS' : '';
  }

  void _salvaDados() {
    if (!_validaForm()) {
      _msgTemporaria('Há campos inválidos');
      return;
    }
    _associaPropAosTanques();
  }

  void _associaPropAosTanques() {
    for (var t in tanques) {
      t.proprietario = cnpjProprietario;
    }
    store.salvaMuitos(tanques);
  }

  void _goTanquePage({Tanque? tExistente}) {
    Modular.to.pushNamed('cadastroTanque', arguments: tExistente);
  }

  void _incluiTanque(Tanque t) {
    Tanque? tExiste = tanques.firstWhereOrNull((element) => element.codInmetro == t.codInmetro);
    if (tExiste == null) {
      setState(() {
        tanques.add(t);
      });
    }
  }

  void _msgTemporaria(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  bool _validaForm() {
    if (_formKey.currentState == null) return false;
    return _formKey.currentState!.validate();
  }

  void _getTanque(String placa, bool valido) async {
    if (valido) {
      store.consultaPlaca(placa);
    }
  }

  void _removeTanque(int index) {
    Tanque t = tanques.removeAt(index);
    t.proprietario = null;
    store.salva(t);
    setState(() {});
  }

  _showErro(Falha erro) {
    if (store.status != TanqueStoreState.Salvando && store.status != TanqueStoreState.ConsultandoPlaca) return;
    switch (erro.runtimeType) {
      case ErroConexao:
        {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Não foi possível salvar os dados. Erro de conexão'),
            backgroundColor: Colors.red[900],
          ));
          break;
        }
      case NaoEncontrado:
        {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Não localizado.')));
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

  Future<void> _showDialogTanquesSalvos() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Salvo com sucesso!'),
          content: SingleChildScrollView(
              child: Container(
            child: Text(tanques.length > 1
                ? '${tanques.length} veículos foram associados ao proprietário $cnpjProprietario.'
                : '${tanques[0].placa} foi associado ao proprietário $cnpjProprietario.'),
          )),
          actions: <Widget>[
            TextButton(
              child: const Text('ok'),
              onPressed: () {
                Modular.to.pop();
              },
            ),
          ],
        );
      },
    );
  }

  String? _validaPlaca(String? value) {
    if (value == null || value.isEmpty) return null;
    if (value.length != 7) return 'Placa inválida';
    RegExp regex = RegExp('[A-Z]{3}[0-9][0-9A-Z][0-9]{2}');
    if (!regex.hasMatch(value)) return 'Placa inválida';
    _getTanque(value, true);
    return null;
  }

  void limpaTermo() {
    _cPesquisaPlaca.clear();
  }
}
