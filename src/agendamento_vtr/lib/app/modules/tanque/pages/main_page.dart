import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class MainPage extends StatelessWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          title: Text('Menu'),
        ),
        body: Container(
          padding: EdgeInsets.only(bottom: size.height * .3),
          alignment: Alignment.topCenter,
          child: SizedBox(
            height: size.height * .5,
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
                      'Gerenciar Tanques',
                      style: TextStyle(fontSize: 24),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: SizedBox(
                      height: size.height * .08,
                      width: size.width * .2,
                      child: ElevatedButton(
                        onPressed: () => {Modular.to.navigate('cadastro')},
                        child: Text('Novo Tanque'),
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
