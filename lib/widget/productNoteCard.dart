import 'package:conferencia_de_mercadoria/dialog/productQuantityDialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../model/nota.dart';
import '../model/product.dart';

class productNoteCard extends StatelessWidget {
  final Product product;
  final int i;
  final Nota nota;
  const productNoteCard({Key key, @required this.product, @required this.i, @required this.nota}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        showDialog(context: context, builder: (ctx) => productQuantityDialog(nota: nota, product: product));
      },
      child: Container(
        color: i % 2 == 0 ? Colors.white : Colors.grey[100],
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 25),
        child: Row(
          children: [
            Container(
              alignment: Alignment.center,
              width: size.width * 0.2,
              child:
                  Text(product.codigo.toString(), style: TextStyle(fontSize: 16)),
            ),
            Expanded(child: SizedBox()),
            Container(
              alignment: Alignment.center,
              width: size.width * 0.3,
              child: Text(product.name, style: TextStyle(fontSize: 16)),
            ),
            Expanded(child: SizedBox()),
            Container(
              alignment: Alignment.center,
              width: size.width * 0.2,
              child: Text(
                product.quantidade.toStringAsFixed(0),
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
