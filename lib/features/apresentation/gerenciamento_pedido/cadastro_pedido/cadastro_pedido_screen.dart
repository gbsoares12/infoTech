import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:infoTech/features/data/models/cliente_model.dart';
import 'package:infoTech/features/data/models/produto_model.dart';
import 'package:infoTech/features/data/repository/cliente_repository.dart';
import 'package:infoTech/features/data/repository/pedido_repository.dart';
import 'package:infoTech/features/data/repository/produto_repository.dart';
import 'package:infoTech/features/domain/entities/cliente.dart';
import 'package:infoTech/features/domain/entities/pedido_item.dart';
import 'package:infoTech/features/domain/entities/produto.dart';

class CadastroPedido extends StatefulWidget {
  @override
  _CadastroPedidoState createState() => _CadastroPedidoState();
}

class _CadastroPedidoState extends State<CadastroPedido> {
  final Map<String, dynamic> pedidoJson = Map<String, dynamic>();

  final ScrollController _scrollController = ScrollController();
  final ScrollController listaClienteScrollController = ScrollController();
  final ScrollController listaProdutosScrollController = ScrollController();
  final TextEditingController quantidadeProdutoTextEditingController =
      TextEditingController();
  final TextEditingController precoProdutoTextEditingController =
      TextEditingController();
  final TextEditingController descontoProdutoTextEditingController =
      TextEditingController();
  final List<PedidoItem> listaPedidoItens = List<PedidoItem>();
  final PedidoRepository pr = PedidoRepository();
  final ClienteRepository clir = ClienteRepository();
  final ProdutoRepository prodr = ProdutoRepository();
  int indexClienteSelecionado;
  Cliente clienteSelecionado;
  Produto produtoSelecionado;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;

