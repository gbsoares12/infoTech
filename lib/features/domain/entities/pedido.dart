import 'package:flutter/foundation.dart';
import 'package:infoTech/features/domain/entities/pedido_item.dart';

class Pedido {
  final String id;
  final dynamic clienteDocumentReferente;
  final dynamic cliente;
  final List<dynamic> listaItensPedidoDocumentReferente;
  final List<PedidoItem> listaItensPedido;
  final double valorTotal;
  final String nomeCliente;
  final dynamic documentReference;

  Pedido(
      {@required this.id,
      @required this.clienteDocumentReferente,
      @required this.cliente,
      @required this.listaItensPedidoDocumentReferente,
      @required this.listaItensPedido,
      @required this.valorTotal,
      @required this.nomeCliente,
      @required this.documentReference});
}
