class Cadastro {
  final int codigo;
  final String descricao;

  Cadastro({
    required this.codigo,
    required this.descricao,
  });

  Map<String, dynamic> toMap() {
    return {
      'codigo': codigo,
      'descricao': descricao,
    };
  }

  factory Cadastro.fromMap(Map<String, dynamic> map) {
    return Cadastro(
      codigo: map['codigo'],
      descricao: map['descricao'],
    );
  }
}