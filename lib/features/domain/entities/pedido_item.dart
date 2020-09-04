import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:infoTech/features/domain/entities/cliente.dart';
import 'package:infoTech/features/domain/entities/produto.dart';
import 'package:flutter/foundation.dart';

class PedidoItem {
  final String id;
  final Produto produto;
  final Cliente cliente;
  final int quantidade;
  final double precoUnidade;
  final double desconto;
  final DocumentReference documentReference;

  PedidoItem({
    @required this.id,
    @required this.produto,
    @required this.cliente,
    @required this.quantidade,
    @required this.precoUnidade,
    @required this.desconto,
    @required this.documentReference,
  });
}
