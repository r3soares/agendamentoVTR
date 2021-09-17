import 'package:agendamento_vtr/app/models/empresa.dart';
import 'package:agendamento_vtr/app/models/proprietario.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Teste de conversao Json <-> Model', () {
    Empresa e = new Empresa();
    e.cnpjCpf = '00970455941';
    e.razaoSocial = 'Rodo Rodas';
    e.status = StatusEmpresa.PreCadastro;
    e.email = 'teste@teste';
    e.proprietario = Proprietario()
      ..cod = 1
      ..codMun = 100
      ..tanques.addAll(['OKG5498', 'MME1396']);
    e.telefones.add('91977750');
    //e.telefones.add('96570818');
    Map<String, dynamic> json = e.toJson();
    Empresa e2 = e.fromJson(json);
    expect(e.cnpjCpf, equals(e2.cnpjCpf), reason: 'CNPJ não validou');
    expect(e.email, equals(e2.email), reason: 'Email não validou');
    expect(e.status, equals(e2.status), reason: 'Status não validou');
    expect(e.proprietario!.cod, equals(e2.proprietario!.cod),
        reason: 'CodProp não validou');
    expect(e.proprietario!.codMun, equals(e2.proprietario!.codMun),
        reason: 'CodMunProp não validou');
    expect(e.proprietario!.tanques[0], equals(e2.proprietario!.tanques[0]),
        reason: 'TanqueProp não validou');
  });
}
