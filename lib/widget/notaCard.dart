import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';
import '../model/nota.dart';
import '../provider/notaProvider.dart';

class notaCard extends StatelessWidget {
  final Nota nota;
  final int i;
  final notes;
  const notaCard(
      {Key key, @required this.nota, @required this.i, @required this.notes})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final notes = Provider.of<notaProvider>(context);
    return GestureDetector(
      onTap: () {
        if (nota.selected) {
          notes.unselectAllNotes();
        } else {
          notes.selectNote(nota.id);
        }
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
        decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(
              Radius.circular(5),
            ),
            boxShadow: [
              BoxShadow(
                  color: Colors.black12,
                  blurRadius: 3,
                  spreadRadius: 2,
                  offset: Offset(1, 1)),
            ]),
        width: MediaQuery.of(context).size.width * 0.95,
        // height: 100,
        child: Column(
          children: [
            Consumer<notaProvider>(
              builder: (_, notes, child) => child,
              child: Container(
                width: MediaQuery.of(context).size.width * 1,
                // height: 20,
                // margin: EdgeInsets.only(left: 20, right: 20, top: 15),
                // padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: nota.conferenciaFisica == 0
                        ? nota.conferenciaFinanceira == 1
                            ? Color.fromARGB(255, 255, 225, 225)
                            // ? const Color.fromRGBO(255, 0, 0, 0.5)
                            : Color.fromARGB(255, 218, 218, 218)
                        : Color.fromARGB(241, 205, 255, 205),
                    // : Colors.greenAccent.shade200,
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(5))),
                child: Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  child: Row(
                    children: [
                      Text(
                        nota.numeronotafiscal.toString(),
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const Expanded(child: SizedBox()),
                      Text(
                        nota.date,
                        style: const TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Divider(
              height: 0,
              thickness: 1.5,
              color: nota.conferenciaFisica == 0
                  ? nota.conferenciaFinanceira == 1
                      ? const Color.fromRGBO(255, 0, 0, 0.5)
                      : Colors.blueGrey.shade700
                  : Colors.greenAccent.shade200,
            ),
            Row(
              children: [
                Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(
                          left: 20, right: 15, top: 15, bottom: 20),
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: Text(
                        nota.razaosocial,
                        style: const TextStyle(fontSize: 20),
                      ),
                    ),
                  ],
                ),
                nota.selected
                    ? Icon(
                        Icons.radio_button_checked_outlined,
                        color: Color.fromARGB(255, 34, 157, 201),
                        shadows: const [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 3,
                            spreadRadius: 3,
                            offset: Offset(1, 1),
                          )
                        ],
                      )
                    : Icon(
                        Icons.circle_outlined,
                        color: Color.fromARGB(255, 47, 37, 125),
                        shadows: const [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 3,
                            spreadRadius: 3,
                            offset: Offset(1, 1),
                          )
                        ],
                      ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
