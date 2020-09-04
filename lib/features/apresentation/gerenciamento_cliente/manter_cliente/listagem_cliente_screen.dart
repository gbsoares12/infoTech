import 'package:flutter/material.dart';
import 'package:infoTech/features/apresentation/gerenciamento_cliente/manter_cliente/widgets/clientes_list_view.dart';

class ListagemClienteScreen extends StatefulWidget {
  @override
  _ListagemClienteScreenState createState() => _ListagemClienteScreenState();
}

class _ListagemClienteScreenState extends State<ListagemClienteScreen> {
  final ScrollController _scrollController = ScrollController();
  final ScrollController _listaClientesScrollController = ScrollController();

  final TextEditingController _nomeClienteController = TextEditingController();
  final TextEditingController _cpfClienteController = TextEditingController();
  final TextEditingController _logradouroClienteController =
      TextEditingController();
  final TextEditingController _numeroClienteController =
      TextEditingController();
  final TextEditingController _bairroClienteController =
      TextEditingController();
  final TextEditingController _cidadeClienteController =
      TextEditingController();
  final TextEditingController _cepClienteController = TextEditingController();
  final TextEditingController _estadoClienteController =
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
                                  "Listagem dos clientes",
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
                            child: ClientesListView(
                                scrollController:
                                    _listaClientesScrollController,
                                nomeClienteController: _nomeClienteController,
                                cpfClienteController: _cpfClienteController,
                                logradouroClienteController:
                                    _logradouroClienteController,
                                numeroClienteController:
                                    _numeroClienteController,
                                bairroClienteController:
                                    _bairroClienteController,
                                cidadeClienteController:
                                    _cidadeClienteController,
                                cepClienteController: _cepClienteController,
                                estadoClienteController:
                                    _estadoClienteController)),
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
