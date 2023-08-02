import 'package:conferencia_de_mercadoria/provider/dbConnectionProvider.dart';
import 'package:conferencia_de_mercadoria/utils/appRoutes.dart';
import 'package:conferencia_de_mercadoria/widget/notaCard.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';

import '../model/nota.dart';
import '../provider/notaProvider.dart';

class notasScreen extends StatefulWidget {
  const notasScreen();

  @override
  State<notasScreen> createState() => _notasScreenState();
}

class _notasScreenState extends State<notasScreen> {
  final TextEditingController _myController = TextEditingController();

  // final nota = Provider.of<notaProvider>(context, listen: false);

  void _showErrorDialog(String msg) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Impossível prosseguir'),
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

  bool _isLoading = false;

  void closeConnection() {
    Provider.of<dbConnectionProvider>(context, listen: false).closeConnection();
    Provider.of<notaProvider>(context, listen: false).clearNotes();
  }

  @override
  Widget build(BuildContext context) {
    final notes = Provider.of<notaProvider>(context);
    return Scaffold(
      backgroundColor: const Color.fromRGBO(245, 245, 245, 0.90),
      appBar: AppBar(
        title: const Text("Notas", style: TextStyle(color: Colors.white)),
        backgroundColor: Color.fromRGBO(18, 14, 49, 1),
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(
              backgroundColor: Colors.white,
            ))
          : Container(
              color: Color.fromARGB(255, 246, 246, 246),
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: notes.notesCount(),
                      itemBuilder: (ctx, i) => notaCard(
                        nota: notes.notesReturn()[i],
                        i: i,
                        notes: notes,
                      ),
                    ),
                  ),
                  Container(
                    color: Color.fromARGB(255, 255, 255, 255),
                    alignment: Alignment.bottomCenter,
                    height: 100,
                    width: MediaQuery.of(context).size.width * 1,
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            margin: const EdgeInsets.only(right: 10, left: 25),
                            child: ElevatedButton(
                              onPressed: () {
                                Nota nota = notes.getSelectedNote();
                                print(nota);
                                if (nota != null) {
                                  if (nota.conferenciaFisica == 0) {
                                    Navigator.of(context).pushNamed(
                                      AppRoutes.SPECIFIC_NOTE_SCREEN,
                                      arguments: {'note': nota},
                                    );
                                  } else {
                                    _showErrorDialog(
                                        "A nota fiscal de número ${nota.numeronotafiscal} não possui produtos para recontar");
                                  }
                                }
                              },
                              child: const Text(
                                "Iniciar Conferência",
                                style: TextStyle(fontSize: 14, color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          height: 100,
                          width: 100,
                          child: IconButton(
                              icon: Icon(
                                Icons.refresh,
                                color: Color.fromRGBO(39, 183, 235, 1),
                              ),
                              iconSize: 45,
                              onPressed: () async {
                                setState(() {
                                  _isLoading = true;
                                });
                                await Provider.of<notaProvider>(context,
                                        listen: false)
                                    .getNotesFromdb();
                                Future.delayed(Duration(milliseconds: 1500),
                                    () {
                                  setState(() {
                                    _isLoading = false;
                                  });
                                });
                              }),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
