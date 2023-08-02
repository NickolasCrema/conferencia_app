import 'package:conferencia_de_mercadoria/dialog/authDialog.dart';
import 'package:conferencia_de_mercadoria/provider/dbConnectionProvider.dart';
import 'package:conferencia_de_mercadoria/provider/ipProvider.dart';
import 'package:conferencia_de_mercadoria/provider/notaProvider.dart';
import 'package:conferencia_de_mercadoria/screen/notasScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class loginScreen extends StatefulWidget {
  const loginScreen({Key key}) : super(key: key);

  @override
  State<loginScreen> createState() => _loginScreenState();
}

class _loginScreenState extends State<loginScreen> {
  final _formKey = GlobalKey<FormState>();
  String _password;
  String _user;

  bool _isLoading = false;

  void readIpAddress() async {
    await Provider.of<ipProvider>(context, listen: false).readCounter();
  }

  FocusNode _focusNode;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // getStoragePermission().then((permission) {
    //   if (permission == true) {
    setState(() {
      _isLoading = true;
    });
    readIpAddress();
    setState(() {
      _isLoading = false;
    });
    //   }
    // });
  }

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

  Future<bool> _login() async {
    final isValid = _formKey.currentState?.validate() ?? false;
    // final Provider.of<dbConnectionProvider>(context, )
    if (!isValid) {
      return false;
    }
    _formKey.currentState?.save();

    var ip = Provider.of<ipProvider>(context, listen: false).getServerIp();

    setState(() {
      _isLoading = true;
    });

    int flag;

    var result = await Provider.of<dbConnectionProvider>(context, listen: false)
        .createConnection(ip)
        .then((dbConnectionResult) async {
      if (dbConnectionResult[1] == false) {
        _showErrorDialog(dbConnectionResult[0].toString());
        flag = 0;
      } else {
        await Provider.of<dbConnectionProvider>(context, listen: false)
            .login(_user, _password)
            .then((criptPassResult) async {
          if (criptPassResult[1] == false) {
            _showErrorDialog(criptPassResult[0]);
            flag = 0;
          } else {
            await Provider.of<notaProvider>(context, listen: false)
                .getNotesFromdb()
                .then((notaRequest) async {
              if (notaRequest[1] == false) {
                _showErrorDialog(notaRequest[0]);
                flag = 0;
              } else {
                await Provider.of<notaProvider>(context, listen: false)
                    .getNotesFromdb();
              }
            });
          }
        });
      }
    });
    print("flag: " + flag.toString());
    if (flag == 0) {
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: Colors.red.shade400,
      //   title: Text("Conferencia de mercadorias"),
      // ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(backgroundColor: Colors.white12),
            )
          : Container(
              decoration: const BoxDecoration(
                  gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color.fromRGBO(18, 14, 49, 1),
                  Color.fromARGB(255, 26, 20, 70),
                  Color.fromARGB(255, 36, 28, 95),
                  // Color.fromRGBO(18, 14, 49, 1),
                  // Color.fromRGBO(18, 14, 49, 1),
                  // Color.fromRGBO(18, 14, 49, 0.8),
                  // Color.fromRGBO(18, 14, 49, 0.7),
                  Color.fromARGB(255, 22, 116, 150),
                  Color.fromARGB(255, 34, 157, 201),

                  Color.fromRGBO(39, 183, 235, 1),
                ],
              )),
              height: MediaQuery.of(context).size.height * 1,
              width: MediaQuery.of(context).size.width * 1,
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 60),
                    width: MediaQuery.of(context).size.width * 1,
                    height: 100,
                    // color: Colors.black,
                    child: Center(
                      child: Container(
                        width: 110,
                        height: 90,
                        child: Image.asset("imagens/logo.png"),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 4,
                          color: Colors.white12,
                        ),
                        borderRadius: const BorderRadius.all(
                          Radius.circular(15),
                        ),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black87.withOpacity(0.5),
                            spreadRadius: 3,
                            blurRadius: 7,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      margin: const EdgeInsets.only(top: 10, bottom: 25),
                      // color: Colors.white70,
                      width: MediaQuery.of(context).size.width * 0.85,
                      child: Column(
                        children: [
                          Container(
                            // height: 100,
                            margin: const EdgeInsets.only(top: 25, bottom: 10),
                            width: MediaQuery.of(context).size.width * 1,
                            child: Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Expanded(child: SizedBox(), flex: 7),
                                  Container(
                                    child: Column(
                                      // crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          'Conferência',
                                          style: TextStyle(fontSize: 28, fontFamily: "Quicksand", fontWeight: FontWeight.w700),
                                        ),
                                        const Text("de mercadoria", style: TextStyle(fontSize: 20, fontFamily: "Quicksand"))
                                      ],
                                    ),
                                  ),
                                  const Expanded(child: SizedBox(), flex: 4),
                                  Container(
                                    margin: const EdgeInsets.only(right: 15),
                                    child: IconButton(
                                        onPressed: () async {
                                          await readIpAddress();
                                          showDialog(
                                              context: context,
                                              builder: (ctx) => authDialog());
                                        },
                                        icon: Icon(
                                          Icons.settings_rounded,
                                          color: Colors.blueGrey.shade400,
                                          size: 34,
                                          shadows: const [
                                            BoxShadow(
                                              color: Colors.black26,
                                              blurRadius: 5,
                                              spreadRadius: 4,
                                              offset: Offset(1, 1),
                                            )
                                          ],
                                        )),
                                  )
                                ],
                              ),
                            ),
                          ),
                          const Divider(),
                          Container(
                            margin: const EdgeInsets.only(
                                right: 40, left: 20, top: 15),
                            child: Column(
                              children: [
                                Form(
                                  key: _formKey,
                                  child: Column(
                                    children: [
                                      TextFormField(
                                          focusNode: _focusNode,
                                          decoration: InputDecoration(
                                            label: Text("User"),
                                            icon: Icon(Icons.person),
                                          ),
                                          onSaved: (user) => _user = user ?? '',
                                          validator: (user) {
                                            String username = user ?? '';
                                            if (username.isEmpty) {
                                              return "O campo user não pode estar vázio.";
                                            }
                                            return null;
                                          },
                                          textInputAction:
                                              TextInputAction.next),
                                      const SizedBox(height: 10),
                                      TextFormField(
                                        focusNode: _focusNode,
                                        decoration: InputDecoration(
                                          label: Text("Senha"),
                                          icon: Icon(Icons.key),
                                        ),
                                        obscureText: true,
                                        onSaved: (pass) =>
                                            _password = pass ?? '',
                                        validator: (pass) {
                                          String _pass = pass;
                                          if (_pass.isEmpty) {
                                            return "O campo senha não pode estar vázio.";
                                          }
                                          return null;
                                        },
                                        textInputAction: TextInputAction.done,
                                        onFieldSubmitted: (value) async {
                                          await _login().then((value) {
                                            Future.delayed(
                                                Duration(milliseconds: 1000),
                                                () => setState(() {
                                                      _isLoading = false;
                                                    }));
                                            if (value == true) {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        const notasScreen()),
                                              );
                                            }
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            height: 100,
                            // color: Colors.amberAccent,
                            margin: EdgeInsets.only(top: 15),
                            child: Center(
                              child: ElevatedButton(
                                onPressed: () async {
                                  // await _login().then((value) {
                                  //   Navigator.push(
                                  //     context,
                                  //     MaterialPageRoute(
                                  //         builder: (context) => const notasScreen()),
                                  //   );
                                  // });
                                  // await _login();

                                  await _login().then((value) {
                                    Future.delayed(
                                        Duration(milliseconds: 1000),
                                        () => setState(() {
                                              _isLoading = false;
                                            }));
                                    if (value == true) {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const notasScreen()),
                                      );
                                    }
                                  });
                                },
                                child: const Text(
                                  "Entrar",
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
