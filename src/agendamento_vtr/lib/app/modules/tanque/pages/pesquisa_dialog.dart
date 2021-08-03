import 'package:agendamento_vtr/app/modules/tanque/widgets/pesquisa_empresas_widget.dart';
import 'package:flutter/material.dart';

class PesquisaDialog extends StatelessWidget {
  const PesquisaDialog();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Dialog(
      child: Container(
        width: size.width * .4,
        height: size.height * .6,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            PesquisaEmpresaWidget(),
          ],
        ),
      ),
    );
  }
}
