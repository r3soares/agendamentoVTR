import 'package:flutter/material.dart';

class ResponsavelTab extends StatefulWidget {
  final TabController tabController;
  const ResponsavelTab(this.tabController);

  @override
  State<ResponsavelTab> createState() => _ResponsavelTabState();
}

class _ResponsavelTabState extends State<ResponsavelTab>
    with AutomaticKeepAliveClientMixin<ResponsavelTab> {
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
                    labelText: 'Empresa',
                  ),
                ),
              ),
              Container(
                width: 300,
                margin: EdgeInsets.all(12),
                child: TextFormField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'E-mail',
                  ),
                ),
              ),
              Container(
                width: 300,
                margin: EdgeInsets.all(12),
                child: TextFormField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Telefone',
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
