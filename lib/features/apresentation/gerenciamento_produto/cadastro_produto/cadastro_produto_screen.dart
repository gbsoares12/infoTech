import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:infoTech/features/apresentation/gerenciamento_produto/cadastro_produto/widgets/formulario_criacao_produto_view.dart';
import 'package:infoTech/features/data/repository/produto_repository.dart';

class CadastroProduto extends StatefulWidget {
  @override
  _CadastroProdutoState createState() => _CadastroProdutoState();
}

class _CadastroProdutoState extends State<CadastroProduto> {
  final TextEditingController _descricaoProdutoController =
      TextEditingController();
  final TextEditingController _fabricanteProdutoController =
      TextEditingController();
  final TextEditingController _precoProdutoController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  final ProdutoRepository pr = ProdutoRepository();

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
                                  "Cadastro de produto",
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
                              : FormularioCriacaoProdutoView(
                                  descricaoProdutoController:
                                      _descricaoProdutoController,
                                  fabricanteProdutoController:
                                      _fabricanteProdutoController,
                                  precoProdutoController:
                                      _precoProdutoController,
                                ),
                        ),
                        Container(
                          padding: const EdgeInsets.only(top: 120.0),
                          child: RaisedButton(
                            color: Theme.of(context).primaryColor,
                            onPressed: () async {
                              await _cadastrarProduto();
                            },
                            child: this._isLoading
                                ? CupertinoActivityIndicator()
                                : Text(
                                    "Cadastrar produto",
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

  Future<void> _cadastrarProduto() async {
    if (this._descricaoProdutoController.text.isNotEmpty &&
        this._fabricanteProdutoController.text.isNotEmpty &&
        this._precoProdutoController.text.isNotEmpty) {
      setState(() {
        _isLoading = true;
      });
      var response = await pr.cadastrarProduto({
        "descricao": this._descricaoProdutoController.text,
        "fabricante": this._fabricanteProdutoController.text,
        "preco": double.parse(this._precoProdutoController.text),
      });
      setState(() {
        _isLoading = true;
        if (response) {
          this._isLoading = false;
          Fluttertoast.showToast(
              msg: "Produto cadastrado com sucesso!",
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
              msg: "Erro ao cadastrar o produto",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 3,
              webBgColor: "linear-gradient(to right, #C62828, #C62828)",
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0);
        }
      });

      this._descricaoProdutoController.clear();
      this._fabricanteProdutoController.clear();
      this._precoProdutoController.clear();
    } else {
      Fluttertoast.showToast(
          msg: "Preencha os campos corretamente",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 3,
          webBgColor: "linear-gradient(to right, #C62828, #C62828)",
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }
}
