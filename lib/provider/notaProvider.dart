import 'package:conferencia_de_mercadoria/data/dummydata.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:postgres/postgres.dart';
import '../model/nota.dart';
import '../model/product.dart';

class notaProvider with ChangeNotifier {
  List<Nota> _notas = [];

  var _connection;
  String _username;

  notaProvider(this._connection, this._username, this._notas);

  Future<Map<int, dynamic>> getNotesFromdb() async {
    try {
      var result = await _connection
          .query("""
                ********* SQL SELECT *********
          """, substitutionValues: {
        'doc': 'E',
        'conf': '0',
      });

      print('resultado: ' + result.toString());
      _notas.clear();
      for (var nota in result) {
        if (!noteAlreadyExists(nota[0])) {
          _notas.add(
            Nota(
              id: nota[0],
              date: DateFormat('dd-MM-yyyy').format(nota[3]),
              numeronotafiscal: int.tryParse(nota[1]),
              razaosocial: nota[2],
              conferenciaFisica: nota[4],
              conferenciaFinanceira: nota[5],
              idfilial: nota[11],
              products: [
                Product(
                  id: nota[6],
                  name: nota[7],
                  eanCod: nota[8],
                  codigo: int.tryParse(nota[9]),
                  idUnMedida: nota[10],
                  fatorConversao: double.tryParse(nota[12]),
                ),
              ],
            ),
          );
        } else {
          addProductToNote(
            Product(
                id: nota[6],
                name: nota[7],
                eanCod: nota[8],
                codigo: int.tryParse(nota[9]),
                idUnMedida: nota[10],
                fatorConversao: double.tryParse(nota[12])),
            nota[0],
          );
        }
      }
      orderNotes();
    } on Exception catch (error) {
      return {0: 'Ocorreu um erro interno inesperado:\n $error', 1: false};
    }
    notifyListeners();
    return {0: 'NOERROR', 1: true};
  }

  void orderNotes(){
    for(int i=0; i<_notas.length; i++){
      for(int j=i; j<_notas.length; j++){
        if(_notas[i].conferenciaFinanceira > _notas[j].conferenciaFinanceira || (_notas[i].conferenciaFisica >= _notas[j].conferenciaFisica)){
          Nota temp = _notas[j];
          _notas[j] = _notas[i];
          _notas[i] = temp;
        }
      }
    }
  }

  Future<void> updateQuantityDb(int id) async {
    try {
      Nota note = getSelectedNote();
      print(note.id);
      for (var product in note.products) {
        print(
            '${note.id} ${int.tryParse(_username)} ${DateTime.now()} ${DateTime.now().millisecondsSinceEpoch} ${note.idfilial}');
        await _connection.transaction(
          (ctx) async {
            var result = await ctx.query(
              """
                ********* SQL INSERT *********
          VALUES
          (@idnota, @idusuario, @data, @curtime, @idfilial, @cod)
          RETURNING id""",
              substitutionValues: {
                'idnota': note.id,
                'idusuario': int.tryParse(_username),
                'data': DateTime.now(),
                'curtime': DateTime.now().microsecondsSinceEpoch,
                'idfilial': note.idfilial,
                'codigo': _username,
              },
            );
            print(result);
            result = result[0][0];
            if (result != null) {
              await ctx.query(
                """
                  ********* SQL INSERT *********
            VALUES
            (@idconf, @idprod, @idunidade, @qtd, @variacoes, @lote, @nserie, @curtime, @fatconversao)""",
                substitutionValues: {
                  'idconf': result,
                  'idprod': product.id,
                  'idunidade': product.idUnMedida,
                  'qtd': product.quantidade,
                  'variacoes': '',
                  'lote': '',
                  'nserie': '',
                  'curtime': DateTime.now().microsecondsSinceEpoch,
                  'fatconversao': product.fatorConversao,
                },
              );
              await ctx.query(
                """
              UPDATE *******
              SET ******* = @value1
              WHERE ****** = @id""",
                substitutionValues: {
                  'value1': 1,
                  'id': note.id,
                },
              );
            }
            note.conferenciaFisica = 1;
          },
        );
      }
    } on Exception catch (error) {
      PostgreSQLRollback;
      print(error);
    }
  }

  bool noteAlreadyExists(int id) {
    for (var nota in _notas) {
      if (nota.getId() == id) {
        return true;
      }
    }
    return false;
  }

  void addProductToNote(Product product, int idNota) {
    for (var nota in _notas) {
      if (nota.id == idNota) {
        nota.products.add(product);
      }
    }
    notifyListeners();
  }

  int notesCount() {
    return _notas.length;
  }

  List<Nota> notesReturn() {
    return [..._notas];
  }

  void selectNote(int id) {
    Nota note;
    for (var nota in _notas) {
      nota.unselectNote();
      if (nota.id == id) {
        note = nota;
      }
    }
    note.selectNote();
    notifyListeners();
  }

  Nota getSelectedNote() {
    Nota nota;
    for (var element in _notas) {
      if (element.selected == true) {
        nota = element;
      }
    }
    return nota;
  }

  void unselectAllNotes() {
    for (var element in _notas) {
      element.unselectNote();
    }
    notifyListeners();
  }

  void changeNoteQuantity(Nota nota, Product product, double quantidade) {
    for (var element in _notas) {
      if (element.id == nota.id) {
        for (var prod in element.products) {
          if (prod.id == product.id) {
            prod.quantidade = quantidade;
          }
        }
      }
    }
    notifyListeners();
  }

  Nota returnNoteById(int id) {
    for (var element in _notas) {
      if (element.id == id) {
        return element;
      }
    }
  }

  void clearNotes() {
    _notas.clear();
    notifyListeners();
  }
}
