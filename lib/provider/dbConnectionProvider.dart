import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bcrypt/flutter_bcrypt.dart';
import 'package:postgres/postgres.dart';
import 'package:postgres/postgres.dart';

class dbConnectionProvider with ChangeNotifier {
  var connection;
  String user;

  Future<Map<int, dynamic>> createConnection(String ip) async {
    try {
      connection = PostgreSQLConnection(ip, '****', "*****",
          username: "*******", password: "*******");
      await connection.open();
      return {0: 'NOERROR', 1: true};
    } on SocketException catch (error) {
      return {
        0: 'Houve um erro ao tentar se conectar com o banco, verifique o endereço de ip nas configurações. $error',
        1: false
      };
    } on Exception catch (error){
      return {
        0: 'Houve um erro insperado ao tentar se conectar com o banco. $error',
        1: false
      };
    }
  }

  Future<Map<int, dynamic>> login(String username, String password) async {
    try {
      user = username;
      var _password = await connection.query(
          "SELECT ***** FROM ******** where ******** = CAST($username AS VARCHAR(10))"
          );

      var result =
          await FlutterBcrypt.verify(password: password, hash: _password[0][0]);

      if (result == false) {
        return {0: 'Usuário ou senha inválido, tente novamente.', 1: false};
      }
      return {0: 'NOERROR', 1: true};
    } on RangeError catch (error) {
      return {0: 'Usuário ou senha inválido, tente novamente.', 1: false};
    } on Exception catch (error) {
      return {0: 'Ocorreu um erro interno inesperado:\n: $error', 1: false};
    }
  }

  Future<Map<int, dynamic>> criptPass(String pass) async {
    try {
      var result = await FlutterBcrypt.verify(
          password: pass,
          hash:
              //******
              );
      if (result == false) {
        return {0: 'Senha inválida.', 1: false};
      }
      return {0: 'NOERROR', 1: true};
    } on Exception catch (error) {
      return {0: 'Um erro inesperado ocorreu: $error', 1: false};
    }
  }

  void closeConnection(){
    connection = null;
  }
}
