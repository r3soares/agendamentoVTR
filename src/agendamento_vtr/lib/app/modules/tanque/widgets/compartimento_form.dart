import 'package:agendamento_vtr/app/behaviors/custom_scroll_behavior.dart';
import 'package:agendamento_vtr/app/models/compartimento.dart';
import 'package:agendamento_vtr/app/modules/tanque/stores/tanque_store.dart';
import 'package:agendamento_vtr/app/modules/tanque/widgets/tanque_page_widgets/compartimento_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class CompartimentoForm extends StatefulWidget {
  final Function(List<Compartimento>) callback;
  final List<Compartimento>? compartimentosPrevio;
  const CompartimentoForm({Key? key, this.compartimentosPrevio, required this.callback}) : super(key: key);

  @override
  _CompartimentoFormState createState() => _CompartimentoFormState();
}

class _CompartimentoFormState extends ModularState<CompartimentoForm, TanqueStore> {
  final ScrollController scrollController = ScrollController();
  late List<Compartimento> compartimentos;
  int _capacidadeTotal = 0;
  double _custoTotal = 0;
  int qtdCompartimentos = 0;

  @override
  void initState() {
    super.initState();
    _configuraCompartimentos();
    _notificaListener();
  }

  void _configuraCompartimentos() {
    compartimentos = List.generate(10, (index) => Compartimento(index + 1));
    if (widget.compartimentosPrevio != null) {
      for (int i = 0; i < widget.compartimentosPrevio!.length; i++) {
        compartimentos[i] = widget.compartimentosPrevio![i];
      }
      qtdCompartimentos = widget.compartimentosPrevio!.length;
      _calculaCapacidadeTotal();
      _calculaCustoTotal();
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return ScrollConfiguration(
      behavior: CustomScrollBehavior(),
      child: SingleChildScrollView(
        physics: ClampingScrollPhysics(),
        controller: scrollController,
        child: Card(
          elevation: 4,
          shadowColor: Colors.black,
          child: Column(
            children: [
              Container(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.all(8),
                child: Text(
                  'Compartimento',
                  style: TextStyle(fontSize: 20),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      child: Row(
                        children: [
                          Text('Quantidade:'),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Text('$qtdCompartimentos'),
                          ),
                          Row(
                            children: [
                              SizedBox(
                                width: 30,
                                child: TextButton(
                                    onPressed: () => {geraCompartimentos(qtdCompartimentos + 1)},
                                    child: Icon(Icons.add)),
                              ),
                              SizedBox(
                                width: 30,
                                child: TextButton(
                                    onPressed: () => {geraCompartimentos(qtdCompartimentos - 1)},
                                    child: Icon(Icons.remove)),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                    Container(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text('Capacidade Total:'),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              child: Text('$_capacidadeTotal litros'),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.only(top: 8),
                          alignment: Alignment.centerRight,
                          child: Text(
                            formataCusto(),
                            style: TextStyle(color: Colors.red[900]),
                          ),
                        )
                      ],
                    ))
                  ],
                ),
              ),
              Container(
                  height: size.height * .30,
                  padding: const EdgeInsets.all(8),
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: qtdCompartimentos,
                    itemBuilder: (BuildContext context, int index) {
                      return CompartimentoWidget(
                        compartimento: compartimentos[index],
                        callback: (_) => {
                          _calculaCapacidadeTotal(),
                          _calculaCustoTotal(),
                          _notificaListener(),
                        },
                      );
                    },
                  )),
            ],
          ),
        ),
      ),
    );
  }

  void _calculaCapacidadeTotal() {
    int temp = 0;
    for (int i = 0; i < qtdCompartimentos; i++) {
      temp += compartimentos[i].capacidade;
    }
    setState(() {
      _capacidadeTotal = temp;
    });
  }

  void _calculaCustoTotal() {
    double custoCompartimentos = 0;
    custoCompartimentos = store.getCusto(compartimentos);
    setState(() {
      _custoTotal = custoCompartimentos;
    });
  }

  String formataCusto() {
    return controller.formato.format(_custoTotal);
  }

  void geraCompartimentos(int value) {
    if (value == qtdCompartimentos) return;
    if (value > 10) return;
    if (value == -1) return;
    setState(() {
      qtdCompartimentos = value;
    });
    _calculaCapacidadeTotal();
    _notificaListener();
  }

  void _notificaListener() {
    widget.callback(compartimentos.sublist(0, qtdCompartimentos));
  }
}
