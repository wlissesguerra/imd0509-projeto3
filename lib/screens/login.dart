import 'package:alcanceaulas/controller/UserController.dart';
import 'package:alcanceaulas/model/AuthUser.dart';
import 'package:alcanceaulas/model/user.dart';
import 'package:alcanceaulas/utils/routes.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:localstorage/localstorage.dart';
import 'package:local_auth/local_auth.dart';
import 'package:local_auth/error_codes.dart' as auth_error;
import 'package:flutter/services.dart';
import 'dart:io';

class Login extends StatefulWidget {
  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final LocalStorage storage = new LocalStorage('alcanceaulas.json');
  final LocalAuthentication _localAuth = LocalAuthentication();
  final _emailController = TextEditingController();
  final _cpfController = TextEditingController();
  String _loginError = "";
  Future<User>? user;
  void _login() async {
    try {
      var Tryuser = await UserController.login(
          _emailController.text, _cpfController.text);
      print(Tryuser);
      if (Tryuser == null) {
        setState(() {
          _loginError = 'Usuario não encontrado!';
        });
      } else {
        Provider.of<AuthUser>(context, listen: false)
            .login(_emailController.text, _cpfController.text);
        storage.setItem('user', Tryuser);
        Navigator.of(context).pushNamed(AppRoutes.DASHBOARD);
      }
    } catch (e) {
      print("Erro encontrado!");
      print(e);
    }
  }

  Future<void> _checkBiometricSensor() async {
    try {
      var authenticate = await _localAuth.authenticate(
          localizedReason: 'Por favor autentique-se para continuar');
      if (authenticate) {
        Navigator.of(context).pushNamed(AppRoutes.DASHBOARD);
      } else {
        print("impressão digital não identificada.");
      }
    } on PlatformException catch (e) {
      print(e);
      Navigator.of(context).pushNamed(AppRoutes.DASHBOARD);
    }
  }

  @override
  void initState() {
    storage.ready.then((_) {
      final user = storage.getItem('user');
      print(storage);
      print(user);
      if (user == null) {
        print("Nenhum usuário logado!");
      } else {
        _checkBiometricSensor();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.network(
              "https://alcancevendas.com.br/wp-content/uploads/2021/07/UI-Design-Alcance-PaginaCaptura.png",
              width: 250,
            ),
            Padding(
              padding: const EdgeInsets.all(32),
              child: Text(
                "Faça login utilizando os dados que você informou na sua inscrição.",
                style: GoogleFonts.lato(
                    textStyle: Theme.of(context).textTheme.bodyText1),
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(32, 0, 32, 0),
              child: Column(
                children: [
                  TextField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      label: Text("E-mail:"),
                    ),
                  ),
                  const Padding(padding: EdgeInsets.only(bottom: 16)),
                  TextField(
                    controller: _cpfController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      label: Text("CPF:"),
                    ),
                  ),
                  const Padding(padding: EdgeInsets.only(bottom: 16)),
                  (_loginError != "")
                      ? Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 0, 16),
                          child: Text(
                            _loginError,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.lato(
                                textStyle: const TextStyle(
                              color: Colors.red,
                              fontSize: 13,
                            )),
                          ),
                        )
                      : const Text(""),
                  SizedBox(
                    width: 200,
                    height: 40,
                    child: ElevatedButton(
                      onPressed: _login,
                      child: Text(
                        "Entrar".toUpperCase(),
                        style: GoogleFonts.lato(
                          textStyle: Theme.of(context).textTheme.bodyText1,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: ButtonStyle(
                        alignment: Alignment.center,
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(0),
                        )),
                      ),
                    ),
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
