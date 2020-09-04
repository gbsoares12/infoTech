import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:infoTech/features/apresentation/gerenciamento_cliente/cadastro_cliente/widgets/formulario_criacao_cliente_view.dart';
import 'package:infoTech/features/data/repository/cliente_repository.dart';

class ClientesListView extends StatelessWidget {
  final ClienteRepository cr = ClienteRepository();
  final ScrollController scrollController;
  final TextEditingController nomeClienteController;
  final TextEditingController cpfClienteController;
  final TextEditingController logradouroClienteController;
  final TextEditingController numeroClienteController;
  final TextEditingController bairroClienteController;
  final TextEditingController cidadeClienteController;
  final TextEditingController cepClienteController;
  final TextEditingController estadoClienteController;
  final bool isCriacaoPedido;
  final double height;
  final double width;

  ClientesListView({
    Key key,
    @required this.scrollController,
    @required this.nomeClienteController,
    @required this.cpfClienteController,
    @required this.logradouroClienteController,
    @required this.numeroClienteController,
    @required this.bairroClienteController,
    @required this.cidadeClienteController,
    @required this.cepClienteController,
    @required this.estadoClienteController,
    @required this.height,
    @required this.width,
    this.isCriacaoPedido = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;

    return StreamBuilder<QuerySnapshot>(
        stream: cr.getStreamClientes(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text("Loading..."),
                  SizedBox(
                    height: 50.0,
                  ),
                  CircularProgressIndicator()
                ],
              ),
            );
          } else {
            return Container(
              height: height,
              width: width,
              child: Scrollbar(
                controller: scrollController,
                child: ListView.builder(
                    controller: scrollController,
                    scrollDirection: Axis.vertical,
                    itemCount: snapshot.data.documents.length,
                    itemBuilder: (_, index) {
                      return Container(
                        height: 100,
                        width: 150,
                        child: Card(
                          child: ListTile(
                            title: Text(
                                snapshot.data.documents[index].data["nome"]),
                            subtitle: Text(
                                snapshot.data.documents[index].data["cpf"]),
                            trailing: this.isCriacaoPedido
                                ? null
                                : Container(
                                    width: 100,
                                    height: 50,
                                    child: Row(
                                      children: [
                                        IconButton(
                                            icon: Icon(Icons.delete),
                                            onPressed: () async {
                                              var response = cr.deletarCliente(
                                                  snapshot.data.documents[index]
                                                      .reference);

                                              this.notificacaoDaOperacao(
                                                  await response, false);
                                            }),
                                        IconButton(
                                            icon: Icon(Icons.edit),
                                            onPressed: () {
                                              abrirModalEditar(
                                                  context,
                                                  screenSize,
                                                  snapshot.data.documents[index]
                                                      .reference,
                                                  snapshot
                                                      .data.documents[index]);
                                            }),
                                      ],
                                    ),
                                  ),
                            onTap: () {
                              if (snapshot.hasData) {
                                abrirModalVisualizarDados(context, screenSize,
                                    snapshot.data.documents[index]);
                              }
                            },
                          ),
                        ),
                      );
                    }),
              ),
            );
          }
        });
  }

  void notificacaoDaOperacao(bool response, bool editar) {
    if (response) {
      Fluttertoast.showToast(
          msg: "Cliente ${editar ? 'alterado' : 'deletado'} com sucesso!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 3,
          webBgColor: "linear-gradient(to right, #4CAF50, #4CAF50)",
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0);
    } else {
      Fluttertoast.showToast(
          msg: "Erro ao ${editar ? 'alterar' : 'deletar'} o Cliente",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 3,
          webBgColor: "linear-gradient(to right, #C62828, #C62828)",
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  void abrirModalEditar(
      BuildContext context,
      Size screenSize,
      DocumentReference produtoDocumentReference,
      DocumentSnapshot clienteSnapshot) {
    this.nomeClienteController.text = clienteSnapshot.data['nome'];
    this.cpfClienteController.text = clienteSnapshot.data['cpf'];
    this.logradouroClienteController.text = clienteSnapshot.data['logradouro'];
    this.numeroClienteController.text = clienteSnapshot.data['numero'];
    this.bairroClienteController.text = clienteSnapshot.data['bairro'];
    this.cidadeClienteController.text = clienteSnapshot.data['cidade'];
    this.cepClienteController.text = clienteSnapshot.data['cep'];
    this.estadoClienteController.text = clienteSnapshot.data['estado'];

    AwesomeDialog(
      context: context,
      animType: AnimType.TOPSLIDE,
      width: screenSize.width * 0.7,
      dialogType: DialogType.NO_HEADER,
      body: Center(
        child: Column(
          children: [
            Text(
              'Alteração do cliente.',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            FormularioCriacaoCliente(
                nomeClienteController: nomeClienteController,
                cpfClienteController: cpfClienteController,
                logradouroClienteController: logradouroClienteController,
                numeroClienteController: numeroClienteController,
                bairroClienteController: bairroClienteController,
                cidadeClienteController: cidadeClienteController,
                cepClienteController: cepClienteController,
                estadoClienteController: estadoClienteController)
          ],
        ),
      ),
      btnOkOnPress: () async {
        var resposta = await cr.editarCliente({
          "nome": this.nomeClienteController.text,
          "cpf": this.cpfClienteController.text,
          "logradouro": this.logradouroClienteController.text,
          "numero": this.numeroClienteController.text,
          "bairro": this.bairroClienteController.text,
          "cidade": this.cidadeClienteController.text,
          "cep": this.cepClienteController.text,
          "estado": this.estadoClienteController.text,
        }, clienteSnapshot.reference);

        notificacaoDaOperacao(resposta, true);
      },
      btnCancelOnPress: () {},
      btnCancelText: "Cancelar",
      btnOkText: "Alterar",
    )..show();
  }

  void abrirModalVisualizarDados(
      BuildContext context, Size screenSize, DocumentSnapshot clienteSnapshot) {
    this.nomeClienteController.text = clienteSnapshot.data['nome'];
    this.cpfClienteController.text = clienteSnapshot.data['cpf'];
    this.logradouroClienteController.text = clienteSnapshot.data['logradouro'];
    this.numeroClienteController.text = clienteSnapshot.data['numero'];
    this.bairroClienteController.text = clienteSnapshot.data['bairro'];
    this.cidadeClienteController.text = clienteSnapshot.data['cidade'];
    this.cepClienteController.text = clienteSnapshot.data['cep'];
    this.estadoClienteController.text = clienteSnapshot.data['estado'];

    AwesomeDialog(
        context: context,
        animType: AnimType.TOPSLIDE,
        width: screenSize.width * 0.7,
        dialogType: DialogType.NO_HEADER,
        body: Center(
          child: Column(
            children: [
              Text(
                'Informações do Cliente.',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
              FormularioCriacaoCliente(
                  readOnly: true,
                  nomeClienteController: nomeClienteController,
                  cpfClienteController: cpfClienteController,
                  logradouroClienteController: logradouroClienteController,
                  numeroClienteController: numeroClienteController,
                  bairroClienteController: bairroClienteController,
                  cidadeClienteController: cidadeClienteController,
                  cepClienteController: cepClienteController,
                  estadoClienteController: estadoClienteController)
            ],
          ),
        ),
        btnOkOnPress: () async {},
        btnOkText: "Voltar")
      ..show();
  }
}
