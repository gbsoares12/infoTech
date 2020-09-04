import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:infoTech/features/data/models/cliente_model.dart';
import 'package:infoTech/features/data/repository/cliente_repository.dart';
import 'package:infoTech/features/data/repository/pedido_repository.dart';
import 'package:infoTech/features/data/repository/produto_repository.dart';
import 'package:infoTech/features/domain/entities/cliente.dart';

class CadastroPedido extends StatefulWidget {
  @override
  _CadastroPedidoState createState() => _CadastroPedidoState();
}

class _CadastroPedidoState extends State<CadastroPedido> {
  final Map<String, dynamic> pedidoJson = Map<String, dynamic>();

  final ScrollController _scrollController = ScrollController();
  final ScrollController listaClienteScrollController = ScrollController();
  final ScrollController listaProdutosScrollController = ScrollController();

  final PedidoRepository pr = PedidoRepository();
  final ClienteRepository clir = ClienteRepository();
  final ProdutoRepository prodr = ProdutoRepository();

  List<Cliente> listaClientes = List<Cliente>();
  Cliente clienteSelecionado;
  bool _isLoading = false;

  @override
  void initState() {
    // .then((query) {
    //   List<Cliente> auxClientes = List<Cliente>();
    //   if (query.documents.isNotEmpty) {
    //     query.documents.forEach((clienteSnapshot) {
    //       auxClientes.add(ClienteModel.fromDocument(clienteSnapshot));
    //     });

    //     setState(() {
    //       listaClientes = auxClientes;
    //     });
    //   }
    // });
    super.initState();
  }

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
                    height: screenSize.height * 1.2,
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
                        Container(
                            padding: const EdgeInsets.only(top: 100.0),
                            child: _isLoading
                                ? Center(
                                    child: CircularProgressIndicator(),
                                  )
                                : selectClientes()),
                        Container(
                          padding: const EdgeInsets.only(top: 120.0),
                          child: RaisedButton(
                            color: Theme.of(context).primaryColor,
                            onPressed: () async {
                              await _cadastrarPedido();
                            },
                            child: this._isLoading
                                ? CupertinoActivityIndicator()
                                : Text(
                                    "Cadastrar Pedido",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                            elevation: 1,
                          ),
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

                        QuerySnapshot query = snapshot.data;
                        for (var clienteSnapshot in query.documents) {
                          listaClientes
                              .add(ClienteModel.fromDocument(clienteSnapshot));
                        }

                        return Container(
                          width: MediaQuery.of(context).size.width * 0.3,
                          child: DropdownButtonFormField(
                              items: listaClientes
                                  .map<DropdownMenuItem<Cliente>>(
                                      (Cliente value) {
                                return DropdownMenuItem<Cliente>(
                                  value: value,
                                  child: Text(value.nome),
                                );
                              }).toList(),
                              onChanged: (cliente) {
                                this.clienteSelecionado = cliente;
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

  Future<void> _cadastrarPedido() async {
    setState(() {
      _isLoading = true;
    });
    var response = await pr.cadastrarPedido(pedidoJson);
    setState(() {
      _isLoading = true;
      if (response) {
        this._isLoading = false;
        Fluttertoast.showToast(
            msg: "Cliente cadastrado com sucesso!",
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
            msg: "Erro ao cadastrar o cliente",
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
      this.pedidoJson.clear();
    });
  }
}
