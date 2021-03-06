import 'package:flutter/material.dart';
import 'package:infoTech/features/apresentation/gerenciamento_pedido/manter_pedido/widgets/pedido_list_view.dart';

class ListagemPedidoScreen extends StatefulWidget {
  @override
  _ListagemPedidoScreenState createState() => _ListagemPedidoScreenState();
}

class _ListagemPedidoScreenState extends State<ListagemPedidoScreen> {
  final ScrollController _scrollController = ScrollController();
  final ScrollController _listaProdutosScrollController = ScrollController();
  final TextEditingController fabricanteProdutoController =
      TextEditingController();
  final TextEditingController descricaoProdutoController =
      TextEditingController();
  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Material(
        child: Scaffold(
      body: Scrollbar(
        controller: _scrollController,
        child: SingleChildScrollView(
          controller: _scrollController,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 100,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: screenSize.height * 1,
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
                                  "Listagem dos pedidos",
                                  style: TextStyle(
                                      color: Colors.black54,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 80,
                        ),
                        Expanded(
                          child: PedidosListView(
                            scrollController: _listaProdutosScrollController,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
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
}
