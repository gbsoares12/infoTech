import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:infoTech/features/data/repository/produto_repository.dart';

class ProdutosListView extends StatelessWidget {
  final ProdutoRepository pr = ProdutoRepository();
  final ScrollController scrollController;

  ProdutosListView({Key key, @required this.scrollController})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;

    return StreamBuilder<QuerySnapshot>(
        stream: pr.getStreamProdutos(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text("Loading..."),
                  SizedBox(
                    height: 50.0,
                  ),
                  CircularProgressIndicator()
                ],
              ),
            );
          } else {
            return Container(
              height: screenSize.height * 0.6,
              width: screenSize.height * 0.9,
              child: Scrollbar(
                controller: scrollController,
                child: ListView.builder(
                    controller: scrollController,
                    scrollDirection: Axis.vertical,
                    itemCount: snapshot.data.documents.length,
                    itemBuilder: (_, index) {
                      return Container(
                        height: 100,
                        width: 150,
                        child: Card(
                          child: ListTile(
                            title: Text(snapshot
                                .data.documents[index].data["descricao"]),
                            subtitle: Text(snapshot
                                .data.documents[index].data["fabricante"]),
                          ),
                        ),
                      );
                    }),
              ),
            );
          }
        });
  }
}
