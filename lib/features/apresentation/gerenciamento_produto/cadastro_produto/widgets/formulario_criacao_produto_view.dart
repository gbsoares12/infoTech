import 'package:flutter/material.dart';

class FormularioCriacaoProdutoView extends StatelessWidget {
  final TextEditingController descricaoProdutoController;
  final TextEditingController fabricanteProdutoController;
  final TextEditingController precoProdutoController;

  const FormularioCriacaoProdutoView({
    Key key,
    @required this.descricaoProdutoController,
    @required this.fabricanteProdutoController,
    @required this.precoProdutoController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;

    return Container(
      child: Form(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 80),
            child: TextFormField(
              controller: descricaoProdutoController,
              decoration: InputDecoration(
                labelText: "Descrição do produto",
              ),
            ),
          ),
          SizedBox(
            height: 50,
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 80),
            child: TextFormField(
              controller: fabricanteProdutoController,
              decoration: InputDecoration(
                labelText: "Fabricante do produto",
              ),
            ),
          ),
          SizedBox(
            height: 50,
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 80),
            child: TextFormField(
              controller: precoProdutoController,
              decoration: InputDecoration(
                labelText: "Preco do produto",
              ),
            ),
          ),
        ],
      )),
    );
  }
}
