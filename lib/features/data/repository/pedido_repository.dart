import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:infoTech/features/data/models/pedido_model.dart';
import 'package:infoTech/features/domain/entities/cliente.dart';
import 'package:infoTech/features/domain/entities/pedido.dart';
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
      totalValorPedido += (itemPedido.quantidade * itemPedido.precoUnidade) -
          itemPedido.desconto * itemPedido.quantidade;
    });

    DocumentReference pedidoDocumentReference =
        await _firestore.collection("pedidos").add({
      "nomeCliente": cliente.nome,
      "cliente": cliente.documentReference,
      "valorTotal": totalValorPedido
    });

    for (var itemPedido in listaItensPedido) {
      pedidoDocumentReference.collection("ItensPedido").add({
        "produto": itemPedido.produto.documentReference,
        "quantidade": itemPedido.quantidade,
        "precoUnidade": itemPedido.precoUnidade,
        "desconto": itemPedido.desconto,
        "descricaoProduto": itemPedido.descricaoProduto,
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

  Future<bool> deletarItemPedido(DocumentReference pedidoDocumentReference,
      DocumentReference itemPedidoDocumentReference, double valor) async {
    try {
      double valorAlterado =
          PedidoModel.fromDocument(await pedidoDocumentReference.get())
              .valorTotal;
      valorAlterado -= valor;
      pedidoDocumentReference.updateData({"valorTotal": valorAlterado});
      await itemPedidoDocumentReference.delete();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> editarPedido(
      DocumentReference pedidoDR, PedidoItem itemPedido) async {
    try {
      double totalValorPedido = 0.0;
      double valorTotalDoPedidoNoBanco =
          PedidoModel.fromDocument(await pedidoDR.get()).valorTotal;

      totalValorPedido += (itemPedido.quantidade * itemPedido.precoUnidade) -
          itemPedido.desconto * itemPedido.quantidade;

      pedidoDR.updateData(
          {"valorTotal": totalValorPedido + valorTotalDoPedidoNoBanco});

      pedidoDR.collection("ItensPedido").add({
        "produto": itemPedido.produto.documentReference,
        "quantidade": itemPedido.quantidade,
        "precoUnidade": itemPedido.precoUnidade,
        "desconto": itemPedido.desconto,
        "descricaoProduto": itemPedido.descricaoProduto,
      });

      return true;
    } catch (e) {
      return false;
    }
  }

  Stream<QuerySnapshot> getStreamPedidos() {
    return _firestore.collection("pedidos").snapshots();
  }

  Stream<QuerySnapshot> getStreamItensPedidos(
      DocumentReference pedidoReference) {
    return pedidoReference.collection("ItensPedido").snapshots();
  }
}
