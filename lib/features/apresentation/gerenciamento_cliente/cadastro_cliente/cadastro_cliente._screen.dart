import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:infoTech/features/apresentation/gerenciamento_cliente/cadastro_cliente/widgets/formulario_criacao_cliente_view.dart';
import 'package:infoTech/features/data/repository/cliente_repository.dart';

class CadastroCliente extends StatefulWidget {
  @override
  _CadastroClienteState createState() => _CadastroClienteState();
}

class _CadastroClienteState extends State<CadastroCliente> {
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

  final ScrollController _scrollController = ScrollController();

  final ClienteRepository cr = ClienteRepository();

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
                                  "Cadastro de Cliente",
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
                                : FormularioCriacaoCliente(
                                    nomeClienteController:
                                        _nomeClienteController,
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
                        Container(
                          padding: const EdgeInsets.only(top: 120.0),
                          child: RaisedButton(
                            color: Theme.of(context).primaryColor,
                            onPressed: () async {
                              await _cadastrarCliente();
                            },
                            child: this._isLoading
                                ? CupertinoActivityIndicator()
                                : Text(
                                    "Cadastar cliente",
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

  Future<void> _cadastrarCliente() async {
    if (this._nomeClienteController.text.isNotEmpty &&
        this._cpfClienteController.text.isNotEmpty &&
        this._logradouroClienteController.text.isNotEmpty &&
        this._numeroClienteController.text.isNotEmpty &&
        this._bairroClienteController.text.isNotEmpty &&
        this._cidadeClienteController.text.isNotEmpty &&
        this._cepClienteController.text.isNotEmpty &&
        this._estadoClienteController.text.isNotEmpty) {
      setState(() {
        _isLoading = true;
      });
      var response = await cr.cadastrarCliente({
        "nome": this._nomeClienteController.text,
        "cpf": this._cpfClienteController.text,
        "logradouro": this._logradouroClienteController.text,
        "numero": this._numeroClienteController.text,
        "bairro": this._bairroClienteController.text,
        "cidade": this._cidadeClienteController.text,
        "cep": this._cepClienteController.text,
        "estado": this._estadoClienteController.text,
      });
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

  void limparCampos() {
    this._nomeClienteController.clear();
    this._cpfClienteController.clear();
    this._logradouroClienteController.clear();
    this._numeroClienteController.clear();
    this._bairroClienteController.clear();
    this._cidadeClienteController.clear();
    this._cepClienteController.clear();
    this._estadoClienteController.clear();
  }
}
