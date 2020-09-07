import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:infoTech/features/apresentation/gerenciamento_produto/cadastro_produto/widgets/formulario_criacao_produto_view.dart';
import 'package:infoTech/features/data/repository/produto_repository.dart';

class ProdutosListView extends StatelessWidget {
  final ProdutoRepository pr = ProdutoRepository();
  final ScrollController scrollController;
  final TextEditingController fabricanteProdutoController;
  final TextEditingController descricaoProdutoController;
  final TextEditingController precoProdutoController;

  final bool isCriacaoPedido;
  ProdutosListView(
      {Key key,
      @required this.scrollController,
      @required this.descricaoProdutoController,
      @required this.fabricanteProdutoController,
      @required this.precoProdutoController,
      this.isCriacaoPedido = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;

    return StreamBuilder<QuerySnapshot>(
        stream: pr.getStreamProdutos(),
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
              height: screenSize.height * 0.6,
              width: screenSize.height * 0.9,
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
                            isThreeLine: true,
                            title: Text(snapshot
                                .data.documents[index].data["descricao"]),
                            subtitle: Text(snapshot
                                    .data.documents[index].data["fabricante"] +
                                "\nR\$ " +
                                snapshot.data.documents[index].data["preco"]),

                            //"Preco"),
                            //snapshot.data.documents[index].data["preco"]),
                            trailing: this.isCriacaoPedido
                                ? Container()
                                : Container(
                                    width: 100,
                                    height: 50,
                                    child: Row(
                                      children: [
                                        IconButton(
                                            icon: Icon(Icons.delete),
                                            onPressed: () async {
                                              var response = pr.deletarProduto(
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
                                                  snapshot.data.documents[index]
                                                      .data["descricao"],
                                                  snapshot.data.documents[index]
                                                      .data["fabricante"],
                                                  snapshot.data.documents[index]
                                                      .data["preco"]);
                                            }),
                                      ],
                                    ),
                                  ),
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
          msg: "Produto ${editar ? 'alterado' : 'deletado'} com sucesso!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 3,
          webBgColor: "linear-gradient(to right, #4CAF50, #4CAF50)",
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0);
    } else {
      Fluttertoast.showToast(
          msg: "Erro ao ${editar ? 'alterar' : 'deletar'} o produto",
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
    String descricao,
    String fabricante,
    double preco,
  ) {
    this.descricaoProdutoController.text = descricao;
    this.fabricanteProdutoController.text = fabricante;
    this.precoProdutoController.text = preco.toString();
    AwesomeDialog(
      context: context,
      animType: AnimType.TOPSLIDE,
      width: screenSize.width * 0.7,
      dialogType: DialogType.NO_HEADER,
      body: Center(
        child: Column(
          children: [
            Text(
              'Alteração do produto.',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            FormularioCriacaoProdutoView(
              descricaoProdutoController: descricaoProdutoController,
              fabricanteProdutoController: fabricanteProdutoController,
              precoProdutoController: precoProdutoController,
            ),
          ],
        ),
      ),
      btnOkOnPress: () async {
        var resposta = await pr.editarProduto({
          "descricao": this.descricaoProdutoController.text,
          "fabricante": this.fabricanteProdutoController.text,
          "preco": this.precoProdutoController.text,
        }, produtoDocumentReference);
        notificacaoDaOperacao(resposta, true);
      },
      btnCancelOnPress: () {},
      btnCancelText: "Cancelar",
      btnOkText: "Alterar",
    )..show();
  }
}
