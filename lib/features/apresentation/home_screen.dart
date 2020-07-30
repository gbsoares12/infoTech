import 'package:flutter/material.dart';
import 'package:infoTech/features/apresentation/cadastro_cliente/cadastro_cliente._screen.dart';
import 'package:infoTech/features/apresentation/gerenciamento_produto/cadastro_produto/cadastro_produto_screen.dart';
import 'package:infoTech/features/apresentation/gerenciamento_produto/manter_produto/listagem_produto_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  PageController _scrollController = PageController();
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
          appBar: AppBar(
            title: Text(
              "InfoTech",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            centerTitle: true,
          ),
          drawer: Drawer(
            elevation: 1,
            child: Column(
              children: <Widget>[
                DrawerHeader(
                  child: Text('Menu de ações'),
                  decoration: BoxDecoration(),
                ),
                ListTile(
                  leading: Text("Home"),
                  onTap: () {
                    _scrollController.animateToPage(0,
                        duration: Duration(milliseconds: 500),
                        curve: Curves.linear);
                  },
                ),
                ExpansionTile(
                  title: Text("Gerênciamento de produtos"),
                  children: [
                    ListTile(
                      title: Text("Cadastrar produto"),
                      trailing: Icon(Icons.add),
                      onTap: () {
                        _scrollController.animateToPage(1,
                            duration: Duration(milliseconds: 500),
                            curve: Curves.linear);
                      },
                    ),
                    ListTile(
                      title: Text("Listagem dos produtos"),
                      trailing: Icon(Icons.format_list_numbered),
                      onTap: () {
                        _scrollController.animateToPage(2,
                            duration: Duration(milliseconds: 500),
                            curve: Curves.linear);
                      },
                    )
                  ],
                ),
                ExpansionTile(
                  title: Text("Gerênciamento de clientes"),
                  children: [
                    ListTile(
                      title: Text("Cadastar cliente"),
                      trailing: Icon(Icons.person_add),
                      onTap: () {
                        _scrollController.animateToPage(3,
                            duration: Duration(milliseconds: 500),
                            curve: Curves.linear);
                      },
                    )
                  ],
                ),
              ],
            ),
          ),
          body: PageView(
            controller: _scrollController,
            physics: NeverScrollableScrollPhysics(),
            children: [
              ListagemProdutoScreen(),
              CadastroProduto(),
              CadastroCliente(),
              Container(),
            ],
          )),
    );
  }
}
