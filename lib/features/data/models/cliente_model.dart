import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:infoTech/features/domain/entities/cliente.dart';

class ClienteModel extends Cliente {
  ClienteModel(
      {@required id,
      @required nome,
      @required cpf,
      @required logradouro,
      @required numero,
      @required bairro,
      @required cidade,
      @required cep,
      @required estado,
      @required desconto,
      @required documentReference})
      : super(
          id: id,
          nome: nome,
          cpf: cpf,
          logradouro: logradouro,
          numero: numero,
          bairro: bairro,
          cidade: cidade,
          cep: cep,
          estado: estado,
          desconto: desconto,
          documentReference: documentReference,
        );

  factory ClienteModel.fromDocument(DocumentSnapshot snapshot) {
    return ClienteModel(
      id: snapshot.documentID,
      nome: snapshot.data['nome'],
      cpf: snapshot.data['cpf'],
      logradouro: snapshot.data['logradouro'],
      numero: snapshot.data['numero'],
      bairro: snapshot.data['bairro'],
      cidade: snapshot.data['cidade'],
      cep: snapshot.data['cep'],
      estado: snapshot.data['estado'],
      desconto: snapshot.data['desconto'],
      documentReference: snapshot.reference,
    );
  }
}
