import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:infoTech/features/data/models/pedido_item_model.dart';
import 'package:infoTech/features/data/models/pedido_model.dart';
import 'package:infoTech/features/data/models/produto_model.dart';
import 'package:infoTech/features/data/repository/pedido_repository.dart';
import 'package:infoTech/features/data/repository/produto_repository.dart';
import 'package:infoTech/features/domain/entities/pedido.dart';
import 'package:infoTech/features/domain/entities/pedido_item.dart';
import 'package:infoTech/features/domain/entities/produto.dart';

class PedidosListView extends StatefulWidget {
  final ScrollController scrollController;

  const PedidosListView({Key key, @required this.scrollController})
      : super(key: key);
  @override
  _PedidosListViewState createState() => _PedidosListViewState();
}

class _PedidosListViewState extends State<PedidosListView> {
  final PedidoRepository pr = PedidoRepository();
  final ProdutoRepository prodr = ProdutoRepository();
  final TextEditingController quantidadeProdutoTextEditingController =
      TextEditingController();
  final TextEditingController precoProdutoTextEditingController =
      TextEditingController();
  final TextEditingController descontoProdutoTextEditingController =
      TextEditingController();
  Produto produtoSelecionado;

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;

    return StreamBuilder<QuerySnapshot>(
        stream: pr.getStreamPedidos(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text("Carregando..."),
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
                controller: this.widget.scrollController,
                child: ListView.builder(
                    controller: this.widget.scrollController,
                    scrollDirection: Axis.vertical,
                    itemCount: snapshot.data.documents.length,
                    itemBuilder: (_, index) {
                      return Container(
                        height: 100,
                        width: 150,
                        child: Card(
                          child: ListTile(
                            onTap: () {
                              abrirModalExibirInfos(
                                  context,
                                  screenSize,
                                  snapshot.data.documents[index].reference,
                                  PedidoModel.fromDocument(
                                      snapshot.data.documents[index]));
                            },
                            title: Text(snapshot
                                .data.documents[index].data["nomeCliente"]),
                            subtitle: Text(
                                "Valor total: ${snapshot.data.documents[index].data["valorTotal"].toString()}"),
                            trailing: Container(
                              width: 100,
                              height: 50,
                              child: Row(
                                children: [
                                  IconButton(
                                      icon: Icon(Icons.delete),
                                      onPressed: () async {
                                        var response = pr.deletarPedido(snapshot
                                            .data.documents[index].reference);

                                        this.notificacaoDaOperacao(
                                            await response, false);
                                      }),
                                  IconButton(
                                      icon: Icon(Icons.edit),
                                      onPressed: () {
                                        abrirModalEditar(
                                          context,
                                          screenSize,
                                          snapshot
                                              .data.documents[index].reference,
                                          PedidoModel.fromDocument(
                                              snapshot.data.documents[index]),
                                        );
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
          msg: "Pedido ${editar ? 'alterado' : 'deletado'} com sucesso!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 3,
          webBgColor: "linear-gradient(to right, #4CAF50, #4CAF50)",
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0);
    } else {
      Fluttertoast.showToast(
          msg: "Erro ao ${editar ? 'alterar' : 'deletar'} o pedido",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 3,
          webBgColor: "linear-gradient(to right, #C62828, #C62828)",
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  void abrirModalExibirInfos(
    BuildContext context,
    Size screenSize,
    DocumentReference pedidoDocumentReference,
    Pedido pedido,
  ) {
    AwesomeDialog(
      context: context,
      animType: AnimType.TOPSLIDE,
      width: screenSize.width * 0.7,
      dialogType: DialogType.NO_HEADER,
      body: Center(
        child: Column(
          children: [
            Text(
              'Informações do pedido.',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            Text("Cliente: ${pedido.nomeCliente}"),
            Text("Valor total: ${pedido.valorTotal.toString()}"),
            FutureBuilder<QuerySnapshot>(
                future: pr.getStreamItensPedidos(pedidoDocumentReference).first,
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasData) {
                    List<PedidoItem> listaItensPedido = List<PedidoItem>();

                    QuerySnapshot query = snapshot.data;
                    for (var itemPedidoSnapshot in query.documents) {
                      listaItensPedido.add(
                          PedidoItemModel.fromDocument(itemPedidoSnapshot));
                    }
                    return Container(
                      width: MediaQuery.of(context).size.width * 0.3,
                      height: MediaQuery.of(context).size.height * 0.3,
                      child: ListView.builder(
                          itemCount: listaItensPedido.length,
                          itemBuilder: (context, index) {
                            int quantidade =
                                listaItensPedido[index].quantidade ?? 0;
                            double precoUnidade =
                                listaItensPedido[index].precoUnidade ?? 0;
                            double desconto =
                                listaItensPedido[index].desconto ?? 0;
                            return ListTile(
                              title: Text(
                                  listaItensPedido[index].descricaoProduto),
                              subtitle: Text(
                                  "Quantidade: ${quantidade.toString()} | Preço unid: ${precoUnidade.toString()} | Desconto: ${desconto.toString()}"),
                            );
                          }),
                    );
                  } else {
                    return Column(
                      children: [
                        SizedBox(
                          child: CircularProgressIndicator(),
                          width: 60,
                          height: 60,
                        ),
                        const Padding(
                          padding: EdgeInsets.only(top: 16),
                          child: Text('Carregando...'),
                        ),
                      ],
                    );
                  }
                }),
          ],
        ),
      ),
      btnOkOnPress: () {},
      btnOkText: "Voltar",
    )..show();
  }

  void abrirModalEditar(
    BuildContext context,
    Size screenSize,
    DocumentReference pedidoDocumentReference,
    Pedido pedido,
  ) {
    double valorTotal = pedido.valorTotal;
    AwesomeDialog(
      context: context,
      animType: AnimType.TOPSLIDE,
      width: screenSize.width * 0.7,
      dialogType: DialogType.NO_HEADER,
      body: Center(
        child: Column(
          children: [
            Text(
              'Editar pedido.',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            Text("Cliente: ${pedido.nomeCliente}"),
            Text("Valor total: ${valorTotal.toString()}"),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Adicionar produto"),
                  SizedBox(
                    width: 5,
                  ),
                  IconButton(
                      icon: Icon(
                        Icons.add_box,
                        color: Colors.green,
                      ),
                      onPressed: () {
                        abrirModalAdicionarProduto(context, screenSize, pedido);
                      }),
                ],
              ),
            ),
            StreamBuilder<QuerySnapshot>(
                stream: pr.getStreamItensPedidos(pedidoDocumentReference),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasData) {
                    List<PedidoItem> listaItensPedido = List<PedidoItem>();

                    QuerySnapshot query = snapshot.data;
                    for (var itemPedidoSnapshot in query.documents) {
                      listaItensPedido.add(
                          PedidoItemModel.fromDocument(itemPedidoSnapshot));
                    }
                    return Container(
                      width: MediaQuery.of(context).size.width * 0.3,
                      height: MediaQuery.of(context).size.height * 0.3,
                      child: ListView.builder(
                          itemCount: listaItensPedido.length,
                          itemBuilder: (context, index) {
                            int quantidade =
                                listaItensPedido[index].quantidade ?? 0;
                            double precoUnidade =
                                listaItensPedido[index].precoUnidade ?? 0;
                            double desconto =
                                listaItensPedido[index].desconto ?? 0;
                            return ListTile(
                              title: Text(
                                  listaItensPedido[index].descricaoProduto),
                              subtitle: Text(
                                  "Quantidade: ${quantidade.toString()} | Preço unid: ${precoUnidade.toString()} | Desconto: ${desconto.toString()}"),
                              leading: IconButton(
                                  icon: Icon(Icons.delete),
                                  onPressed: () async {
                                    valorTotal -= (quantidade * precoUnidade) -
                                        desconto * quantidade;
                                    var response = pr.deletarItemPedido(
                                        pedidoDocumentReference,
                                        snapshot
                                            .data.documents[index].reference,
                                        precoUnidade);
                                    this.notificacaoDaOperacao(
                                        await response, false);
                                  }),
                            );
                          }),
                    );
                  } else {
                    return Column(
                      children: [
                        SizedBox(
                          child: CircularProgressIndicator(),
                          width: 60,
                          height: 60,
                        ),
                        const Padding(
                          padding: EdgeInsets.only(top: 16),
                          child: Text('Carregando...'),
                        ),
                      ],
                    );
                  }
                }),
          ],
        ),
      ),
      btnOkOnPress: () {},
      btnOkText: "Voltar",
    )..show();
  }

  void abrirModalAdicionarProduto(
      BuildContext context, Size screenSize, Pedido pedido) {
    AwesomeDialog(
        context: context,
        animType: AnimType.TOPSLIDE,
        width: screenSize.width * 0.7,
        dialogType: DialogType.NO_HEADER,
        body: Center(
          child: Column(
            children: [
              Text(
                'Adicionar produto.',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
              Text("Cliente: ${pedido.nomeCliente}"),
              buildContainerAdicionarProduto(),
            ],
          ),
        ),
        btnOkOnPress: () {
          pr.editarPedido(
              pedido.documentReference,
              PedidoItem(
                id: null,
                produto: this.produtoSelecionado,
                cliente: pedido.cliente,
                quantidade:
                    int.parse(this.quantidadeProdutoTextEditingController.text),
                precoUnidade:
                    double.parse(this.precoProdutoTextEditingController.text),
                desconto: double.parse(
                    this.descontoProdutoTextEditingController.text),
                descricaoProduto: this.produtoSelecionado.descricao,
                documentReference: null,
              ));
        },
        btnOkText: "Adicionar",
        btnCancelOnPress: () {},
        btnCancelText: "Cancelar")
      ..show();
  }

  Widget selectProdutos() {
    return Container(
      child: Form(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Text(
                    "Selecione um produto:",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                  ),
                ),
                FutureBuilder<QuerySnapshot>(
                    future: prodr.getStreamProdutos().first,
                    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasData) {
                        List<Produto> listaProdutos = List<Produto>();
                        listaProdutos.add(Produto(
                            id: null,
                            descricao: "Selecione um produto",
                            fabricante: null,
                            preco: null,
                            documentReference: null));
                        QuerySnapshot query = snapshot.data;
                        for (var produtoSnapshot in query.documents) {
                          listaProdutos
                              .add(ProdutoModel.fromDocument(produtoSnapshot));
                        }

                        return Container(
                          width: MediaQuery.of(context).size.width * 0.2,
                          child: DropdownButtonFormField(
                              value: listaProdutos.first,
                              items: listaProdutos
                                  .map<DropdownMenuItem<Produto>>(
                                      (Produto value) {
                                return DropdownMenuItem<Produto>(
                                  value: value,
                                  child: Text(value.descricao),
                                );
                              }).toList(),
                              onChanged: (produto) {
                                produtoSelecionado = produto;
                              }),
                        );
                      } else {
                        return Column(
                          children: [
                            SizedBox(
                              child: CircularProgressIndicator(),
                              width: 60,
                              height: 60,
                            ),
                            const Padding(
                              padding: EdgeInsets.only(top: 16),
                              child: Text('Carregando...'),
                            ),
                          ],
                        );
                      }
                    }),
              ],
            ),
          ),
        ],
      )),
    );
  }

  Widget buildContainerAdicionarProduto() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
                padding: const EdgeInsets.only(top: 30.0),
                child: selectProdutos()),
            Padding(
              padding: EdgeInsets.only(left: 20),
              child: Container(
                width: MediaQuery.of(context).size.width * 0.08,
                child: TextFormField(
                  controller: quantidadeProdutoTextEditingController,
                  decoration: InputDecoration(
                    labelText: "Quantidade",
                  ),
                ),
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(top: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 20),
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.1,
                  child: TextFormField(
                    controller: precoProdutoTextEditingController,
                    decoration: InputDecoration(
                      labelText: "Preço unidade",
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 20),
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.08,
                  child: TextFormField(
                    controller: descontoProdutoTextEditingController,
                    decoration: InputDecoration(
                      labelText: "Desconto",
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
