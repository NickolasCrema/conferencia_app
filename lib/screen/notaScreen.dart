import 'package:conferencia_de_mercadoria/provider/notaProvider.dart';
import 'package:conferencia_de_mercadoria/widget/productNoteCard.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';

import '../dialog/productQuantityDialog.dart';
import '../model/nota.dart';
import '../model/product.dart';

class notaScreen extends StatefulWidget {
  const notaScreen({Key key}) : super(key: key);

  @override
  State<notaScreen> createState() => _notaScreenState();
}

class _notaScreenState extends State<notaScreen> {
  FocusNode focusNode = FocusNode();
  @override
  void initState() {
    // TODO: implement initState
    focusNode.canRequestFocus;
    focusNode.addListener(() {
      if (!focusNode.hasFocus && controller.text.isNotEmpty) {
        _search(controller.text);
      }
    });
    super.initState();
  }

  void _search(String text) {
    Nota nota =
        Provider.of<notaProvider>(context, listen: false).getSelectedNote();
    Product product = nota.returnProductByEan(text);
    if (product != null) {
      showDialog(
          context: context,
          builder: (ctx) =>
              productQuantityDialog(nota: nota, product: product));
      controller.clear();
      setState(() {});
    } else {
      _showErrorDialog("Não foi possível localizar o produto.");
    }
    controller.clear();
    setState(() {});
  }

  bool _isLoading = false;
  void _showErrorDialog(String msg) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Ocorreu um erro'),
        content: Text(msg),
        actions: [
          TextButton(
            onPressed: Navigator.of(context).pop,
            child: const Text('Fechar'),
          )
        ],
      ),
    );
  }

  void _submit() async {
    setState(
      () {
        _isLoading = true;
      },
    );
    Nota note =
        Provider.of<notaProvider>(context, listen: false).getSelectedNote();
    await Provider.of<notaProvider>(context, listen: false)
        .updateQuantityDb(note.id)
        .then(
      (_) async {
        await Provider.of<notaProvider>(context, listen: false)
            .getNotesFromdb()
            .then(
          (_) {
            setState(
              () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Salvo com sucesso! Confira no Uniplus."),
                    dismissDirection: DismissDirection.startToEnd,
                  ),
                );
                _isLoading = false;
              },
            );
          },
        ).then((_) => Navigator.of(context).pop());
      },
    );
  }

  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final map = ModalRoute.of(context).settings.arguments as Map;
    final note = map['note'] as Nota;
    final nota = Provider.of<notaProvider>(context).returnNoteById(note.id);

    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text("Nota n° ${nota.numeronotafiscal.toString()}", style: const TextStyle(color: Colors.white)),
        backgroundColor: Color.fromRGBO(18, 14, 49, 1),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.white,
              ),
            )
          : GestureDetector(
              onTap: () {
                FocusScope.of(context).requestFocus(FocusNode());
              },
              child: Container(
                // padding: EdgeInsets.symmetric(vertical: 20),
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(
                          left: 15, right: 15, top: 15, bottom: 25),
                      height: 50,
                      width: MediaQuery.of(context).size.width * 1,
                      child: TextFormField(
                        focusNode: focusNode,
                        controller: controller,
                        decoration: const InputDecoration(
                          labelText: 'Pesquisar',
                          prefixIcon: Icon(Icons.search),
                          labelStyle: TextStyle(fontSize: 14),
                          floatingLabelStyle: TextStyle(fontSize: 10),
                        ),
                        textInputAction: TextInputAction.done,
                        onFieldSubmitted: (text) {
                          _search(text);
                        },
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 15),
                      child: Row(
                        children: [
                          Container(
                            alignment: Alignment.center,
                            width: size.width * 0.2,
                            child: Text("Cod.", style: TextStyle(fontSize: 14)),
                          ),
                          Expanded(child: SizedBox()),
                          Container(
                            alignment: Alignment.center,
                            width: size.width * 0.2,
                            child: Text("Nome", style: TextStyle(fontSize: 14)),
                          ),
                          Expanded(child: SizedBox()),
                          Container(
                            alignment: Alignment.center,
                            width: size.width * 0.2,
                            child: Text(
                              "Quantidade",
                              style: TextStyle(fontSize: 14),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Divider(),
                    Expanded(
                      child: ListView.separated(
                        itemCount: nota.productsCount(),
                        itemBuilder: (ctx, i) => productNoteCard(
                            product: nota.products[i], i: i, nota: nota),
                        separatorBuilder: (ctx, i) => Divider(height: 0),
                      ),
                    ),
                    Divider(height: 0),
                    Container(
                      margin: EdgeInsets.all(15),
                      alignment: Alignment.centerRight,
                      child: IconButton(
                        icon: Icon(Icons.check),
                        onPressed: _submit,
                        color: Color.fromRGBO(39, 183, 235, 1),
                        iconSize: 34,
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
