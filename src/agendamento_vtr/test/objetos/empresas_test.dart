import 'dart:math';

import 'package:agendamento_vtr/app/models/empresa.dart';
import 'package:agendamento_vtr/app/models/proprietario.dart';

import 'tanques_test.dart';

class EmpresasTest {
  List<Empresa> empresas = List.empty(growable: true);
  Random r = Random();

  final emails = [
    'kj@email.com',
    'test2@gmail.com',
    'nost@hotmail.com',
    'bestrk@yahoo.com.br',
    'xgw@bol.com.br',
    'mosketu@dalcoquio.com.br',
    'juscelino@gmail.com'
  ];
  final nomes = [
    'Rolando Milhas',
    'Dalcoquio Ltda',
    'Tropical Ipiranga',
    'None',
    'Cocaco Ltda',
    'Meu Tanque Minha Vida',
    'Super Truck Ltda',
    'Shell Ltda',
    'Tanqueex',
    'Veiculo Examine',
    'Veiculo Squad',
    'Veiculo Capital',
    'Tanque Mate',
    'Rodoviario Hunter',
    'Veiculory',
    'Tanque Morals',
    'Tanquelux',
    'Rodoviariozilla',
    'Veiculo Zol',
    'Rodoviariolada',
    'Xibata Tanque',
    'Tanqueopolis',
    'Veiculo Dream',
    'Tanque Fast Road',
    'Veiculo Fox',
    'Tanque Blindados',
    'Rodoviario Excel',
    'Tanque Sueter',
    'Rodas Redondas',
    'Rodas Grandes',
    'Rodo Anel'
  ];
  final cpfs = [
    '98687404018',
    '27823218038',
    '91559533000163',
    '58166623000119',
    '15763413000103',
    '17861158160',
    '01761844571',
    '78505212000118',
    '36375402000118',
    '50778771000182',
    '21313034000106',
    '55055314000183',
    '21555358000150',
    '54164736000124',
    '58414304000185',
    '02562417000173',
    '48537891460',
    '23545414221',
    '75813335234',
    '83227101000127',
    '85841675000116',
    '58189325000144',
    '03729255886',
    '16431581000156',
    '57165458000118',
    '33354320370',
    '67285647000188',
    '87355717480',
    '21904035000125'
  ];
  EmpresasTest() {
    for (int i = 0; i < cpfs.length; i++) {
      Empresa e = new Empresa()
        ..cnpjCpf = cpfs[i]
        ..email = cpfs[r.nextInt(emails.length - 1)]
        ..proprietario = r.nextBool() == true
            ? (Proprietario()
              ..cod = i
              ..codMun = r.nextInt(1000)
              ..tanques = List.generate(r.nextInt(10), (index) => TanquesTest.geraPlaca()))
            : null
        ..razaoSocial = nomes[i]
        ..status = StatusEmpresa.values[r.nextInt(StatusEmpresa.values.length)]
        ..telefones = List.generate(r.nextInt(3), (index) => geraTelefone());
      empresas.add(e);
    }
  }
  String geraTelefone() =>
      '${r.nextInt(9)}${r.nextInt(9)}${r.nextInt(9)}${r.nextInt(9)}${r.nextInt(9)}${r.nextInt(9)}${r.nextInt(9)}${r.nextInt(9)}${r.nextInt(9)}';
}