    return Material(
        child: Scaffold(
      body: Scrollbar(
        controller: _scrollController,
        isAlwaysShown: true,
        child: SingleChildScrollView(
          controller: _scrollController,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              SizedBox(
                height: 100,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: screenSize.width * 0.5,
                    decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey,
                            offset: Offset(0.0, 1.0), //(x,y)
                            blurRadius: 6.0,
                          ),
                        ],
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 30.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                child: Text(
                                  "Cadastro de Pedido",
                                  style: TextStyle(
                                      color: Theme.of(context).primaryColor,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          children: [
                            Container(
                                padding: const EdgeInsets.only(top: 100.0),
                                child: _isLoading
                                    ? Center(
                                        child: CircularProgressIndicator(),
                                      )
                                    : selectClientes()),
                            this.clienteSelecionado != null
                                ? Text(
                                    "Cliente selecionado: ${this.clienteSelecionado.nome}",
                                    style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w500),
                                  )
                                : Container(),
                            buildContainerAdicionarProduto(),
                            buildListaProdutosCadastrados(),
                            Container(
                              padding: const EdgeInsets.only(top: 60.0),
                              child: RaisedButton(
                                color: Theme.of(context).primaryColor,
                                onPressed: () async {
                                  await _cadastrarPedido();
                                },
                                child: this._isLoading
                                    ? CupertinoActivityIndicator()
                                    : Text(
                                        "Finalizar Pedido",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      ),
                                elevation: 1,
                              ),
                            ),
                            SizedBox(
                              height: 50,
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 100,
              ),
            ],
          ),
        ),
      ),
    ));
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
                padding: const EdgeInsets.only(top: 100.0),
                child: _isLoading
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : selectProdutos()),
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
        Container(
          padding: const EdgeInsets.only(top: 50.0, bottom: 50),
          child: RaisedButton(
            color: Theme.of(context).primaryColor,
            onPressed: () async {
              if (this.clienteSelecionado != null &&
                  this.produtoSelecionado != null) {
                _cadastrarItemNoPedido();
              }
            },
            child: Text(
              "Adicionar Produto",
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            elevation: 1,
          ),
        )
      ],
    );
  }

  Widget buildListaProdutosCadastrados() {
    return Container(
      color: Colors.white60,
      height: MediaQuery.of(context).size.height * 0.3,
      child: ListView.builder(
          itemCount: this.listaPedidoItens.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * 0.05),
              child: Card(
                child: ListTile(
                  title: Text(this.listaPedidoItens[index].produto.descricao),
                  subtitle: Row(
                    children: [
                      Text(
                          "Quantidade: ${this.listaPedidoItens[index].quantidade} - Cliente: ${this.listaPedidoItens[index].cliente.nome} - Preço unitário: ${this.listaPedidoItens[index].precoUnidade} - Desconto: ${this.listaPedidoItens[index].desconto}"),
                    ],
                  ),
                ),
              ),
            );
          }),
    );
  }

  Widget selectClientes() {
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
                    "Selecione um cliente:",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                  ),
                ),
                FutureBuilder<QuerySnapshot>(
                    future: clir.getStreamClientes().first,
                    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasData) {
                        List<Cliente> listaClientes = List<Cliente>();
                        listaClientes.add(ClienteModel(
                            id: null,
                            nome: "Selecione um cliente",
                            cpf: null,
                            logradouro: null,
                            numero: null,
                            bairro: null,
                            cidade: null,
                            cep: null,
                            estado: null,
                            documentReference: null));
                        QuerySnapshot query = snapshot.data;
                        for (var clienteSnapshot in query.documents) {
                          listaClientes
                              .add(ClienteModel.fromDocument(clienteSnapshot));
                        }
                        return Container(
                          width: MediaQuery.of(context).size.width * 0.3,
                          child: DropdownButtonFormField(
                              value: this.clienteSelecionado == null
                                  ? listaClientes.first
                                  : listaClientes[indexClienteSelecionado],
                              items: listaClientes
                                  .map<DropdownMenuItem<Cliente>>(
                                      (Cliente value) {
                                return DropdownMenuItem<Cliente>(
                                  value: value,
                                  child: Text(value.nome),
                                );
                              }).toList(),
                              onChanged: this.clienteSelecionado == null
                                  ? (cliente) {
                                      indexClienteSelecionado =
                                          listaClientes.indexOf(cliente);
                                      this.clienteSelecionado = cliente;
                                    }
                                  : null),
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
                                this.produtoSelecionado = produto;
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

  void _cadastrarItemNoPedido() {
    setState(() {
      this.listaPedidoItens.add(PedidoItem(
            id: null,
            produto: this.produtoSelecionado,
            quantidade:
                int.parse(this.quantidadeProdutoTextEditingController.text),
            precoUnidade:
                double.parse(this.precoProdutoTextEditingController.text),
            desconto:
                double.parse(this.descontoProdutoTextEditingController.text),
            cliente: this.clienteSelecionado,
            descricaoProduto: this.produtoSelecionado.descricao,
            documentReference: null,
          ));
      this.quantidadeProdutoTextEditingController.clear();
      this.precoProdutoTextEditingController.clear();
      this.descontoProdutoTextEditingController.clear();
    });
  }

  Future<void> _cadastrarPedido() async {
    setState(() {
      _isLoading = true;
    });
    var response =
        await pr.cadastrarPedido(this.clienteSelecionado, listaPedidoItens);
    setState(() {
      _isLoading = true;
      if (response) {
        this._isLoading = false;
        Fluttertoast.showToast(
            msg: "Pedido cadastrado com sucesso!",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 3,
            webBgColor: "linear-gradient(to right, #4CAF50, #4CAF50)",
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 16.0);
      } else {
        this._isLoading = false;
        Fluttertoast.showToast(
            msg: "Erro ao cadastrar o pedido",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 3,
            webBgColor: "linear-gradient(to right, #C62828, #C62828)",
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    });

    limparCampos();
  }

  void limparCampos() {
    setState(() {
      this.clienteSelecionado = null;
      this.listaPedidoItens.clear();
      this.quantidadeProdutoTextEditingController.clear();
      this.precoProdutoTextEditingController.clear();
      this.descontoProdutoTextEditingController.clear();
    });
  }
}
