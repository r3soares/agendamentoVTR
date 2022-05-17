import 'package:agendamento_vtr/app/modules/wizard/stores/tanque_store.dart';
import 'package:agendamento_vtr/app/modules/wizard/widgets/tanque_form_widget.dart';
import 'package:agendamento_vtr/app/modules/wizard/wizard_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_triple/flutter_triple.dart';

class TanqueTab extends StatefulWidget {
  final TabController tabController;
  const TanqueTab(this.tabController);

  @override
  State<TanqueTab> createState() => _TanqueTabState();
}

class _TanqueTabState extends ModularState<TanqueTab, TanqueStore>
    with AutomaticKeepAliveClientMixin<TanqueTab> {
  @override
  bool get wantKeepAlive => false;

  final _controller = Modular.get<WizardController>();
  bool isBitrem = false;

  @override
  void initState() {
    super.initState();
    widget.tabController.addListener(_onUpdateTab);
  }

  @override
  void dispose() {
    widget.tabController.removeListener(_onUpdateTab);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
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
              child: ScopedBuilder(
                store: store,
                onState: (context, List tanques) {
                  return tanques.isEmpty
                      ? Center(
                          child: Text('Placa não informada na solicitação'),
                        )
                      : Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(child: TanqueFormWidget(tanques[0])),
                            isBitrem
                                ? Expanded(child: TanqueFormWidget(tanques[1]))
                                : SizedBox.shrink(),
                          ],
                        );
                },
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
    if (widget.tabController.index != 3) return;
    String? placa1 = _controller.dados['placa1'];
    String? placa2 = _controller.dados['placa2'];
    setState(() {
      isBitrem = placa2 != null && placa2.length == 7;
    });
    if (placa1 != null) store.getTanques(placa1, placa2);
  }
}
