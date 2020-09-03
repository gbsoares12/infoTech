import 'package:cloud_firestore/cloud_firestore.dart';

class ProdutoRepository {
  final Firestore _firestore = Firestore.instance;

  static ProdutoRepository _instance;

  factory ProdutoRepository() {
    _instance ??= ProdutoRepository._internalConstructor();
    return _instance;
  }
  ProdutoRepository._internalConstructor();

  Future<bool> cadastrarProduto(Map<String, dynamic> mapProduto) async {
    DocumentReference produtoDocumentReference =
        await _firestore.collection("produtos").add(mapProduto);

    if (produtoDocumentReference != null) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> deletarProduto(
      DocumentReference produtoDocumentReference) async {
    try {
      await produtoDocumentReference.delete();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> editarProduto(Map<String, dynamic> mapProdutoEditado,
      DocumentReference produtoDocumentReferente) async {
    try {
      await produtoDocumentReferente.updateData(mapProdutoEditado);
      return true;
    } catch (e) {
      return false;
    }
  }

  Stream<QuerySnapshot> getStreamProdutos() {
    return _firestore.collection("produtos").orderBy("descricao").snapshots();
  }
}
