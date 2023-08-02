import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../provider/ipProvider.dart';
import 'package:provider/provider.dart';


// ignore: camel_case_types
class authDialog extends StatefulWidget {
  const authDialog({Key key}) : super(key: key);

  @override
  State<authDialog> createState() => _authDialogState();
}

class _authDialogState extends State<authDialog> {
  FocusNode focusNode = FocusNode();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _passKey = GlobalKey<FormState>();

  Map<String, String> _authData = {
    'password': '',
    'serverIp': '',
  };

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    focusNode.addListener(() {
      focusNode.canRequestFocus;
      focusNode.addListener(() {
        if (!focusNode.hasFocus && _passwordController.text.isNotEmpty) {
          _onFieldSubmited(_passwordController.text);
        }
      });
    });
  }

  final _pass = ****

  Future<void> _submit() async {
    final isValid = _formKey.currentState?.validate() ?? false;

    if (!isValid) {
      return;
    }

    _formKey.currentState?.save();
    await Provider.of<ipProvider>(context, listen: false)
        .writeCounter(_authData['serverIp'])
        .then(
      (_) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Endereço ip salvo com sucesso!"),
            dismissDirection: DismissDirection.startToEnd,
          ),
        );
        Navigator.of(context).pop();
      },
    );
  }

  void _onFieldSubmited(String pass) {
    final isValid = _passKey.currentState?.validate() ?? false;
    if (!isValid) {
      return;
    } else {
      if (int.tryParse(pass) == _pass) {
        setState(() {
          _showIpConfig = true;
        });
      }
    }
  }

  bool _showIpConfig = false;

  @override
  Widget build(BuildContext context) {
    final ip = Provider.of<ipProvider>(context);
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Dialog(
        backgroundColor: Color.fromRGBO(235, 235, 235, 1),
        elevation: 1,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.57,
          child: Column(
            children: [
              Container(
                decoration: const BoxDecoration(
                  color: Color.fromRGBO(240, 240, 240, 1),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 7,
                      spreadRadius: 3,
                      offset: Offset(1, 1),
                    )
                  ],
                ),
                width: MediaQuery.of(context).size.width * 1,
                height: 65,
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 15),
                  child: Center(
                    child: Row(
                      children: [
                        const Expanded(child: SizedBox(), flex: 7),
                        const Text(
                          "Configurações",
                          style: TextStyle(fontSize: 24),
                        ),
                        const Expanded(child: SizedBox(), flex: 4),
                        IconButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          icon: const Icon(
                            Icons.close_outlined,
                            color: Colors.red,
                            shadows: [
                              BoxShadow(
                                  color: Colors.black26,
                                  blurRadius: 7,
                                  spreadRadius: 3,
                                  offset: Offset(1, 1))
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const Expanded(child: SizedBox(), flex: 2),
              Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Form(
                        key: _passKey,
                        child: _showIpConfig
                            ? Container()
                            : TextFormField(
                                focusNode: focusNode,
                                decoration: InputDecoration(labelText: "Senha"),
                                keyboardType: TextInputType.number,
                                controller: _passwordController,
                                obscureText: true,
                                onSaved: (_password) =>
                                    _authData['password'] = _password ?? '',
                                validator: (_password) {
                                  final password = _password ?? '';
                                  if (password.isEmpty) {
                                    return 'A senha não pode estar vázia.';
                                  }
                                  if (password.toString() != _pass.toString()) {
                                    return 'Senha inválida';
                                  }
                                  return null;
                                },
                                textInputAction: TextInputAction.done,
                                onFieldSubmitted: (pass) {
                                  _onFieldSubmited(pass);
                                },
                              ),
                      ),
                      _showIpConfig == true
                          ? TextFormField(
                              decoration:
                                  InputDecoration(labelText: "Ip do servidor"),
                              keyboardType: TextInputType.number,
                              initialValue: ip.getServerIp(),
                              onSaved: (_serverIp) =>
                                  _authData['serverIp'] = _serverIp ?? '',
                              validator: (_serverIp) {
                                final serverIp = _serverIp ?? '';
                                return null;
                              },
                              textInputAction: TextInputAction.done)
                          : Container(),
                    ],
                  ),
                ),
              ),
              Expanded(child: SizedBox(), flex: 3),
              Container(
                decoration: const BoxDecoration(
                  color: Color.fromRGBO(240, 240, 240, 1),
                  borderRadius:
                      BorderRadius.vertical(bottom: Radius.circular(15)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 7,
                      spreadRadius: 3,
                      offset: Offset(1, 1),
                    )
                  ],
                ),
                width: MediaQuery.of(context).size.width * 1,
                height: 65,
                child: Container(
                  margin: const EdgeInsets.only(right: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      _showIpConfig
                          ? TextButton(
                              onPressed: () {
                                _submit();
                              },
                              child: const Text(
                                "Salvar",
                                style: TextStyle(fontSize: 18),
                              ),
                            )
                          : TextButton(
                              onPressed: () {
                                _onFieldSubmited(_passwordController.text);
                              },
                              child: const Text(
                                "Ok",
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                      const SizedBox(width: 15),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text(
                          "Fechar",
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
