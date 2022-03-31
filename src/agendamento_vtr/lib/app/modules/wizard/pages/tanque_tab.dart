import 'package:flutter/material.dart';

class TanqueTab extends StatefulWidget {
  final TabController tabController;
  const TanqueTab(this.tabController);

  @override
  State<TanqueTab> createState() => _TanqueTabState();
}

class _TanqueTabState extends State<TanqueTab>
    with AutomaticKeepAliveClientMixin<TanqueTab> {
  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 400,
        height: 500,
        child: Card(
          shadowColor: Colors.black,
          elevation: 12,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 300,
                margin: EdgeInsets.all(12),
                child: TextFormField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'CNPJ',
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.all(12),
                width: 300,
                child: TextFormField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Nome',
                  ),
                ),
              ),
              Container(
                width: 300,
                margin: EdgeInsets.all(12),
                child: TextFormField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Município',
                  ),
                ),
              ),
              Container(
                width: 300,
                margin: EdgeInsets.all(12),
                child: TextFormField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Número do proprietário',
                  ),
                ),
              ),
              Container(
                width: 300,
                margin: EdgeInsets.all(12),
                child: TextFormField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Observação',
                  ),
                ),
              ),
              Row(
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
                  IconButton(
                    iconSize: 42,
                    icon: Icon(
                      Icons.arrow_circle_right_outlined,
                      color: Theme.of(context).primaryColor,
                    ),
                    onPressed: () => widget.tabController
                        .animateTo(widget.tabController.index + 1),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
