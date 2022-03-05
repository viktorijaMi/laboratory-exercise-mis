import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lab3_mis/model/student_exam.dart';
import 'package:lab3_mis/service/authentication_service.dart';
import 'package:lab3_mis/ui/choose_location.dart';
import 'package:lab3_mis/ui/sign_in.dart';

class LaboratoryForm extends StatefulWidget {
  const LaboratoryForm({Key? key, required this.studentExam}) : super(key: key);

  final StudentExam studentExam;

  @override
  _LaboratoryFormState createState() => _LaboratoryFormState();
}

class _LaboratoryFormState extends State<LaboratoryForm> {
  final AuthenticationService _authenticationService = AuthenticationService();
  final TextEditingController laboratoryNameController =
      TextEditingController();

  String laboratoryName = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add laboratory information"), actions: [
        IconButton(
            onPressed: () => this
                ._authenticationService
                .signOut()
                .then((value) => Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => SignInPage()),
                    )),
            icon: Icon(Icons.door_back_door_rounded))
      ]),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "Laboratory Name",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter the laboratory name';
                      }
                    },
                    obscureText: false,
                    onChanged: (value) => {
                          setState(() => {laboratoryName = value})
                        },
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        fillColor: Color(0xfff3f3f4),
                        filled: true))
              ],
            ),
          ),
          Container(
              padding: const EdgeInsets.all(10),
              child: ElevatedButton(
                  onPressed: () => {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (_) => LocationMapScreen(
                                studentExam: this.widget.studentExam,
                                laboratoryName: this.laboratoryName)))
                      },
                  child: Text("Add location"))),
        ],
      ),
    );
  }
}
