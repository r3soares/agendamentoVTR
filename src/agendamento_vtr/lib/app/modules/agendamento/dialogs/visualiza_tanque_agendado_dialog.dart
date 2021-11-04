import 'package:agendamento_vtr/app/behaviors/custom_scroll_behavior.dart';
import 'package:agendamento_vtr/app/domain/constantes.dart';
import 'package:agendamento_vtr/app/models/compartimento.dart';
import 'package:agendamento_vtr/app/models/empresa.dart';
import 'package:agendamento_vtr/app/models/tanque.dart';
import 'package:agendamento_vtr/app/modules/agendamento/models/tanque_agendado.dart';
import 'package:flutter/material.dart';

class VisualizaTanqueAgendadoDialog extends StatelessWidget {
  final TanqueAgendado tAgendado;
  final ScrollController scrollControlller = ScrollController();

  VisualizaTanqueAgendadoDialog(this.tAgendado);

  @override
  Widget build(BuildContext context) {
    Tanque tanque = tAgendado.tanque;
    final data = Constants.formatoData.format(tanque.dataRegistro);
    return Dialog(
      child: SingleChildScrollView(
        child: Container(
          width: 800,
          height: 500,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                flex: 1,
                child: Container(
                  padding: EdgeInsets.all(12),
                  alignment: Alignment.topCenter,
                  child: Text(
                    tAgendado.tanque.placaFormatada,
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ),
              Flexible(
                flex: 2,
                child: Column(
                  children: [
                    _titulo('Empresas associadas ao veículo'),
                    Card(
                      elevation: 4,
                      shadowColor: Colors.black,
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                child: const Text(
                                  'Proprietário ',
                                  style: TextStyle(fontSize: 18),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.all(8),
                                child: _proprietarioWidget(tanque.proprietario, 'proprietário'),
                              )
                            ],
                          ),
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                child: const Text(
                                  'Responsável ',
                                  style: TextStyle(fontSize: 18),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.all(8),
                                child: _proprietarioWidget(tAgendado.responsavel, 'responsável'),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Flexible(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _titulo('Dados do tanque'),
                    Expanded(
                      child: Card(
                        elevation: 4,
                        shadowColor: Colors.black,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Flexible(child: _compatimentosWidget(tanque.compartimentos)),
                            Flexible(child: _ultimoAgendamentoWidget())
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Flexible(
                flex: 1,
                child: Container(
                  alignment: Alignment.bottomRight,
                  padding: EdgeInsets.only(top: 12, right: 8),
                  child: Text(
                    'Registrado em $data',
                    style: TextStyle(fontSize: 10),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _titulo(String texto) {
    return Container(
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.all(8),
        child: Text(
          "$texto",
          style: TextStyle(fontSize: 20),
        ));
  }

  Widget _compatimentosWidget(List<Compartimento> compartimentos) {
    if (compartimentos.isEmpty) {
      return TextButton(
        onPressed: () => {},
        child: Text(
          'Sem compartimentos cadastrados',
          style: TextStyle(fontSize: 18, color: Colors.blueAccent),
        ),
      );
    }
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(
          flex: 1,
          child: Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.all(8),
            child: Text(
              'Compartimentos\n${tAgendado.tanque.capacidadeTotal} L',
              textAlign: TextAlign.center,
            ),
          ),
        ),
        Expanded(flex: 4, child: _listaCompartimentos(compartimentos)),
      ],
    );
  }

  Widget _listaCompartimentos(List<Compartimento> compartimentos) {
    return ScrollConfiguration(
      behavior: CustomScrollBehavior(),
      child: ListView.builder(
          itemExtent: 80,
          physics: const ClampingScrollPhysics(),
          controller: scrollControlller,
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemCount: compartimentos.length,
          itemBuilder: (BuildContext context, int i) {
            Compartimento c = compartimentos.elementAt(i);
            return Card(
              elevation: 4,
              shadowColor: Colors.black,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('${c.capacidade} L'),
                    c.setas > 0 ? Text('${c.setas} SS') : const SizedBox.shrink(),
                  ],
                ),
              ),
            );
          }),
    );
  }

  Widget _ultimoAgendamentoWidget() {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: tAgendado.isNovo
          ? Text('Veículo novo')
          : tAgendado.agendaAnterior == null
              ? Text('Sem dados do último agendamento')
              : TextButton(
                  child: Text(
                    'Visualizar último agendamento',
                    style: TextStyle(color: Colors.blueAccent),
                  ),
                  onPressed: () => {},
                ),
    );
  }

  Widget _proprietarioWidget(Empresa? p, String proOuResp) {
    return p == null
        ? TextButton(
            onPressed: () => {},
            child: Text(
              'Nenhum $proOuResp definido',
              style: TextStyle(fontSize: 18, color: Colors.blueAccent),
            ))
        : TextButton(
            onPressed: () => {},
            child: Text(
              '${p.razaoSocial}',
              style: TextStyle(fontSize: 18, color: Colors.blueAccent),
            ));
  }
}
