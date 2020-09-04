import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:infoTech/features/domain/entities/pedido_item.dart';

class PedidoItemModel extends PedidoItem {
  PedidoItemModel(
      {@required id,
      @required produto,
      @required quantidade,
      @required cliente,
      @required precoUnidade,
      @required desconto,
      @required documentReference})
      : super(
            id: id,
            produto: produto,
            quantidade: quantidade,
            cliente: cliente,
            precoUnidade: precoUnidade,
            desconto: desconto,
            documentReference: documentReference);

  factory PedidoItemModel.fromDocument(DocumentSnapshot snapshot) {
    return PedidoItemModel(
      id: snapshot.documentID,
      produto: snapshot.data["produto"],
      quantidade: snapshot.data["quantidade"],
      cliente: snapshot.data["cliente"],
      precoUnidade: snapshot.data["precoUnidade"],
      desconto: snapshot.data["desconto"],
      documentReference: snapshot.reference,
    );
  }
}
