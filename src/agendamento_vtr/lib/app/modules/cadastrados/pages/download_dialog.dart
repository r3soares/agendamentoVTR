import 'package:agendamento_vtr/app/models/dado_psie.dart';
import 'package:agendamento_vtr/app/modules/cadastrados/stores/download_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_triple/flutter_triple.dart';

class DownloadDialog extends StatefulWidget {
  const DownloadDialog({Key? key}) : super(key: key);

  @override
  State<DownloadDialog> createState() => _DownloadDialogState();
}

class _DownloadDialogState extends ModularState<DownloadDialog, DownloadStore> {
  final TextEditingController _cPlaca = TextEditingController();
  List<bool> escolhidos = [true, true, true, true, true, true, true];

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: 600,
        height: 500,
        child: Column(children: [
          placaWidget(),
          ScopedBuilder(
            store: store,
            onState: (context, DadoPsie state) => dadosPsieWidget(state),
            onLoading: (context) => const CircularProgressIndicator(),
            onError: (context, error) => Text('Erro'),
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
        child: Column(
          children: [
            ListTile(
              leading: Checkbox(
                value: escolhidos[0],
                onChanged: (valor) => _mudaValor(valor!, 0),
              ),
              title: Text('Inmetro'),
              trailing: Text(dado.inmetro),
            ),
            ListTile(
              leading: Checkbox(
                value: escolhidos[1],
                onChanged: (valor) => _mudaValor(valor!, 0),
              ),
              title: Text('Placa'),
              trailing: Text(dado.placa),
            ),
            ListTile(
              leading: Checkbox(
                value: escolhidos[2],
                onChanged: (valor) => _mudaValor(valor!, 2),
              ),
              title: Text('Série'),
              trailing: Text(dado.numSerie),
            ),
            ListTile(
              leading: Checkbox(
                value: escolhidos[3],
                onChanged: (valor) => _mudaValor(valor!, 3),
              ),
              title: Text('Proprietario'),
              trailing: Text(dado.proprietario),
            ),
            ListTile(
              leading: Checkbox(
                value: escolhidos[4],
                onChanged: (valor) => _mudaValor(valor!, 4),
              ),
              title: Text('CNPJ'),
              trailing: Text(dado.cnpj),
            ),
            ListTile(
              leading: Checkbox(
                value: escolhidos[5],
                onChanged: (valor) => _mudaValor(valor!, 5),
              ),
              title: Text('Município'),
              trailing: Text(dado.municipio),
            ),
            ListTile(
              leading: Checkbox(
                value: escolhidos[6],
                onChanged: (valor) => _mudaValor(valor!, 6),
              ),
              title: Text('UF'),
              trailing: Text(dado.uf),
            ),
          ],
        ),
      );

  _mudaValor(bool valor, int campo) {
    setState(() {
      escolhidos[campo] = !valor;
    });
  }
}
