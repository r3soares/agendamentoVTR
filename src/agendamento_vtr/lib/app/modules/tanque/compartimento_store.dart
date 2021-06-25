import 'package:flutter_triple/flutter_triple.dart';

import 'models/compartimento.dart';

class CompartimentoStore extends NotifierStore<Exception, Compartimento> {
  CompartimentoStore(Compartimento initialState) : super(initialState);

  void setCapacidade(int valor) {
    state.capacidade = valor;
    update(state);
  }

  void addSeta(int valor) {
    state.setas.add(valor);
    update(state);
  }

  void removeSeta(int valor) {
    state.setas.remove(valor);
    update(state);
  }
}
