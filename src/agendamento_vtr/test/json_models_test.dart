import 'package:agendamento_vtr/app/models/empresa.dart';
import 'package:agendamento_vtr/app/models/proprietario.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Teste de conversao Json <-> Model', () {
    Empresa e = new Empresa();
    e.cnpjCpf = '00970455941';
    e.email = 'teste@teste';
    e.proprietario = Proprietario()
      ..cod = 1
      ..codMun = 100
      ..tanques.addAll(['OKG5498', 'MME1396']);
    e.telefones.add('91977750');
    Map<String, dynamic> json = e.toJson();
    Empresa e2 = e.fromJson(json);
    expect(e.cnpjCpf, equals(e2.cnpjCpf));
    expect(e.proprietario!.cod, equals(e2.proprietario!.cod));
  });
}
