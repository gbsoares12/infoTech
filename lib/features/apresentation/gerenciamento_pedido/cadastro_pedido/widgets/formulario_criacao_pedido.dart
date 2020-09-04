import 'package:flutter/material.dart';

class FormularioCriacaoPedido extends StatelessWidget {
  final Map<String, dynamic> pedidoJson;

  const FormularioCriacaoPedido({
    Key key,
    @required this.pedidoJson,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;

    return Container(
      child: Form(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [Container()],
      )),
    );
  }
}
