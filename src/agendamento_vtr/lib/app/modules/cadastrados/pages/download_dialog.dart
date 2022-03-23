import 'package:agendamento_vtr/app/models/dado_psie.dart';
import 'package:agendamento_vtr/app/models/empresa.dart';
import 'package:agendamento_vtr/app/models/proprietario.dart';
import 'package:agendamento_vtr/app/models/tanque.dart';
import 'package:agendamento_vtr/app/modules/agendamento/models/municipio.dart';
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
                  Row(
                    children: [
                      Expanded(
                        child: ListTile(
                          leading: Checkbox(
                            value: escolhidos[0],
                            onChanged: (valor) => _mudaValor(valor!, 0),
                          ),
                          title: Text('Inmetro'),
                          trailing: Text(dado.inmetro),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          tanque == null ? 'Novo' : tanque!.codInmetro,
                          style: TextStyle(color: Colors.grey, fontSize: 12),
                        ),
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: ListTile(
                          leading: Checkbox(
                            value: escolhidos[1],
                            onChanged: (valor) => _mudaValor(valor!, 1),
                          ),
                          title: Text('Placa'),
                          trailing: Text(dado.placa),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          tanque == null ? 'Novo' : tanque!.placa,
                          style: TextStyle(color: Colors.grey, fontSize: 12),
                        ),
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: ListTile(
                          leading: Checkbox(
                            value: escolhidos[3],
                            onChanged: (valor) => _mudaValor(valor!, 3),
                          ),
                          title: Text('Proprietário'),
                          trailing: Text(dado.proprietario),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          empresa == null ? 'Novo' : empresa!.razaoSocial,
                          style: TextStyle(color: Colors.grey, fontSize: 12),
                        ),
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: ListTile(
                          leading: Checkbox(
                            value: escolhidos[4],
                            onChanged: (valor) => _mudaValor(valor!, 4),
                          ),
                          title: Text('CNPJ'),
                          trailing: Text(dado.cnpj),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          empresa == null ? 'Novo' : empresa!.cnpjFormatado,
                          style: TextStyle(color: Colors.grey, fontSize: 12),
                        ),
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: ListTile(
                          leading: SizedBox.shrink(),
                          title: Text('Número de Série'),
                          trailing: Text(dado.numSerie),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Ausente',
                          style: TextStyle(color: Colors.grey, fontSize: 12),
                        ),
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: ListTile(
                          leading: SizedBox.shrink(),
                          title: Text('Município'),
                          trailing: Text(dado.municipio),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          empresa == null
                              ? 'Novo'
                              : empresa!.proprietario == null
                                  ? 'Novo'
                                  : empresa!.proprietario!.codMun.toString(),
                          style: TextStyle(color: Colors.grey, fontSize: 12),
                        ),
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: ListTile(
                          leading: SizedBox.shrink(),
                          title: Text('UF'),
                          trailing: Text(dado.uf),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Ausente',
                          style: TextStyle(color: Colors.grey, fontSize: 12),
                        ),
                      )
                    ],
                  ),
                  Center(
                      child: ElevatedButton(
                    onPressed: () => _salvaDados(dado),
                    child: Text('Salvar'),
                  ))
                ],
              ),
      );

  _getPlacaLocal(String placa) async {
    tanque = null;
    if (placa.isEmpty) return;
    placa = placa.replaceAll('-', '').toUpperCase();
    print(placa);
    tanque = await store.getPlacaLocal(placa);
  }

  _getEmpresaLocal(String cnpj) async {
    empresa = null;
    if (cnpj.isEmpty) return;
    cnpj = cnpj.replaceAll(RegExp('[^\\d ]'), "");
    print(cnpj);
    empresa = await store.getEmpresaLocal(cnpj);
  }

  _salvaDados(DadoPsie dado) async {
    if (dado.inmetro.isEmpty) {}
    tanque = await _criaTanque(dado);
    print(tanque!.toJson());
    empresa = null;
    tanque = null;
  }

  _criaTanque(DadoPsie dado) async {
    tanque = tanque == null ? Tanque() : tanque;
    tanque!.codInmetro = escolhidos[0] ? dado.inmetro : tanque!.codInmetro;
    tanque!.placa = escolhidos[1] ? dado.placa : tanque!.placa;
    tanque!.proprietario = await _criaEmpresa(dado);
    return tanque!;
  }

  _criaEmpresa(DadoPsie dado) async {
    empresa = empresa == null ? Empresa() : empresa;
    empresa!.cnpjCpf = escolhidos[4]
        ? dado.cnpj.replaceAll(RegExp('[^\\d ]'), "")
        : empresa!.cnpjCpf;
    empresa!.razaoSocial =
        escolhidos[3] ? dado.proprietario : empresa!.razaoSocial;
    empresa!.proprietario = null;
    //await _criaProprietario(dado);
    return empresa;
  }

  _criaProprietario(DadoPsie dado) async {
    var p =
        empresa!.proprietario == null ? Proprietario() : empresa!.proprietario!;
    Municipio? mun = await store.getMunicipio(dado.municipio.split(' - ')[0]);
    if (mun == null) return p;
    p.codMun = escolhidos[5] ? mun.cdMunicipio : p.codMun;
    return p;
  }

  _mudaValor(bool valor, int campo) {
    //print('Valor: ' + valor.toString() + ' Campo: ' + campo.toString());
    setState(() {
      escolhidos[campo] = valor;
    });
  }
}
