class Falha implements Exception {
  final msg;
  Falha(this.msg);
}

class ErroConexao extends Falha {
  ErroConexao(msg) : super(msg);
}

class TempoExcedido extends Falha {
  TempoExcedido(msg) : super(msg);
}

class Vazio extends Falha {
  Vazio(msg) : super(msg);
}

class NaoEncontrado extends Falha {
  NaoEncontrado(msg) : super(msg);
}

class ErroRequisicao extends Falha {
  ErroRequisicao(msg) : super(msg);
}

class ErroServidor extends Falha {
  ErroServidor(msg) : super(msg);
}
