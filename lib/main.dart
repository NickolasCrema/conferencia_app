import 'package:conferencia_de_mercadoria/data/dummydata.dart';
import 'package:conferencia_de_mercadoria/provider/dbConnectionProvider.dart';
import 'package:conferencia_de_mercadoria/provider/ipProvider.dart';
import 'package:conferencia_de_mercadoria/screen/loginScreen.dart';
import 'package:conferencia_de_mercadoria/screen/notaScreen.dart';
import 'package:conferencia_de_mercadoria/screen/notasScreen.dart';
import 'package:conferencia_de_mercadoria/utils/appRoutes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'provider/notaProvider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    Map<int, Color> color = {
      50: Color.fromRGBO(34, 157, 201, .1),
      100: Color.fromRGBO(34, 157, 201, .2),
      200: Color.fromRGBO(34, 157, 201, .3),
      300: Color.fromRGBO(34, 157, 201, .4),
      400: Color.fromRGBO(34, 157, 201, .5),
      500: Color.fromRGBO(34, 157, 201, .6),
      600: Color.fromRGBO(34, 157, 201, .7),
      700: Color.fromRGBO(34, 157, 201, .8),
      800: Color.fromRGBO(34, 157, 201, .9),
      900: Color.fromRGBO(34, 157, 201, 1),
    };
    MaterialColor colorCustom = MaterialColor(0xFF229dc9, color);
    return MultiProvider(
      providers: [
        // ChangeNotifierProvider(
        //   create: (_) => notaProvider(null, DUMMY_NOTES),
        // ),
        ChangeNotifierProvider(
          create: (_) => ipProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => dbConnectionProvider(),
        ),
        ChangeNotifierProxyProvider<dbConnectionProvider, notaProvider>(
            create: (_) => notaProvider(null, '', []),
            update: (ctx, connection, previous) {
              return notaProvider(connection.connection ?? '',
                  connection.user ?? '', previous.notesReturn() ?? []);
            })
      ],
      child: MaterialApp(
        title: 'Conferencia Mercadoria',
        theme: ThemeData(
          fontFamily: "Quicksand",
          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or simply save your changes to "hot reload" in a Flutter IDE).
          // Notice that the counter didn't reset back to zero; the application
          // is not restarted.
          primarySwatch: colorCustom,
        ),
        // home: loginScreen(),
        routes: {
          AppRoutes.AUTH_SCREEN: (ctx) => const loginScreen(),
          AppRoutes.NOTES_SCREEN: (ctx) => const notasScreen(),
          AppRoutes.SPECIFIC_NOTE_SCREEN: (ctx) => const notaScreen(),
        },
      ),
    );
  }
}
