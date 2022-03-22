import 'package:agendamento_vtr/app/modules/cadastrados/pages/download_dialog.dart';
import 'package:agendamento_vtr/app/modules/cadastrados/pages/empresas_tab.dart';
import 'package:agendamento_vtr/app/modules/cadastrados/pages/tanques_tab.dart';
import 'package:flutter/material.dart';

class MainPage extends StatelessWidget {
  const MainPage();

  Widget build(BuildContext context) {
    //print('Reconstruindo Main Page');
    return DefaultTabController(
      initialIndex: 0,
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Lista de Veículos cadastrados'),
          actions: [
            TextButton(
              onPressed: () => {
                showDialog(
                    barrierDismissible: true,
                    barrierColor: Color.fromRGBO(0, 0, 0, .5),
                    useSafeArea: true,
                    context: context,
                    builder: (_) => DownloadDialog()),
              },
              child: Text('Download do PSIE',
                  style: TextStyle(
                      color: Colors.amber, fontWeight: FontWeight.bold)),
            )
          ],
          bottom: TabBar(tabs: [
            Tab(
              text: 'Veículos',
            ),
            Tab(
              text: 'Empresas',
            )
          ]),
        ),
        body: TabBarView(
          children: [
            TanquesTab(),
            EmpresasTab(),
          ],
        ),
      ),
    );
  }
}
