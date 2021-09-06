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
  List<Compartimento> compartimentos = [Compartimento('C1')];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    widget.callback(compartimentos);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Container(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(8),
              child: Row(
                children: [
                  Text('Compartimentos:'),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Text('${compartimentos.length}'),
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: 30,
                        child: TextButton(
                            onPressed: () =>
                                {geraCompartimentos(compartimentos.length + 1)},
                            child: Icon(Icons.add)),
                      ),
                      SizedBox(
                        width: 30,
                        child: TextButton(
                            onPressed: () =>
                                {geraCompartimentos(compartimentos.length - 1)},
                            child: Icon(Icons.remove)),
                      ),
                    ],
                  )
                ],
              ),
            ),
            Container(
                height: size.height * .25,
                padding: const EdgeInsets.all(8),
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: compartimentos.length,
                  itemBuilder: (BuildContext context, int index) {
                    print(index);
                    return CompartimentoWidget(
                        compartimento: compartimentos[index]);
                  },
                )),
          ],
        ),
      ),
    );
  }

  void geraCompartimentos(int value) {
    if (value > 10) return;
    if (value == 0) return;
    if (value == compartimentos.length) return;
    setState(() {
      compartimentos =
          List.generate(value, (index) => Compartimento('C${index + 1}'));
    });
  }
}
