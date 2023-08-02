import 'package:conferencia_de_mercadoria/model/product.dart';
import 'package:flutter/material.dart';

class Nota{
  final int id;
  final int numeronotafiscal;
  final String razaosocial;
  final String date;
  final List<Product> products;
  int conferenciaFisica;
  int conferenciaFinanceira;
  final int idfilial;
  bool selected;



  Nota({
    @required this.id,
    @required this.numeronotafiscal,
    @required this.razaosocial,
    @required this.date,
    @required this.products,
    @required this.conferenciaFisica,
    @required this.conferenciaFinanceira,
    @required this.idfilial,
    this.selected = false,
  });



  int getId(){
    return id;
  }

  void selectNote(){
    selected = true;
  }

  void unselectNote(){
    selected = false;
  }

  int productsCount(){
    return products.length;
  }

  Product returnProductById(int id){
    Product p;
    for(var prod in products){
      if(prod.id == id){
        p = prod;
      }
    }
    return p;
  }

  Product returnProductByEan(String cod){
    Product p;
    for(var prod in products){
      if(prod.eanCod == cod){
        p = prod;
      }
    }
    for(var prod in products){
      if(prod.codigo == int.tryParse(cod)){
        p = prod;
      }
    }
    return p;
  }

}