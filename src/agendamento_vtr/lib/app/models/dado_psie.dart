class DadoPsie {
  final String ano;
  final String chassi;
  final String cnpj;
  final String inmetro;
  final String marca;
  final String municipio;
  final String numSerie;
  final String placa;
  final String proprietario;
  final String uf;

  DadoPsie(this.ano, this.chassi, this.cnpj, this.inmetro, this.marca,
      this.municipio, this.numSerie, this.placa, this.proprietario, this.uf);

  DadoPsie.fromJson(Map<String, dynamic> json)
      : ano = json['ano'],
        chassi = json['chassi'],
        cnpj = json['cnpj'],
        inmetro = json['inmetro'],
        marca = json['marca'],
        municipio = json['municipio'],
        numSerie = json['numSerie'],
        placa = json['placa'],
        proprietario = json['proprietario'],
        uf = json['uf'];

  Map<String, dynamic> toJson() => {
        'ano': ano,
        'chassi': chassi,
        'cnpj': cnpj,
        'inmetro': inmetro,
        'marca': marca,
        'municipio': municipio,
        'numSerie': numSerie,
        'placa': placa,
        'proprietario': proprietario,
        'uf': uf,
      };
}
