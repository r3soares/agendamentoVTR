import 'package:agendamento_vtr/app/modules/wizard/pages/pre_registro_tab.dart';
import 'package:agendamento_vtr/app/modules/wizard/pages/proprietario_tab.dart';
import 'package:agendamento_vtr/app/modules/wizard/pages/responsavel_tab.dart';
import 'package:agendamento_vtr/app/modules/wizard/pages/revisao_tab.dart';
import 'package:agendamento_vtr/app/modules/wizard/pages/tanque_tab.dart';
import 'package:flutter/material.dart';

class MainPage extends StatefulWidget {
  const MainPage();

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 5);
  }

  Widget build(BuildContext context) {
    //print('Reconstruindo Main Page');
    return DefaultTabController(
      initialIndex: 0,
      length: 5,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Cadastro de solicitação'),
          bottom: TabBar(controller: _tabController, tabs: [
            Tab(
              text: 'Solicitação',
            ),
            Tab(
              text: 'Responsável',
            ),
            Tab(
              text: 'Proprietário',
            ),
            Tab(
              text: 'Tanque',
            ),
            Tab(
              text: 'Revisão',
            )
          ]),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            PreRegistroTab(_tabController),
            ResponsavelTab(_tabController),
            ProprietarioTab(_tabController),
            TanqueTab(_tabController),
            RevisaoTab(_tabController),
          ],
        ),
      ),
    );
  }
}
