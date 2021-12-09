import 'package:agendamento_vtr/app/models/tanque.dart';
import 'package:agendamento_vtr/app/modules/agendamento/stores/store_data.dart';
import 'package:flutter/material.dart';

class ListaVeiculosWidget extends StatefulWidget {
  final StoreData<Tanque> storeData;
  final List<Tanque> tanques;
  ListaVeiculosWidget(this.storeData, this.tanques);

  @override
  _ListaVeiculosWidgetState createState() => _ListaVeiculosWidgetState();
}

class _ListaVeiculosWidgetState extends State<ListaVeiculosWidget> {
  final ScrollController scrollController = ScrollController();
  
  @override
  void initState() {
    super.initState();
    widget.storeData.observer(onState: addTanque);
  }

  addTanque(Tanque t) {
    widget.tanques.add(t);
    setState(() {});
  }

  removeTanque(int index) {
    widget.tanques.removeAt(index);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 350,
      child: ListView.builder(
        physics: const ClampingScrollPhysics(),
        controller: scrollController,
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        itemCount: widget.tanques.length,
        itemBuilder: (BuildContext context, int index) {
          Tanque t = widget.tanques.elementAt(index);
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              elevation: 12,
              child: ListTile(
                  leading: IconButton(
                    splashRadius: 5,
                    icon: Icon(
                      Icons.remove_red_eye,
                      color: Theme.of(context).primaryColor,
                    ),
                    onPressed: () => {},
                  ),
                  title: Row(mainAxisSize: MainAxisSize.min, children: [
                    Text(
                      t.placa.replaceRange(3, 3, '-'),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Text(
                        'R\$${t.custoTotal}',
                        style: TextStyle(fontSize: 14, color: Colors.red[800]),
                      ),
                    ),
                  ]),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        splashRadius: 5,
                        icon: Icon(
                          Icons.close,
                          color: Colors.red[800],
                        ),
                        onPressed: () => removeTanque(index),
                      ),
                    ],
                  )),
            ),
          );
        },
      ),
    );
  }
}
