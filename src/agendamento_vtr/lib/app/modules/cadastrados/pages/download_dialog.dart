import 'package:agendamento_vtr/app/models/dado_psie.dart';
import 'package:agendamento_vtr/app/models/empresa.dart';
import 'package:agendamento_vtr/app/models/tanque.dart';
import 'package:agendamento_vtr/app/modules/cadastrados/stores/download_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_triple/flutter_triple.dart';

//Placa teste mez3698
class DownloadDialog extends StatefulWidget {
  const DownloadDialog({Key? key}) : super(key: key);

  @override
  State<DownloadDialog> createState() => _DownloadDialogState();
}

class _DownloadDialogState extends ModularState<DownloadDialog, DownloadStore> {
  final TextEditingController _cPlaca = TextEditingController();
  List<bool> escolhidos = [true, true, true, true, true, true, true];
  Tanque? tanque;
  Empresa? empresa;

  @override
  void initState() {
    super.initState();
    store.observer(
        onState: (dadoPsie) => {
              _getPlacaLocal(dadoPsie.placa),
              _getEmpresaLocal(dadoPsie.cnpj),
            });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: 700,
        height: 500,
        child: Column(children: [
          placaWidget(),
          ScopedBuilder(
            store: store,
            onState: (context, DadoPsie state) => dadosPsieWidget(state),
            onLoading: (context) => const CircularProgressIndicator(),
            onError: (context, error) => Text('Placa não localizada'),
          )
        ]),
      ),
    );
  }

  Widget placaWidget() => Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextFormField(
          controller: _cPlaca,
          maxLength: 7,
          onChanged: (_) => setState(() {}),
          onFieldSubmitted: (placa) => store.download(placa),
          validator: _validaPlaca,
          textCapitalization: TextCapitalization.characters,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Informe a placa',
            suffixIcon: TextButton(
              child: Text('Download'),
              onPressed: () => store.download(_cPlaca.text),
            ),
          ),
        ),
      );
  Widget dadosPsieWidget(DadoPsie dado) => Center(
        child: dado.placa.isEmpty
            ? SizedBox.shrink()
            : Column(
                children: [
                  _exibeDado('Inmetro', dado.inmetro),
                  _exibeDado('Placa', dado.placa),
                  _exibeDado('Número de Série', dado.numSerie),
                  _exibeDado('Proprietário', dado.proprietario),
                  _exibeDado('CNPJ', dado.cnpj),
                  _exibeDado('Município', dado.municipio),
                  _exibeDado('UF', dado.uf),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: dado.inmetro.isEmpty
                            ? null
                            : () => _salvaDados(dado),
                        child: tanque == null
                            ? Text('Salvar')
                            : Text('Substituir base local'),
                      ),
                      ElevatedButton(
                        onPressed:
                            tanque == null ? null : () => _comparaDados(dado),
                        child: Text('Comparar com base local'),
                      ),
                    ],
                  )
                ],
              ),
      );
  Widget _exibeDado(String titulo, String dado) => ListTile(
        title: Text(titulo),
        trailing: Text(dado),
      );
  _getPlacaLocal(String placa) async {
    tanque = null;
    if (placa.isEmpty) return;
    placa = placa.replaceAll('-', '').toUpperCase();
    print(placa);
    tanque = await store.getPlacaLocal(placa);
    setState(() {});
    if (tanque != null) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Encontrado veículo na base local')));
    }
  }

  String? _validaPlaca(String? placa) {
    if (placa == null) return 'Informe uma placa';
    if (placa.length != 7) return 'Placa deve ter 7 dígitos';
    return null;
  }

  _getEmpresaLocal(String cnpj) async {
    empresa = null;
    if (cnpj.isEmpty) return;
    cnpj = cnpj.replaceAll(RegExp('[^\\d ]'), "");
    print(cnpj);
    empresa = await store.getEmpresaLocal(cnpj);
  }

  _salvaDados(DadoPsie dado) async {
    if (dado.inmetro.isEmpty || _cPlaca.text.isEmpty) {
      setState(() {});
      return;
    }
    tanque = await _criaTanque(dado);
    print(tanque!.toJson());
    bool salvou = await store.salvaTanque(tanque!);
    if (salvou) {
      store.update(DadoPsie('', '', '', '', '', '', '', '', '', ''));
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Veículo salvo com sucesso')));
      empresa = null;
      tanque = null;
      _cPlaca.clear();
      return;
    }
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Erro ao salvar veículo')));
  }

  _comparaDados(DadoPsie dado) {}

  _criaTanque(DadoPsie dado) async {
    tanque = tanque == null ? Tanque() : tanque;
    tanque!.codInmetro = dado.inmetro;
    tanque!.placa = dado.placa;
    tanque!.proprietario = await _criaEmpresa(dado);
    return tanque!;
  }

  _criaEmpresa(DadoPsie dado) async {
    empresa = empresa == null ? Empresa() : empresa;
    empresa!.cnpjCpf = dado.cnpj.replaceAll(RegExp('[^\\d ]'), "");
    empresa!.razaoSocial = dado.proprietario;
    //await _criaProprietario(dado);
    return empresa;
  }

  // _criaProprietario(DadoPsie dado) async {
  //   var p =
  //       empresa!.proprietario == null ? Proprietario() : empresa!.proprietario!;
  //   Municipio? mun = await store.getMunicipio(dado.municipio.split(' - ')[0]);
  //   if (mun == null) return p;
  //   p.codMun = escolhidos[5] ? mun.cdMunicipio : p.codMun;
  //   return p;
  // }

  // _mudaValor(bool valor, int campo) {
  //   //print('Valor: ' + valor.toString() + ' Campo: ' + campo.toString());
  //   setState(() {
  //     escolhidos[campo] = valor;
  //   });
  // }
}
