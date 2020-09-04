import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:infoTech/features/domain/entities/pedido.dart';

class PedidoModel extends Pedido {
  PedidoModel(
      {@required id,
      @required clienteDocumentReferente,
      @required cliente,
      @required listaItensPedidoDocumentReferente,
      @required listaItensPedido,
      @required valorTotal,
      @required nomeCliente,
      @required documentReference})
      : super(
            id: id,
            nomeCliente: nomeCliente,
            clienteDocumentReferente: clienteDocumentReferente,
            listaItensPedidoDocumentReferente:
                listaItensPedidoDocumentReferente,
            listaItensPedido: listaItensPedido,
            cliente: cliente,
            valorTotal: valorTotal,
            documentReference: documentReference);

  factory PedidoModel.fromDocument(DocumentSnapshot snapshot) {
    return PedidoModel(
        id: snapshot.documentID,
        nomeCliente: snapshot.data["nomeCliente"],
        clienteDocumentReferente: snapshot.data["clienteDocumentReferente"],
        listaItensPedidoDocumentReferente:
            snapshot.data["listaItensPedidoDocumentReferente"],
        listaItensPedido: snapshot.data["listaItensPedido"],
        cliente: snapshot.data["cliente"],
        valorTotal: snapshot.data["valorTotal"],
        documentReference: snapshot.reference);
  }
}
