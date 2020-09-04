import 'package:cloud_firestore/cloud_firestore.dart';

class ClienteRepository {
  final Firestore _firestore = Firestore.instance;

  static ClienteRepository _instance;

  factory ClienteRepository() {
    _instance ??= ClienteRepository._internalConstructor();
    return _instance;
  }
  ClienteRepository._internalConstructor();

  Future<bool> cadastrarCliente(Map<String, dynamic> mapCliente) async {
    DocumentReference clienteDocumentReference =
        await _firestore.collection("clientes").add(mapCliente);

    if (clienteDocumentReference != null) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> deletarCliente(
      DocumentReference clienteDocumentReference) async {
    try {
      await clienteDocumentReference.delete();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> editarCliente(Map<String, dynamic> mapClienteEditado,
      DocumentReference clienteDocumentReferente) async {
    try {
      await clienteDocumentReferente.updateData(mapClienteEditado);
      return true;
    } catch (e) {
      return false;
    }
  }

  Stream<QuerySnapshot> getStreamClientes() {
    return _firestore.collection("clientes").orderBy("nome").snapshots();
  }
}
