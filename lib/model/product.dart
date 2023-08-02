import 'package:flutter/foundation.dart';

class Product{
  final int id;
  final String name;
  final int codigo;
  double quantidade = 0;
  final String eanCod;
  final int idUnMedida;
  final double fatorConversao;


  Product({
    @required this.id,
    @required this.codigo,
    @required this.name,
    @required this.eanCod,
    @required this.idUnMedida,
    @required this.fatorConversao,
  });
}