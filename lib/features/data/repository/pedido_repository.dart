import 'package:cloud_firestore/cloud_firestore.dart';

class PedidoRepository {
  final Firestore _firestore = Firestore.instance;

  static PedidoRepository _instance;

  factory PedidoRepository() {
    _instance ??= PedidoRepository._internalConstructor();
    return _instance;
  }
  PedidoRepository._internalConstructor();

  Future<bool> cadastrarPedido(Map<String, dynamic> mapPedido) async {
    DocumentReference pedidoDocumentReference =
        await _firestore.collection("pedidos").add(mapPedido);

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
