import 'package:flutter/material.dart';

class FormularioCriacaoCliente extends StatelessWidget {
  final TextEditingController nomeClienteController;
  final TextEditingController cpfClienteController;
  final TextEditingController logradouroClienteController;
  final TextEditingController numeroClienteController;
  final TextEditingController bairroClienteController;
  final TextEditingController cidadeClienteController;
  final TextEditingController cepClienteController;
  final TextEditingController estadoClienteController;
  final bool readOnly;

  const FormularioCriacaoCliente({
    Key key,
    @required this.nomeClienteController,
    @required this.cpfClienteController,
    @required this.logradouroClienteController,
    @required this.numeroClienteController,
    @required this.bairroClienteController,
    @required this.cidadeClienteController,
    @required this.cepClienteController,
    @required this.estadoClienteController,
    this.readOnly = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;

    return Container(
      child: Form(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Nome e Cpf
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 80, vertical: 25),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  width: screenSize.width * 0.15,
                  child: TextFormField(
                    readOnly: readOnly,
                    controller: nomeClienteController,
                    decoration: InputDecoration(
                      labelText: "Nome",
                    ),
                  ),
                ),
                Container(
                  width: screenSize.width * 0.1,
                  child: TextFormField(
                    readOnly: readOnly,
                    controller: cpfClienteController,
                    decoration: InputDecoration(
                      labelText: "CPF",
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Logradouro e Numero
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 80, vertical: 25),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  width: screenSize.width * 0.15,
                  child: TextFormField(
                    readOnly: readOnly,
                    controller: logradouroClienteController,
                    decoration: InputDecoration(
                      labelText: "Logradouro",
                    ),
                  ),
                ),
                Container(
                  width: screenSize.width * 0.1,
                  child: TextFormField(
                    readOnly: readOnly,
                    controller: numeroClienteController,
                    decoration: InputDecoration(
                      labelText: "Número",
                    ),
                  ),
                ),
              ],
            ),
          ),
          //cidade e bairro
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 80, vertical: 25),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  width: screenSize.width * 0.15,
                  child: TextFormField(
                    readOnly: readOnly,
                    controller: cidadeClienteController,
                    decoration: InputDecoration(
                      labelText: "Cidade",
                    ),
                  ),
                ),
                Container(
                  width: screenSize.width * 0.1,
                  child: TextFormField(
                    readOnly: readOnly,
                    controller: bairroClienteController,
                    decoration: InputDecoration(
                      labelText: "Bairro",
                    ),
                  ),
                ),
              ],
            ),
          ),
          //Cep e estado
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 80, vertical: 25),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  width: screenSize.width * 0.15,
                  child: TextFormField(
                    readOnly: readOnly,
                    controller: cepClienteController,
                    decoration: InputDecoration(
                      labelText: "Cep",
                    ),
                  ),
                ),
                Container(
                  width: screenSize.width * 0.1,
                  child: TextFormField(
                    readOnly: readOnly,
                    controller: estadoClienteController,
                    decoration: InputDecoration(
                      labelText: "Estado",
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      )),
    );
  }
}
