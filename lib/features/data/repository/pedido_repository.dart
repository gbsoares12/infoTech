import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:infoTech/features/domain/entities/cliente.dart';
import 'package:infoTech/features/domain/entities/pedido_item.dart';
import 'package:infoTech/features/domain/entities/produto.dart';

class PedidoRepository {
  final Firestore _firestore = Firestore.instance;

  static PedidoRepository _instance;

  factory PedidoRepository() {
    _instance ??= PedidoRepository._internalConstructor();
    return _instance;
  }
  PedidoRepository._internalConstructor();

  Future<bool> cadastrarPedido(
      Cliente cliente, List<PedidoItem> listaItensPedido) async {
    double totalValorPedido = 0.0;

    listaItensPedido.forEach((itemPedido) {
      totalValorPedido = (itemPedido.quantidade * itemPedido.precoUnidade) -
          itemPedido.desconto * itemPedido.quantidade;
    });

    DocumentReference pedidoDocumentReference = await _firestore
        .collection("pedidos")
        .add({
      "cliente": cliente.documentReference,
      "valorTotal": totalValorPedido
    });

    for (var itemPedido in listaItensPedido) {
      pedidoDocumentReference.collection("ItensPedido").add({
        "produto": itemPedido.produto.documentReference,
        "quantidade": itemPedido.quantidade,
        "precoUnidade": itemPedido.precoUnidade,
        "desconto": itemPedido.desconto,
      });
    }

    if (pedidoDocumentReference != null) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> deletarPedido(DocumentReference pedidoDocumentReference) async {
    try {
      await pedidoDocumentReference.delete();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> editarPedido(Map<String, dynamic> mapPedidoEditado,
      DocumentReference pedidoDocumentReferente) async {
    try {
      await pedidoDocumentReferente.updateData(mapPedidoEditado);
      return true;
    } catch (e) {
      return false;
    }
  }

  Stream<QuerySnapshot> getStreampedidos() {
    return _firestore.collection("pedidos").snapshots();
  }
}
