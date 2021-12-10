import 'package:agendamento_vtr/app/domain/custo_compartimento.dart';
import 'package:agendamento_vtr/app/domain/erros.dart';
import 'package:agendamento_vtr/app/domain/log.dart';
import 'package:agendamento_vtr/app/models/tanque.dart';
import 'package:agendamento_vtr/app/modules/agendamento/models/municipio.dart';
import 'package:agendamento_vtr/app/modules/agendamento/stores/store_data.dart';
import 'package:agendamento_vtr/app/modules/gru/models/tanque_servico.dart';
import 'package:agendamento_vtr/app/modules/gru/widgets/gera_pdf_widget.dart';
import 'package:agendamento_vtr/app/modules/gru/widgets/lista_veiculos_widget.dart';
import 'package:agendamento_vtr/app/modules/gru/widgets/pesquisa_tanque.dart';
import 'package:agendamento_vtr/app/repositories/repository_municipio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class MainPage extends StatelessWidget {
  final StoreData<Tanque> resultadoPesquisa = StoreData(Tanque());
  final List<Tanque> lista = List.empty(growable: true);

  MainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('GRU'),
        ),
        body: SizedBox.expand(
            child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  PesquisaTanqueWidget(resultadoPesquisa),
                  ListaVeiculosWidget(resultadoPesquisa, lista),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: ElevatedButton(
                      child: Text('Gerar Relatório'),
                      onPressed: () async => await geraPdf(context),
                    ),
                  )
                ],
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Visualizar Relatório'),
                    ),
                  )
                ],
              ),
            )
          ],
        )));
  }

  geraPdf(BuildContext context) async {
    var valida = validaLista();
    if (valida != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(valida)));
      return;
    }
    var custo = CustoCompartimento();
    Map<int, Municipio> mapa = await getMapMunicipios(context);
    var ts = TanqueServico(lista, custo, mapa);
    GeraPdfWidget pdf = GeraPdfWidget(ts);
    pdf.geraPdf();
  }

  getMapMunicipios(BuildContext context) async {
    try {
      final RepositoryMunicipio repoMunicipio = Modular.get<RepositoryMunicipio>();
      Map<int, Municipio> mapa = Map();
      for (var tanque in lista) {
        var codMun = tanque.proprietario!.proprietario!.codMun;
        mapa[codMun] = await repoMunicipio.getMunicipio(codMun);
      }
      return mapa;
    } on Falha catch (e) {
      Log.message(this, 'Erro ao buscar municipios para a lista de tanques: ${e.msg}');
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Erro ao buscar municipios para a lista de tanques')));
    }
  }

  validaLista() {
    for (var t in lista) {
      if (t.proprietario == null) return '${t.placa}: Sem empresa associada';
      if (t.proprietario!.proprietario == null) return '${t.placa}: Sem proprietário associado';
      if (t.proprietario!.proprietario!.cod == 0) return '${t.placa}: Sem código de proprietário associado';
      if (t.proprietario!.proprietario!.codMun == 0) return '${t.placa}: Sem código de município associado';
    }
    return null;
  }
}
