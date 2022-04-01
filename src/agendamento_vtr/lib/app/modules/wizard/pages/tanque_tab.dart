import 'package:agendamento_vtr/app/models/tanque.dart';
import 'package:agendamento_vtr/app/modules/wizard/widgets/tanque_form_widget.dart';
import 'package:agendamento_vtr/app/modules/wizard/wizard_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

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

  final _controller = Modular.get<WizardController>();
  final Tanque tanque1 = Tanque();
  final Tanque tanque2 = Tanque();
  bool isBitrem = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    widget.tabController.addListener(_onUpdateTab);
    _onUpdateTab();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    widget.tabController.removeListener(_onUpdateTab);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        shadowColor: Colors.black,
        elevation: 12,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              flex: 6,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(child: TanqueFormWidget(tanque1)),
                  isBitrem
                      ? Expanded(child: TanqueFormWidget(tanque2))
                      : SizedBox.shrink(),
                ],
              ),
            ),
            Expanded(
              flex: 1,
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
            ),
          ],
        ),
      ),
    );
  }

  _onUpdateTab() {
    setState(() {
      isBitrem = _controller.dados.keys.contains('placa2') &&
          _controller.dados['placa2'].length == 7;
      tanque1.placa = _controller.dados['placa1'];
      tanque2.placa = _controller.dados['placa2'];
    });
  }
}
