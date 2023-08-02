import 'package:conferencia_de_mercadoria/provider/notaProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';

import '../model/nota.dart';
import '../model/product.dart';

class productQuantityDialog extends StatefulWidget {
  final Nota nota;
  final Product product;
  const productQuantityDialog(
      {Key key, @required this.nota, @required this.product})
      : super(key: key);

  @override
  State<productQuantityDialog> createState() => _productQuantityDialogState();
}

class _productQuantityDialogState extends State<productQuantityDialog> {
  String _quantity;

  final _formKey = GlobalKey<FormState>();

  void _subtmit() {
    final isValid = _formKey.currentState?.validate() ?? false;

    if (!isValid) {
      return;
    }
    _formKey.currentState?.save();
    Provider.of<notaProvider>(context, listen: false).changeNoteQuantity(
        widget.nota, widget.product, double.tryParse(_quantity));
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.4,
        width: MediaQuery.of(context).size.width * 0.8,
        child: Column(
          children: [
            Container(
              alignment: Alignment.center,
              padding: EdgeInsets.all(10),
              height: 60,
              // color: Colors.grey,
              child: Text(
                "Quantidade",
                style: TextStyle(fontSize: 24),
              ),
            ),
            Divider(height: 0),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    margin: const EdgeInsets.only(bottom: 20),
                    child: Text("${widget.product.codigo}: ${widget.product.name}"),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.5,
                    child: Center(
                      child: Form(
                        key: _formKey,
                        child: TextFormField(
                          decoration: InputDecoration(
                              labelText: "Quantidade",
                              labelStyle: TextStyle(fontSize: 14)),
                          keyboardType: TextInputType.number,
                          onSaved: (_quant) => _quantity = _quant,
                          validator: (_quant) {
                            if (_quant.isEmpty) {
                              return "Insira um valor valido.";
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 0),
            Container(
              height: 60,
              // color: Colors.green,
              margin: EdgeInsets.only(right: 20, bottom: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      _subtmit();
                      Navigator.of(context).pop();
                    },
                    child: Text("Salvar", style: TextStyle(fontSize: 14)),
                  ),
                  const SizedBox(width: 15),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text("Fechar", style: TextStyle(fontSize: 14)),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
