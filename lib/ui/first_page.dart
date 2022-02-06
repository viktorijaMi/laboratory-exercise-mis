import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lab3_mis/ui/register.dart';
import 'package:lab3_mis/ui/sign_in.dart';

class FirstPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(10),
        child: Scaffold(
            body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
                Container(
                height: 50,
                width: 300,
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: ElevatedButton(
                  onPressed: () => {
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) => SignInPage()))
                  },
                  child: Text("Sign in"),
                ),
                ),
            SizedBox(height: 10),
            Container(
              height: 50,
              width: 300,
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: ElevatedButton(
                onPressed: () => {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => RegisterPage()))
                },
                child: Text("Register"),
              ),
            ),
          ],
        )));
  }
}
