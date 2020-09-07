import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:infoTech/features/domain/entities/produto.dart';

class ProdutoModel extends Produto {
  ProdutoModel(
      {@required id,
      @required descricao,
      @required fabricante,
      @required preco,
      @required documentReference})
      : super(
            id: id,
            descricao: descricao,
            fabricante: fabricante,
            preco: preco,
            documentReference: documentReference);

  factory ProdutoModel.fromDocument(DocumentSnapshot snapshot) {
    return ProdutoModel(
      id: snapshot.documentID,
      descricao: snapshot.data["descricao"],
      fabricante: snapshot.data["fabricante"],
      preco: snapshot.data["preco"],
      documentReference: snapshot.reference,
    );
  }
}
