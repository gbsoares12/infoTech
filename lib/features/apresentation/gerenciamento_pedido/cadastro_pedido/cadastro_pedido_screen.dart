import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:infoTech/features/apresentation/gerenciamento_pedido/cadastro_pedido/widgets/formulario_criacao_pedido.dart';
import 'package:infoTech/features/data/repository/pedido_repository.dart';

class CadastroPedido extends StatefulWidget {
  @override
  _CadastroPedidoState createState() => _CadastroPedidoState();
}

class _CadastroPedidoState extends State<CadastroPedido> {
  final Map<String, dynamic> pedidoJson = Map<String, dynamic>();

  final ScrollController _scrollController = ScrollController();

  final PedidoRepository pr = PedidoRepository();

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
                                : FormularioCriacaoPedido(
                                    pedidoJson: this.pedidoJson)),
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
