import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'home_store.dart';

class HomePage extends StatefulWidget {
  final String title;
  const HomePage({Key? key, this.title = "Home"}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends ModularState<HomePage, HomeStore> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          leading: Icon(Icons.person),
          title: Text('Nome do Usuário'),
          actions: [
            ElevatedButton.icon(
                style: ButtonStyle(elevation: MaterialStateProperty.all(0)),
                onPressed: () => {},
                icon: Icon(Icons.exit_to_app),
                label: Text('Sair'))
          ],
        ),
        body: Container(
          padding: EdgeInsets.only(bottom: size.height * .3),
          alignment: Alignment.center,
          child: SizedBox(
            height: size.height * .4,
            width: size.width * .5,
            child: Card(
              shadowColor: Colors.black,
              elevation: 12,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    alignment: Alignment.topCenter,
                    padding: EdgeInsets.symmetric(vertical: 20),
                    height: size.height * .1,
                    child: Text(
                      'Veículo Tanque Rodoviário',
                      style: TextStyle(fontSize: 24),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: SizedBox(
                      height: size.height * .08,
                      width: size.width * .2,
                      child: ElevatedButton(
                        onPressed: () => {Modular.to.pushNamed('/tanque')},
                        child: Text('Inserir Veículo'),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: SizedBox(
                      height: size.height * .08,
                      width: size.width * .2,
                      child: ElevatedButton(
                        onPressed: () => {Modular.to.pushNamed('/agendamento')},
                        child: Text('Agendamentos'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
