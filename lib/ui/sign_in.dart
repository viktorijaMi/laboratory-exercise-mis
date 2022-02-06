import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lab3_mis/model/notifier/user_notifier.dart';
import 'package:lab3_mis/providers/global_providers.dart';
import 'package:lab3_mis/service/authentication_service.dart';
import 'package:lab3_mis/ui/home_page.dart';
import 'package:lab3_mis/ui/main.dart';
import 'package:lab3_mis/ui/register.dart';
import 'package:provider/src/provider.dart';

class SignInPage extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final AuthenticationService _authenticationService = AuthenticationService();

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (ctx, ref, children) {
      UserNotifier userNotifier = ref.watch(userProvider)!.state;
      return Padding(
          padding: const EdgeInsets.all(10),
          child: Scaffold(
              body: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.all(10),
                      child: const Text(
                        'Student Exam Organizer',
                        style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.w500,
                            fontSize: 30),
                      )),
                  SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.all(10),
                    child: TextField(
                      controller: emailController,
                      decoration: InputDecoration(
                        labelText: "Email",
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    child: TextField(
                      controller: passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: "Password",
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  Container(
                      height: 50,
                      width: 450,
                      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                      child: ElevatedButton(
                        child: const Text('Login'),
                        onPressed: () {
                          _authenticationService
                              .signIn(
                              email: emailController.text,
                              password: passwordController.text)
                              .then((value) =>
                          {
                            userNotifier.setUser(value.user),
                            Navigator.of(context).popUntil(
                                    (route) => route.settings.name == '/')
                          });
                        },
                      )),
                  Row(
                    children: <Widget>[
                      const Text('Does not have account?'),
                      TextButton(
                        child: const Text(
                          'Register here',
                          style: TextStyle(fontSize: 15),
                        ),
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => RegisterPage()));
                        },
                      )
                    ],
                    mainAxisAlignment: MainAxisAlignment.center,
                  ),
                ],
              )));
    });
  }
}
