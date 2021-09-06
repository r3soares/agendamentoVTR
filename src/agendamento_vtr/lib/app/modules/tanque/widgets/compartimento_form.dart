import 'package:agendamento_vtr/app/models/compartimento.dart';
import 'package:agendamento_vtr/app/modules/tanque/widgets/tanque_dialog_widgets/compartimento_widget.dart';
import 'package:flutter/material.dart';

class CompartimentoForm extends StatefulWidget {
  final Function(List<Compartimento>) callback;
  const CompartimentoForm({Key? key, required this.callback}) : super(key: key);

  @override
  _CompartimentoFormState createState() => _CompartimentoFormState();
}

class _CompartimentoFormState extends State<CompartimentoForm> {
  List<Compartimento> compartimentos =
      List.generate(10, (index) => Compartimento('C${index + 1}'));
  int capacidadeTotal = 0;
  int qtdCompartimentos = 1;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SingleChildScrollView(
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
                                  onPressed: () => {
                                        geraCompartimentos(
                                            qtdCompartimentos + 1)
                                      },
                                  child: Icon(Icons.add)),
                            ),
                            SizedBox(
                              width: 30,
                              child: TextButton(
                                  onPressed: () => {
                                        geraCompartimentos(
                                            qtdCompartimentos - 1)
                                      },
                                  child: Icon(Icons.remove)),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  Container(
                    child: Row(
                      children: [
                        Text('Capacidade Total:'),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Text('$capacidadeTotal litros'),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            Container(
                height: size.height * .25,
                padding: const EdgeInsets.all(8),
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: qtdCompartimentos,
                  itemBuilder: (BuildContext context, int index) {
                    print(index);
                    return CompartimentoWidget(
                      compartimento: compartimentos[index],
                      callback: (_) => _calculaCapacidadeTotal(),
                    );
                  },
                )),
          ],
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
      capacidadeTotal = temp;
    });
  }

  void geraCompartimentos(int value) {
    if (value > 10) return;
    if (value == 0) return;
    if (value == qtdCompartimentos) return;
    setState(() {
      qtdCompartimentos = value;
    });
    _calculaCapacidadeTotal();
    widget.callback(compartimentos.sublist(0, qtdCompartimentos - 1));
  }
}
