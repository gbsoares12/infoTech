import 'package:flutter/foundation.dart';

class Produto {
  final String id;
  final String descricao;
  final String fabricante;
  final dynamic documentReference;

  Produto(
      {@required this.id,
      @required this.descricao,
      @required this.fabricante,
      @required this.documentReference});
}
