import 'package:agendamento_vtr/app/modules/cadastrados/pages/empresas_tab.dart';
import 'package:agendamento_vtr/app/modules/cadastrados/pages/tanques_tab.dart';
import 'package:agendamento_vtr/app/modules/cadastrados/stores/main_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_triple/flutter_triple.dart';

class MainPage extends StatefulWidget {
  const MainPage();

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends ModularState<MainPage, MainStore> {
  @override
  void initState() {
    store.getTanques();
    store.getEmpresas();
    super.initState();
  }

  @override
  void dispose() {
    //store.destroy();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //print('Reconstruindo Main Page');
    return DefaultTabController(
      initialIndex: 0,
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Lista de Veículos cadastrados'),
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
            ScopedBuilder(
              store: store.sTanque,
              onState: (context, state) => TanquesTab(state),
              onLoading: (context) => CircularProgressIndicator(),
              onError: (context, error) => _erro(),
            ),
            ScopedBuilder(
              store: store.sEmpresa,
              onState: (context, state) => EmpresasTab(state),
              onLoading: (context) => CircularProgressIndicator(),
              onError: (context, error) => _erro(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _erro() {
    return Center(
      child: Text('Erro ao carregar os dados'),
    );
  }
}
