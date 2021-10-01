import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

abstract class BaseWidgets extends StatefulWidget {
  final OverlayEntry loadingOverlay = OverlayEntry(builder: (_) {
    return Container(
      alignment: Alignment.center,
      color: Colors.black38,
      child: CircularProgressIndicator(),
    );
  });

  loading(bool isLoading, BuildContext context) {
    if (isLoading) {
      Overlay.of(context)?.insert(loadingOverlay);
    } else {
      loadingOverlay.remove();
    }
  }

  Widget btnsalvar({String nome = 'Salvar', required void Function() onPressed}) {
    return Container(
      padding: const EdgeInsets.all(8),
      child: ElevatedButton(
        child: Text(nome),
        onPressed: onPressed,
      ),
    );
  }

  Widget btnVoltar({String nome = 'Voltar'}) {
    return Container(
      padding: const EdgeInsets.all(8),
      child: TextButton(
        child: Text(nome),
        onPressed: () => Modular.to.pop(),
      ),
    );
  }
}
