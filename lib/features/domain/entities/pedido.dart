import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:infoTech/features/domain/entities/cliente.dart';
import 'package:infoTech/features/domain/entities/produto.dart';

class Pedido {
  final String id;
  final dynamic clienteDocumentReferente;
  final Cliente cliente;
  final List<dynamic> listaProdutosDocumentReferente;
  final List<Produto> listaProdutos;
  final double valorTotal;
  final dynamic documentReference;

  Pedido(
      {@required this.id,
      @required this.clienteDocumentReferente,
      @required this.cliente,
      @required this.listaProdutosDocumentReferente,
      @required this.listaProdutos,
      @required this.valorTotal,
      @required this.documentReference});
}
