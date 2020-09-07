import 'package:flutter/foundation.dart';

class Cliente {
  final String id;
  final String nome;
  final String cpf;
  final String logradouro;
  final String numero;
  final String bairro;
  final String cidade;
  final String cep;
  final String estado;
  final String desconto;
  final dynamic documentReference;

  Cliente(
      {@required this.id,
      @required this.nome,
      @required this.cpf,
      @required this.logradouro,
      @required this.numero,
      @required this.bairro,
      @required this.cidade,
      @required this.cep,
      @required this.estado,
      @required this.desconto,
      @required this.documentReference});
}
