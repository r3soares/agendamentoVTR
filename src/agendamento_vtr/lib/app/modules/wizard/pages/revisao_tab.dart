import 'package:flutter/material.dart';

class RevisaoTab extends StatefulWidget {
  final TabController tabController;
  const RevisaoTab(this.tabController);

  @override
  State<RevisaoTab> createState() => _RevisaoTabState();
}

class _RevisaoTabState extends State<RevisaoTab>
    with AutomaticKeepAliveClientMixin<RevisaoTab> {
  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Expanded(
            flex: 5,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 300,
                  height: 500,
                  child: Card(
                    shadowColor: Colors.black,
                    elevation: 12,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ListTile(
                          title: Text('Data'),
                          trailing: Text('25/03/2022'),
                        ),
                        ListTile(
                          title: Text('Hora'),
                          trailing: Text('25/03/2022'),
                        ),
                        ListTile(
                          title: Text('Placa'),
                          trailing: Text('25/03/2022'),
                        ),
                        ListTile(
                          title: Text(''),
                          trailing: Text(''),
                        ),
                        ListTile(
                          title: Text(''),
                          trailing: Text(''),
                        ),
                        Center(
                          child: ElevatedButton(
                              onPressed: () => {}, child: Text('Revisar')),
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  width: 300,
                  height: 500,
                  child: Card(
                    shadowColor: Colors.black,
                    elevation: 12,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ListTile(
                          title: Text('Nome'),
                          trailing: Text('Fulano da Silva Júnior'),
                        ),
                        ListTile(
                          title: Text('Empresa'),
                          trailing: Text('Empresa Muito Ltda Mesmo'),
                        ),
                        ListTile(
                          title: Text('E-mail'),
                          trailing: Text('delcrano@yahoo.com.br'),
                        ),
                        ListTile(
                          title: Text('Telefone'),
                          trailing: Text('(47) 9 9255-6954'),
                        ),
                        ListTile(
                          title: Text('Observação'),
                          trailing: Text(
                            'Observando....',
                          ),
                        ),
                        Center(
                          child: ElevatedButton(
                              onPressed: () => {}, child: Text('Revisar')),
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  width: 300,
                  height: 500,
                  child: Card(
                    shadowColor: Colors.black,
                    elevation: 12,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ListTile(
                          title: Text('Nome'),
                          trailing: Text('Proprietario Ltda'),
                        ),
                        ListTile(
                          title: Text('CNPJ'),
                          trailing: Text('88.256.365./0001-35'),
                        ),
                        ListTile(
                          title: Text('Municipio'),
                          trailing: Text('Santo Amaro da Imperatriz'),
                        ),
                        ListTile(
                          title: Text('N. Proprietário'),
                          trailing: Text('265968'),
                        ),
                        ListTile(
                          title: Text('Observação'),
                          trailing: Text('Observando...'),
                        ),
                        Center(
                          child: ElevatedButton(
                              onPressed: () => {}, child: Text('Revisar')),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  iconSize: 42,
                  icon: Icon(
                    Icons.arrow_circle_left_outlined,
                    color: Theme.of(context).primaryColor,
                  ),
                  onPressed: () => widget.tabController
                      .animateTo(widget.tabController.index - 1),
                ),
                ElevatedButton(onPressed: () => {}, child: Text('Salvar'))
              ],
            ),
          )
        ],
      ),
    );
  }
}
