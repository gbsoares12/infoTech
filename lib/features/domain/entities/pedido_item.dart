import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class PedidoItem {
  final String id;
  final dynamic produto;
  final dynamic cliente;
  final int quantidade;
  final double precoUnidade;
  final double desconto;
  final String descricaoProduto;
  final DocumentReference documentReference;

  PedidoItem({
    @required this.id,
    @required this.produto,
    @required this.cliente,
    @required this.quantidade,
    @required this.precoUnidade,
    @required this.desconto,
    @required this.descricaoProduto,
    @required this.documentReference,
  });
}
